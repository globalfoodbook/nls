FROM postgres:9.5

MAINTAINER Ikenna N. Okpala <me@ikennaokpala.com>

ENV GOLANG_VERSION 1.6.2
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 e40c36ae71756198478624ed1bb4ce17597b3c19d243f3f0899bb5740d56212a
ENV GOPATH /go
ENV POSTGRES_VERSION 9.5
ENV POSTGRES_IP 127.0.0.1
ENV POSTGRES_PORT 5432
ENV POSTGRES_MAIN_USER postgres
ENV POSTGRES_USER $POSTGRES_MAIN_USER
ENV POSTGRES_PASS 12345678
ENV POSTGRES_DB $POSTGRES_USER
ENV NUT_PG_DSN postgres://$POSTGRES_USER:$POSTGRES_PASS@POSTGRES_IP/$POSTGRES_DB?sslmode=disable
ENV PATH $GOPATH/bin:/usr/local/go/bin:/usr/lib/postgresql/$POSTGRES_VERSION/bin/:$PATH

RUN apt-get update -y
RUN apt-get install -y build-essential checkinstall
RUN apt-get install -y vim curl wget unzip libcurl4-openssl-dev mime-support automake libtool python-docutils libreadline-dev libxslt1-dev libgd2-xpm-dev libgeoip-dev libgoogle-perftools-dev libperl-dev pkg-config libssl-dev git-core libgmp-dev zlib1g-dev libxslt-dev libxml2-dev libpcre3 libpcre3-dev freetds-dev software-properties-common

RUN apt-get update && apt-get install -y --no-install-recommends \
		g++ \
		gcc \
		libc6-dev \
		make \
	&& rm -rf /var/lib/apt/lists/*
RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
	&& echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

RUN mkdir -p /tmp/psql_data/

ADD templates/entrypoint.sh /etc/init.d/entrypoint.sh
ADD templates/pg_entrypoint.sh /etc/init.d/pg_entrypoint.sh

COPY templates/nutrition_sr26_plain.sql /tmp/psql_data/
COPY templates/load_data.sh /docker-entrypoint-initdb.d/

RUN chmod +x /docker-entrypoint-initdb.d/load_data.sh
RUN chmod +x /etc/init.d/pg_entrypoint.sh
RUN chmod +x /etc/init.d/entrypoint.sh

WORKDIR $GOPATH

EXPOSE 80
EXPOSE 443
EXPOSE $POSTGRES_PORT

# Setup the entrypoint
ENTRYPOINT ["/bin/bash", "-l", "-c"]
CMD ["/etc/init.d/entrypoint.sh"]
