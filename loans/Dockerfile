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
COPY --from=build /app/target/*.jar /app/loans.jar

# Exponer el puerto 8090 
EXPOSE 8090

ENV SPRING_PROFILES_ACTIVE=dev
ENV SPRING_CONFIG_IMPORT=configserver:http://configserver:8071/
ENV EUREKA_CLIENT_SERVICEURL_DEFAULTZONE=http://eurekaserver:8070/eureka/

# Ejecutar la aplicación
CMD ["java", "-jar", "loans.jar"]