FROM postgres:12.1-alpine as build
LABEL maintainer "Kaid Wong<info@kaid.me>"

RUN apk --update --no-cache add --virtual \
    build-dependencies \
    curl \
    make \
    clang \
    gcc \
    llvm \
    musl-dev \
    postgresql-dev \
    icu-dev \
    && cd /tmp \
    && curl -L -O https://mirrors.tuna.tsinghua.edu.cn/osdn/pgbigm/71710/pg_bigm-1.2-20191003.tar.gz \
    && tar zxfv pg_bigm-1.2-20191003.tar.gz \
    && cd pg_bigm-1.2-20191003 \
    && make USE_PGXS=1 \
    && make USE_PGXS=1 install \
    && echo "shared_preload_libraries = 'pg_bigm'" >> /usr/local/share/postgresql/postgresql.conf.sample

FROM postgres:12.1-alpine
COPY --from=build /usr/local/lib/postgresql /usr/local/lib/postgresql
COPY --from=build /usr/local/share/postgresql /usr/local/share/postgresql
