# Use an official Gradle image to build the application
FROM gradle:7.4.2-jdk21 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the Gradle wrapper and source code to the container
COPY gradlew ./
COPY gradle ./gradle
COPY build.gradle ./
COPY settings.gradle ./
COPY src ./src

# Compile and package the application, including running tests
RUN ./gradlew clean build

# Use an official OpenJDK runtime as a parent image
FROM openjdk:21-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the executable JAR file from the build stage to the container
COPY --from=build /app/build/libs/*.jar flow_backend.jar

# Expose the port the app runs on
EXPOSE 8080

# Run the JAR file
ENTRYPOINT ["java", "-jar", "flowbackend.jar"]