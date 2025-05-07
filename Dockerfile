# Etapa 1: compilar usando gradlew
FROM gradle:7.6.0-jdk17 AS builder

WORKDIR /home/app

# Instalar dos2unix para evitar problemas de formato CRLF y permisos
RUN apt-get update && apt-get install -y dos2unix && rm -rf /var/lib/apt/lists/*

COPY . .

# Convertir a Unix format y dar permisos correctos
RUN dos2unix gradlew && chmod 755 gradlew

RUN rm -rf .gradle
RUN ./gradlew clean build -x test --no-daemon


# Etapa 2: imagen final
FROM eclipse-temurin:17-jdk

RUN apt-get update && apt-get install -y netcat-openbsd && rm -rf /var/lib/apt/lists/*

COPY --from=builder /home/app/build/libs/*-all.jar app.jar
COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

EXPOSE 8080

ENTRYPOINT ["/wait-for-it.sh", "mysql:3306", "--", "java", "-jar", "app.jar"]
