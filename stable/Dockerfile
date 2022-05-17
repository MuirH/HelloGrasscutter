FROM azul/zulu-openjdk:17 AS builder

RUN apt-get update \
 && apt-get install -y --no-install-recommends git libprotobuf-dev \
 && git clone -b stable --depth 1 https://github.com/Grasscutters/Grasscutter /work

WORKDIR /work

RUN export GRADLE_OPTS="-Dfile.encoding=utf-8" \
 && git submodule update --init \
 && chmod +x gradlew \
 && ./gradlew jar \
 && mkdir /rootfs \
 && cp -rf grasscutter*.jar /rootfs/grasscutter.jar \
 && cp -rf keys /rootfs \
 && cp -rf keystore.p12 /rootfs \
 && cp -rf data /rootfs

FROM azul/zulu-openjdk-alpine:17

COPY --from=builder /rootfs /
COPY development/rootfs /

RUN apk add --no-cache git bash jq \
 && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["java", "-jar", "grasscutter.jar"]
