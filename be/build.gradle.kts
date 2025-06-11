import com.google.protobuf.gradle.*

plugins {
	java
	id("org.springframework.boot") version "3.4.0"
	id("io.spring.dependency-management") version "1.1.6"
	kotlin("jvm") version "1.9.22"
	kotlin("plugin.spring") version "1.9.22"
	kotlin("plugin.noarg") version "1.9.22"
	kotlin("plugin.allopen") version "1.9.22"
	id("com.google.protobuf") version "0.9.4"
	id("io.gitlab.arturbosch.detekt") version "1.23.5"
}

group = "sg"
version = "0.0.1-SNAPSHOT"

detekt {
	config.setFrom(files("$rootDir/detekt.yml"))
	buildUponDefaultConfig = true
	allRules = false
}

java {
	toolchain {
		languageVersion.set(JavaLanguageVersion.of(21))
	}
}

repositories {
	mavenCentral()
}

dependencies {
	// Spring core
	implementation("org.springframework.boot:spring-boot-starter-data-r2dbc")
	implementation("org.springframework.boot:spring-boot-starter-data-redis")
	implementation("org.springframework.boot:spring-boot-starter-mail")
	implementation("org.springframework.boot:spring-boot-starter-oauth2-client")
	implementation("org.springframework.boot:spring-boot-starter-oauth2-resource-server")
	implementation("org.springframework.boot:spring-boot-starter-security")
	implementation("org.springframework.boot:spring-boot-starter-web")
	implementation("org.springframework.boot:spring-boot-starter-webflux")
	implementation("org.springframework.boot:spring-boot-starter-validation")

	// Kotlin + coroutines
	implementation("org.jetbrains.kotlin:kotlin-reflect")
	implementation(platform("org.jetbrains.kotlinx:kotlinx-coroutines-bom:1.7.3"))
	implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core")
	implementation("org.jetbrains.kotlinx:kotlinx-coroutines-reactor")

	// R2DBC
	implementation("org.postgresql:r2dbc-postgresql:1.0.7.RELEASE")
	implementation("io.r2dbc:r2dbc-pool")

	// JWT, MapStruct
	implementation("com.auth0:java-jwt:4.4.0")

	// gRPC + Kotlin
	implementation("io.grpc:grpc-kotlin-stub:1.4.3")
	implementation("io.grpc:grpc-protobuf:1.73.0")
	implementation("io.grpc:grpc-stub:1.73.0")
	implementation("io.grpc:grpc-netty-shaded:1.73.0")
	implementation("io.grpc:grpc-core:1.73.0")

	// Optional: gRPC health & reflection services
	implementation("io.grpc:grpc-services:1.63.0")

	// Utils
	implementation("com.googlecode.libphonenumber:libphonenumber:9.0.7")

	// Spring gRPC integration
	implementation("org.springframework.grpc:spring-grpc-spring-boot-starter:0.8.0")

	// Development
	developmentOnly("org.springframework.boot:spring-boot-devtools")
	developmentOnly("org.springframework.boot:spring-boot-docker-compose")

	// Test
	testImplementation("org.springframework.boot:spring-boot-starter-test")
	testImplementation("io.projectreactor:reactor-test")
	testImplementation("org.springframework.security:spring-security-test")
	testImplementation("org.jetbrains.kotlinx:kotlinx-coroutines-test")

	testRuntimeOnly("io.r2dbc:r2dbc-h2")
	testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

tasks.test {
	useJUnitPlatform()
}

tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
	kotlinOptions {
		freeCompilerArgs += "-Xjsr305=strict"
		jvmTarget = "21"
	}
}

protobuf {
	protoc {
		artifact = "com.google.protobuf:protoc:3.25.3"
	}
	plugins {
		id("grpc") {
			artifact = "io.grpc:protoc-gen-grpc-java:1.63.0"
		}
		id("grpckt") {
			artifact = "io.grpc:protoc-gen-grpc-kotlin:1.4.1:jdk8@jar"
		}
	}
	generateProtoTasks {
		all().forEach {
			it.plugins {
				id("grpc")
				id("grpckt")
			}
		}
	}
	sourceSets {
		main {
			proto {
				srcDir("../grpc_contract")
			}
		}
	}
}

sourceSets["main"].java.srcDirs("src/main/java", "build/generated/source/proto/main/grpc", "build/generated/source/proto/main/grpckt", "build/generated/source/proto/main/java")
sourceSets["main"].kotlin.srcDirs("src/main/kotlin", "build/generated/source/proto/main/grpc", "build/generated/source/proto/main/grpckt", "build/generated/source/proto/main/java")

sourceSets["test"].java.srcDirs("src/test/java")
sourceSets["test"].kotlin.srcDirs("src/test/kotlin")

tasks.compileJava {
	dependsOn(tasks.compileKotlin)
	classpath += files(tasks.compileKotlin.get().destinationDirectory)
}

allOpen {
	annotation("org.springframework.context.annotation.Configuration")
	annotation("org.springframework.stereotype.Service")
	annotation("org.springframework.stereotype.Component")
	annotation("org.springframework.stereotype.Repository")
	annotation("org.springframework.boot.autoconfigure.SpringBootApplication")
	annotation("org.springframework.scheduling.annotation.Async")
	annotation("javax.persistence.Entity")
	annotation("javax.persistence.MappedSuperclass")
	annotation("javax.persistence.Embeddable")
}
