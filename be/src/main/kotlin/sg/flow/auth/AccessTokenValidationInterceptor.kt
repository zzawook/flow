package sg.flow.auth

import io.grpc.*
import io.grpc.Contexts
import kotlinx.coroutines.runBlocking
import org.springframework.security.authentication.BadCredentialsException
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.context.SecurityContextHolder
import sg.flow.services.AuthServices.FlowTokenService
import sg.flow.models.auth.FlowUserDetails

// gRPC Context key for carrying authenticated user details
object GrpcSecurityContext {
    val USER_DETAILS: Context.Key<FlowUserDetails> = Context.key("userDetails")
}

class AccessTokenValidationInterceptor(
    private val tokenService: FlowTokenService,
    private val subscriptionEntitlementService: sg.flow.services.SubscriptionServices.SubscriptionEntitlementService?
) : ServerInterceptor {

    private val authHeader =
        Metadata.Key.of("Authorization", Metadata.ASCII_STRING_MARSHALLER)
    private val platformHeader =
        Metadata.Key.of("X-Platform", Metadata.ASCII_STRING_MARSHALLER)

    // Public RPCs that DON'T require a token
    private val publicMethods = setOf(
        "sg.flow.auth.v1.AuthService/SignUp",
        "sg.flow.auth.v1.AuthService/SignIn",
        "sg.flow.auth.v1.AuthService/GetAccessTokenByRefreshToken",
        "sg.flow.auth.v1.AuthService/CheckUserExists",
        "sg.flow.auth.v1.AuthService/SendVerificationEmail"
    )
    
    // Subscription methods that don't require active subscription
    private val subscriptionMethods = setOf(
        "subscription.v1.SubscriptionService/CheckEntitlement",
        "subscription.v1.SubscriptionService/GetSubscriptionStatus",
        "subscription.v1.SubscriptionService/StartTrial",
        "subscription.v1.SubscriptionService/LinkPurchase"
    )

    override fun <ReqT, RespT> interceptCall(
        call: ServerCall<ReqT, RespT>,
        headers: Metadata,
        next: ServerCallHandler<ReqT, RespT>
    ): ServerCall.Listener<ReqT> {
        val fullMethod = call.methodDescriptor.fullMethodName
        var userDetails: FlowUserDetails? = null

        if (fullMethod !in publicMethods) {
            val bearer = headers[authHeader]
                ?: throw Status.UNAUTHENTICATED
                    .withDescription("Missing Authorization header")
                    .asRuntimeException()

            if (!bearer.startsWith("Bearer ")) {
                throw Status.UNAUTHENTICATED
                    .withDescription("Invalid Authorization header")
                    .asRuntimeException()
            }

            val accessToken = bearer.removePrefix("Bearer ").trim()

            // Validate and load the user details
            userDetails = runBlocking {
                tokenService.getUserDetailByAccessToken(accessToken)
                    ?: throw BadCredentialsException("Invalid/expired token")
            }

            // Optionally set Spring Security context if other code relies on it
            val authToken = UsernamePasswordAuthenticationToken(
                userDetails, null, userDetails.authorities
            )
            SecurityContextHolder.getContext().authentication = authToken
            
            // Check subscription entitlement (if not a subscription-related method)
            if (subscriptionEntitlementService != null && fullMethod !in subscriptionMethods) {
                val platformValue = headers[platformHeader] ?: "IOS"
                val platform = try {
                    sg.flow.entities.utils.Platform.valueOf(platformValue)
                } catch (e: Exception) {
                    sg.flow.entities.utils.Platform.IOS
                }
                
                val hasAccess = runBlocking {
                    subscriptionEntitlementService.hasActiveAccess(userDetails.userId, platform)
                }
                
                if (!hasAccess) {
                    throw Status.PERMISSION_DENIED
                        .withDescription("Subscription required or expired")
                        .asRuntimeException()
                }
            }
        }

        // Propagate authenticated user via gRPC Context
        val ctx = if (userDetails != null) {
            Context.current().withValue(GrpcSecurityContext.USER_DETAILS, userDetails)
        } else {
            Context.current()
        }

        return Contexts.interceptCall(ctx, call, headers, next)
    }
}
