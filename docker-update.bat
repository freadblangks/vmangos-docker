docker-compose up -d vmangos_database

git pull
git status
git submodule update --init --remote --recursive -j 8
git submodule status

docker build -t vmangos_build -f docker/build/Dockerfile .

docker run -v %CD%/vmangos:/vmangos -v %CD%/src/database:/database -v %CD%/src/ccache:/ccache -e CCACHE_DIR=/ccache -e threads=4 -e CLIENT=5875 -e ANTICHEAT=1 --rm vmangos_build

cd src\core\sql\migrations
del /Q world_db_updates.sql
del /Q characters_db_updates.sql
call merge.bat
docker-compose exec vmangos_database sh -c "mysql -u root -p$MYSQL_ROOT_PASSWORD mangos < /opt/vmangos/sql/migrations/world_db_updates.sql"
docker-compose exec vmangos_database sh -c "mysql -u root -p$MYSQL_ROOT_PASSWORD characters < /opt/vmangos/sql/migrations/characters_db_updates.sql"
del /Q world_db_updates.sql
del /Q characters_db_updates.sql
cd ..\..\..\..\

docker-compose build

docker-compose down

docker-compose up -d

docker ps

docker system prune
