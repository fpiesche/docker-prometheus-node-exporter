FROM alpine:3.14.2 AS download
ARG PROMETHEUS_TAG

WORKDIR /tmp
ENV PROMETHEUS_TAG=${PROMETHEUS_TAG}
ADD downloader.sh /tmp/downloader.sh
RUN ["/bin/sh", "-c", "/tmp/downloader.sh"]

FROM alpine:3.14.2
COPY --from=download /tmp/node_exporter /root/node_exporter
EXPOSE 9100
CMD ["/root/node_exporter"]
