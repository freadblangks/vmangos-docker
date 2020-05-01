#!/bin/bash

docker-compose up -d vmangos_database

git pull -v --stat --depth 1 --progress
git status
git submodule update --init --remote --recursive --depth 1 -j 8 --progress
git submodule status

docker build -t vmangos_build -f docker/build/Dockerfile .
docker run -v $(pwd)/vmangos:/vmangos -v $(pwd)/src/database:/database -v $(pwd)/src/ccache:/ccache -e CCACHE_DIR=/ccache -e threads=4 -e CLIENT=5875 -e ANTICHEAT=1 --rm vmangos_build

pushd src/core/sql/migrations

rm -f world_db_updates.sql
rm -f characters_db_updates.sql
chmod +x merge.sh
./merge.sh

docker-compose exec vmangos_database sh -c "mysql -u root -p$MYSQL_ROOT_PASSWORD mangos < /opt/vmangos/sql/migrations/world_db_updates.sql"
docker-compose exec vmangos_database sh -c "mysql -u root -p$MYSQL_ROOT_PASSWORD characters < /opt/vmangos/sql/migrations/characters_db_updates.sql"

rm -f world_db_updates.sql
rm -f characters_db_updates.sql

popd

docker-compose build
docker-compose down
docker-compose up -d
docker ps
docker system prune
