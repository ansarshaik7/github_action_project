# -------- Build Stage --------
FROM amazoncorretto:17 AS build
WORKDIR /app
    
# Copy only what is needed for dependency resolution
COPY pom.xml .
COPY src ./src
    
# Build the application
RUN mvn clean package -DskipTests
    
# -------- Runtime Stage --------
FROM amazoncorretto:17-alpine3.20-jre
WORKDIR /app
    
# Copy the built JAR from build stage
COPY --from=build /app/target/*.jar app.jar
    
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
