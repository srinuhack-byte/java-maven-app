# Use Eclipse Temurin OpenJDK 11
FROM eclipse-temurin:11-jre

WORKDIR /app

# Copy the built JAR from Maven
COPY target/demo-app-1.0.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
