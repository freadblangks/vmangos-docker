@echo off
REM #This script leverages .dockerignore files to help speed up the building process for each container and reduce waiting for docker build context

git submodule init
git submodule update --remote --recursive

cd src\core\sql\migrations
call merge.bat
cd ..\..\..\..\

docker build -t vmangos_build -f docker/build/Dockerfile . 
docker run -v %CD%/vmangos:/vmangos -v %CD%/src/database:/database -v %CD%/src/ccache:/ccache -e CCACHE_DIR=/ccache --rm vmangos_build 

