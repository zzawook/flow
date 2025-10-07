import 'package:grpc/grpc.dart';

class GrpcInterceptor extends ClientInterceptor {
  static String _accessToken = "";

  static void setAccessToken(String accessToken) {
    _accessToken = accessToken;
  }

  CallOptions _withAuth(CallOptions options) {
    return options.mergedWith(
      CallOptions(metadata: {'Authorization': 'Bearer $_accessToken'}),
    );
  }

  @override
  ResponseFuture<Response> interceptUnary<Request, Response>(
    ClientMethod<Request, Response> method,
    Request request,
    CallOptions options,
    invoker,
  ) {
    return invoker(method, request, _withAuth(options));
  }
}
