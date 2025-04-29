# Imagen para compilar
FROM maven:3.8-openjdk-17 AS build

WORKDIR /app

# Copiar primero el pom.xml para aprovechar la caché de capas
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiar el resto del proyecto
COPY .mvn/ ./.mvn/
COPY mvnw mvnw.cmd ./
COPY src/ ./src/

# Compilar la aplicación
RUN mvn clean package -DskipTests

# Verificar el contenido del jar generado
RUN echo "Verificando archivos generados:" && ls -la target/

# Imagen de ejecución
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copiar el JAR de la aplicación
COPY --from=build /app/target/*.jar /app/eurekaserver.jar

# Exponer el puerto 8070 
EXPOSE 8070

ENV SPRING_PROFILES_ACTIVE=dev
ENV SPRING_CONFIG_IMPORT=configserver:http://configserver:8071/

# Ejecutar la aplicación
CMD ["java", "-jar", "eurekaserver.jar"]