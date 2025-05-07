# Etapa 1: compilar usando gradlew
FROM gradle:7.6.0-jdk17 AS builder

WORKDIR /home/app

# Copiar TODO primero (incluye gradlew y gradle/)
COPY . .

# Dar permisos al gradlew que ya está dentro del contenedor
RUN chmod +x ./gradlew

# Limpiar caché previa (si la hubiera)
RUN rm -rf .gradle

# Compilar usando el wrapper
RUN ./gradlew clean build -x test --no-daemon


# Etapa 2: imagen final
FROM eclipse-temurin:17-jdk

# 🔧 Instalar netcat para wait-for-it.sh
RUN apt-get update && apt-get install -y netcat-openbsd && rm -rf /var/lib/apt/lists/*

# Copiar el JAR
COPY --from=builder /home/app/build/libs/*-all.jar app.jar

# Copiar el script y dar permisos
COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

# Exponer el puerto
EXPOSE 8080

# Usar el script para esperar a MySQL
ENTRYPOINT ["/wait-for-it.sh", "mysql:3306", "--", "java", "-jar", "app.jar"]


