FROM postgres:13.1

RUN apt-get update && apt-get install -y python3 postgresql-plpython3-13 python3-pip

RUN pip3 install pyjwt jsonschema simplejson


COPY setup/init.sql /docker-entrypoint-initdb.d/000_init.sql
COPY setup/finish.sql /docker-entrypoint-initdb.d/ZZZ_999_finish.sql

COPY struct/*/*.sql /docker-entrypoint-initdb.d/
COPY functions/*/*.sql /docker-entrypoint-initdb.d/