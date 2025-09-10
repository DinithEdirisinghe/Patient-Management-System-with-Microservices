# Use OpenJDK 21 runtime as the base image
FROM openjdk:21-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven wrapper and pom.xml first (for better layer caching)
COPY mvnw mvnw.cmd pom.xml ./
COPY .mvn .mvn

# Make the Maven wrapper executable
RUN chmod +x mvnw

# Copy the source code
COPY src ./src

# Build the application
RUN ./mvnw clean package -DskipTests

# Expose the port that the application will run on
EXPOSE 4004

# Set the startup command to execute the jar
CMD ["java", "-jar", "target/api-gateway-0.0.1-SNAPSHOT.jar"]
