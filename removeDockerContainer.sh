#!/bin/bash

docker stop my-postgresdb-container
docker rm -f my-postgresdb-container
docker image rm 'my-postgres-db'
