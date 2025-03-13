FROM bellsoft/liberica-openjdk-alpine:21

LABEL maintainer="niangao"

ENV PARAMS=""
ENV TZ=PRC

# 设置时区
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /app
COPY target/xxl-job-admin-*.jar /app.jar

ENTRYPOINT ["sh","-c","java -jar $JAVA_OPTS /app.jar $PARAMS"]