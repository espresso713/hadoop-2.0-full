docker rm -f test
docker build -t test:1.0 -f DockerfileTest .
docker run -d -it --name test test:1.0
docker exec -it -u hadoop test /bin/bash