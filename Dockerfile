# Use an official OpenJDK 11 image
FROM openjdk:11-jre-slim-bullseye

WORKDIR /app

# Copy the built jar from Maven build
COPY target/demo-app-1.0.jar app.jar

# Command to run the app
ENTRYPOINT ["java","-jar","app.jar"]
