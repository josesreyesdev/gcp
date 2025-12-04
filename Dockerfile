# Etapa de compilación (Build Stage)
# Usa una imagen con el JDK completo para compilar la aplicación
FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /workspace/app

# Copiar TODOS los archivos necesarios para Gradle
COPY gradlew .
COPY gradlew.bat .
COPY gradle gradle

COPY build.gradle .
COPY settings.gradle .

# Copiar el código fuente
COPY src src

# Ejecutar el wrapper gradlew
RUN chmod +x gradlew

# Ejecuta la tarea de Gradle para construir el JAR ejecutable
RUN ./gradlew bootJar

# Etapa de ejecución (Run Stage)
# Usa una imagen solo con JRE, que es más ligera
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Copia el JAR compilado desde la etapa de 'build' a la imagen final
COPY --from=build /workspace/app/build/libs/hello-0.0.1-SNAPSHOT.jar app.jar

# Expone el puerto 8080, que es el puerto por defecto de Spring Boot
EXPOSE 8080

# Comando para ejecutar la aplicación cuando se inicie el contenedor
ENTRYPOINT ["java","-jar","app.jar"]