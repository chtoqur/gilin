FROM openjdk:17-jdk
VOLUME /spring
ARG JAR_FILE=./build/libs/gilin-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
EXPOSE 8080