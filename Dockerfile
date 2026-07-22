#----------------------------------
# Stage 1
#----------------------------------

# Import docker image with maven installed
FROM maven:3.8.3-openjdk-17 as builder 

# Add maintainer, so that new user will understand who had written this Dockerfile
MAINTAINER Yogesh Bharambe<yogesh01bharambe@gmail.com>

# Add labels to the image to filter out if we have multiple application running
LABEL app=bankapp

# Set working directory
WORKDIR /app-code
# Copy source code from local to container

COPY app-code/ .

# Build application and skip test cases
RUN mvn clean install -DskipTests=true

#--------------------------------------
# Stage 2
#--------------------------------------

# Import small size java image
FROM openjdk:17.0.1-jdk-slim as deployer

WORKDIR /app
# Copy build from stage 1 (builder)
COPY --from=builder /app-code/target/*.jar /app/bankapp.jar

# Expose application port 
EXPOSE 8080

# Start the application
ENTRYPOINT ["java", "-jar", "/app/bankapp.jar"]
