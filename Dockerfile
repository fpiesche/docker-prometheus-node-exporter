FROM alpine:3.16.2 AS download
ARG PROMETHEUS_TAG

WORKDIR /tmp
ENV PROMETHEUS_TAG=${PROMETHEUS_TAG}
ADD downloader.sh /tmp/downloader.sh
RUN ["/bin/sh", "-c", "/tmp/downloader.sh"]

FROM busybox:1.35.0
COPY --from=download /tmp/node_exporter /bin/node_exporter
EXPOSE 9100
USER nobody
ENTRYPOINT ["/bin/node_exporter"]
