#!/bin/bash

docker run -d --name my-postgresdb-container \
--user 1000 \
-e POSTGRES_PASSWORD=password \
-p 5432:5432 \
-v $(pwd)/data:/var/lib/postgresql/data \
--network my-net \
my-postgres-db \


