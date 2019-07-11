FROM fluent/fluentd:v0.12-debian

RUN ["gem", "install", "fluent-plugin-kafka", "--no-rdoc", "--no-ri", "--version", "0.7.9"]
RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-rdoc", "--no-ri", "--version", "1.18.1"]
COPY ./conf /fluentd/etc