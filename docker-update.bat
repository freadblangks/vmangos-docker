docker-compose down

git pull
git status
git submodule update --init --remote --recursive -j 8
git submodule status


docker build -t vmangos_build -f docker/build/Dockerfile .

docker run -v %CD%/vmangos:/vmangos -v %CD%/src/database:/database -v %CD%/src/ccache:/ccache -e CCACHE_DIR=/ccache -e threads=4 -e CLIENT=5875 -e ANTICHEAT=1 --rm vmangos_build

cd src\core\sql\migrations
call merge.bat
cd ..\..\..\..\

docker-compose build

docker-compose up -d vmangos_database

timeout /t 30 /nobreak

docker-compose exec vmangos_database sh -c 'mysql -u root -p$MYSQL_ROOT_PASSWORD mangos < /opt/vmangos/sql/migrations/world_db_updates.sql'
docker-compose exec vmangos_database sh -c 'mysql -u root -p$MYSQL_ROOT_PASSWORD characters < /opt/vmangos/sql/migrations/characters_db_updates.sql'

docker-compose up -d

docker ps

docker system prune
