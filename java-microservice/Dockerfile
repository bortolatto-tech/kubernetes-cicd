FROM amazoncorretto:17-al2023-jdk
ARG JAR_FILE=target/*.jar

COPY ${JAR_FILE} app.jar

ENV DATASOURCE_URL="jdbc:postgresql://localhost:5432/padrao"
ENV DATASOURCE_USERNAME=postgres
ENV DATASOURCE_PASSWORD=postgres

ENTRYPOINT ["sh", "-c", "java -jar app.jar"]