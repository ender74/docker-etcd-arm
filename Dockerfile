FROM ender74/golang-arm:1.7
MAINTAINER Heiko Hüter <ender@ender74.de>

ENV ETCD_VER=v3.1.0

WORKDIR $GOPATH/src/github.com/coreos

RUN git clone --branch $ETCD_VER https://github.com/coreos/etcd.git \
    && cd etcd \
    && ./build \
    && cd bin \
    && mkdir -p /usr/local/bin \
    && cp etcd /usr/local/bin/etcd \
    && cp etcdctl /usr/local/bin/etcdctl

ENV ETCD_UNSUPPORTED_ARCH=arm

EXPOSE 2379
EXPOSE 2380
EXPOSE 4001

CMD ["/usr/local/bin/etcd", \
  "-name", "etcd0", \
  "-advertise-client-urls", "http://localhost:2379,http://localhost:4001", \
  "-listen-client-urls", "http://0.0.0.0:2379,http://0.0.0.0:4001", \
  "-initial-advertise-peer-urls", "http://localhost:2380", \
  "-listen-peer-urls", "http://0.0.0.0:2380", \
  "-initial-cluster-token", "etcd-cluster-1", \
  "-initial-cluster", "etcd0=http://localhost:2380", \
  "-initial-cluster-state", "new"]
