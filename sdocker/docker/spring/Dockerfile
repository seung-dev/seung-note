FROM eclipse-temurin:17-jre-alpine

ARG WORK_DIR=/seung
ARG JAR_PATH=${WORK_DIR}/app.jar

RUN apk update && apk upgrade

RUN mkdir -p ${WORK_DIR}

RUN addgroup -S seung && adduser -S seung -G seung
RUN chown -R seung:root ${WORK_DIR}
USER seung

COPY build/libs/*.jar ${JAR_PATH}

ENV RUN_COMMAND="java -jar ${JAR_PATH}"

CMD $RUN_COMMAND
