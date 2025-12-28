# Use a valid JDK image
FROM openjdk:11-jre-slim

WORKDIR /app

# Copy the JAR built by Maven
COPY target/demo-app-1.0.jar app.jar

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
