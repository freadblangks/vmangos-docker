#!/bin/bash

git submodule update --init --remote --recursive --depth 1 -j 8 --progress
git submodule status

docker build -t vmangos_build -f docker/build/Dockerfile .
docker run -v $(pwd)/vmangos:/vmangos -v $(pwd)/src/database:/database -v $(pwd)/src/ccache:/ccache -e CCACHE_DIR=/ccache -e threads=4 -e CLIENT=5875 -e ANTICHEAT=1 --rm vmangos_build

pushd src/core/sql/migrations
chmod +x merge.sh
./merge.sh
popd

docker-compose up -d
docker-compose ps
docker system prune
