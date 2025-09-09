# Use runtime image directly since we'll build locally
FROM eclipse-temurin:21-jre AS runner

WORKDIR /app

# Copy the JAR file that was built locally
COPY target/analytics-service-0.0.1-SNAPSHOT.jar ./app.jar

EXPOSE 4002

ENTRYPOINT ["java", "-jar", "app.jar"]