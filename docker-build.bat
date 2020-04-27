@echo off

rem git_submodules

rem git submodule init
git submodule update --init --remote --recursive -j 8

git submodule status

rem docker_build

docker build -t vmangos_build -f docker/build/Dockerfile .

docker run -v %CD%/vmangos:/vmangos -v %CD%/src/database:/database -v %CD%/src/ccache:/ccache -e CCACHE_DIR=/ccache -e threads=4 -e CLIENT=5875 -e ANTICHEAT=1 --rm vmangos_build

rem setup

cd src\core\sql\migrations
call merge.bat
cd ..\..\..\..\

docker-compose up -d

docker-compose ps