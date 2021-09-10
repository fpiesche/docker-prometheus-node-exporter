#!/bin/sh

function check_success {
    if [[ $1 -ne 0 ]]; then echo "Last command failed with exit code $1!"; exit $1; fi
}

case $(uname -m) in
        "aarch64")
            export ARCH="arm64"
            ;;
        "armv7l")
            export ARCH="armv7"
            ;;
        "armv6l")
            export ARCH="armv6"
            ;;
        "x86_64")
            export ARCH="amd64"
            ;;
        "i386")
            export ARCH="386"
            ;;
        "mips")
            export ARCH="mips"
            ;;
        "mips64")
            export ARCH="mips64"
            ;;
        "ppc64")
            export ARCH="ppc64"
            ;;
        "ppc64le")
            export ARCH="ppc64le"
            ;;
        "s390x")
            export ARCH="s390x"
            ;;
        *)
            echo "Unknown architecture: $(uname -m)"
            exit 1
            ;;
    esac

PROMETHEUS_VERSION=$(echo ${PROMETHEUS_TAG} | sed "s/v//")
FILENAME=node_exporter-${PROMETHEUS_VERSION}.linux-${ARCH}.tar.gz
URL=https://github.com/prometheus/node_exporter/releases/download/${PROMETHEUS_TAG}/${FILENAME}
SHASUMS=https://github.com/prometheus/node_exporter/releases/download/${PROMETHEUS_TAG}/sha256sums.txt

echo "Downloading ${URL}..."
wget -q ${URL}
check_success $?

echo "Verifying download..."
wget -q ${SHASUMS}
cat sha256sums.txt | grep ${FILENAME} | sha256sum -c
check_success $?

tar xzf /tmp/${FILENAME}
check_success $?

mv /tmp/node_exporter-*/node_exporter /tmp/node_exporter
