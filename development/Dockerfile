FROM azul/zulu-openjdk:17 AS builder

RUN apt-get update \
 && apt-get install -y --no-install-recommends git libprotobuf-dev \
 && git clone -b development --depth 1 https://github.com/Grasscutters/Grasscutter /work

WORKDIR /work

RUN export GRADLE_OPTS="-Dfile.encoding=utf-8" \
 && sed -i "s#Hello#Server <a href='https://github.com/HelloGrasscutter'>HelloGrasscutter</a>#" src/main/java/emu/grasscutter/server/dispatch/DispatchServer.java \
 && git submodule update --init \
 && chmod +x gradlew \
 && ./gradlew jar \
 && mkdir /rootfs \
 && cp -rf grasscutter*.jar /rootfs/grasscutter.jar \
 && cp -rf keys /rootfs \
 && cp -rf keystore.p12 /rootfs \
 && cp -rf data /rootfs

FROM azul/zulu-openjdk-alpine:17-jre

RUN apk add --no-cache git bash jq

COPY --from=builder /rootfs /
COPY development/rootfs /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["java", "-jar", "grasscutter.jar"]