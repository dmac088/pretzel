#!/bin/bash

docker run -d --name my-postgresdb-container \
-e POSTGRES_PASSWORD=password \
-p 5432:5432 \
-v postgres_data:/var/lib/postgresql/data \
--network my-net \
my-postgres-db \


