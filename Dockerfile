# === Stage 1: Build the Maven project ===
FROM maven:3.9.6-eclipse-temurin-17 AS builder

# Set working directory inside container
WORKDIR /app

# Copy project files
COPY pom.xml .
COPY src ./src

# Download dependencies and build the project (skip tests for now)
RUN mvn clean install -DskipTests

# === Stage 2: Run tests ===
FROM eclipse-temurin:17-jdk

WORKDIR /app

# Optional: Install curl for debugging
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy project from build stage
COPY --from=builder /app /app

# Default command to run tests
CMD ["mvn", "test"]
