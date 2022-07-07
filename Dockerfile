FROM postgres
ENV POSTGRES_PASSWORD docker
ENV POSTGRES_DB world 
ENV PGDATA=/var/lib/postgresql/data/pgdata
RUN echo "en_US UTF-8 " >> /etc/locale.gen && locale-gen
RUN echo "en_HK UTF-8 " >> /etc/locale.gen && locale-gen
COPY mochidb.sql /docker-entrypoint-initdb.d/
