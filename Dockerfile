FROM armbuild/debian:sid
MAINTAINER Heiko Hüter <ender@ender74.de>

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y curl ca-certificates golang -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /root/.cache

ENV ETCD_VER=v3.1.0
ENV ETCD_DIR=/opt/go/src/github.com/coreos/etcd
ENV GOPATH=/opt/go

RUN curl -L https://github.com/coreos/etcd/archive/${ETCD_VER}.tar.gz -o /tmp/etcd-${ETCD_VER}.tar.gz \
  && mkdir -p ${ETCD_DIR} \
  && tar xzvf /tmp/etcd-${ETCD_VER}.tar.gz -C ${ETCD_DIR} --strip-components=1 \
  && rm /tmp/etcd-${ETCD_VER}.tar.gz \
  && cd ${ETCD_DIR} \
  && ./build \
  && ln -s ${ETCD_DIR}/bin/etcd /usr/local/bin/etcd \
  && ln -s ${ETCD_DIR}/bin/etcdctl /usr/local/bin/etcdctl

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
