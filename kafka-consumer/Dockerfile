FROM mozilla/sbt:latest as builder
WORKDIR /consumer
# Cache dependencies
COPY project project
COPY build.sbt .
RUN sbt update
# Build the jar
COPY . .
RUN sbt assembly

FROM openjdk:8u212
WORKDIR /consumer
COPY --from=builder /consumer/target/scala-2.12/consumer-assembly-1.0.0.jar consumer.jar
ENTRYPOINT ["java", "-jar", "/consumer/consumer.jar"]