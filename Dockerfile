FROM       ubuntu:14.04
MAINTAINER Al Tobey <atobey@datastax.com>

VOLUME ["/data"]
ENTRYPOINT ["/bin/cassandra-docker"]

COPY install-ubuntu-packages.sh /
RUN /bin/sh /install-ubuntu-packages.sh

# TEMPORARY: while the mirrors are messed up and I'm doing
# dev passes, this will expect a tarball in the root of the repo
# wget http://www.apache.dist/cassandra/2.0.11/apache-cassandra-2.0.11-bin.tar.gz
COPY apache-cassandra-2.0.11-bin.tar.gz /

COPY install-cassandra-tarball.sh /
RUN /bin/sh /install-cassandra-tarball.sh

# create a cassandra user:group & chown
# Note: this UID/GID is hard-coded in main.go
RUN groupadd -g 1337 cassandra
RUN useradd -u 1337 -g cassandra -s /bin/sh -d /data cassandra
RUN chown -R cassandra:cassandra /data

COPY conf /src
COPY cassandra-docker /bin/

# SSH, Storage Port, JMX, Thrift, CQL Native, OpsCenter Agent
# Left out: SSL
EXPOSE 22 7000 7199 9042 9160 61621

