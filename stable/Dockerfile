FROM azul/zulu-openjdk:8 AS builder

RUN apt-get update \
 && apt-get install -y --no-install-recommends git libprotobuf-dev \
 && git clone -b stable --depth 1 https://github.com/Grasscutters/Grasscutter /work

WORKDIR /work

RUN export GRADLE_OPTS="-Dfile.encoding=utf-8" \
 && sed -i "s#Hello#Server <a href='https://github.com/HelloGrasscutter'>HelloGrasscutter</a>#" src/main/java/emu/grasscutter/server/dispatch/DispatchServer.java \
 && git submodule update --init \
 && chmod +x gradlew \
 && ./gradlew jar \
 && mkdir /rootfs \
 && cp -rf grasscutter.jar /rootfs \
 && cp -rf keys /rootfs \
 && cp -rf keystore.p12 /rootfs \
 && cp -rf data /rootfs

FROM azul/zulu-openjdk-alpine:8

COPY --from=builder /rootfs /
COPY development/rootfs /

RUN apk add --no-cache git bash jq \
 && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["java", "-jar", "grasscutter.jar"]