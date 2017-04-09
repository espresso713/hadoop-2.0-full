docker rm -f test
docker build -t test:1.0 -f DockerfileTest .
docker run -d -it --name test -u root test:1.0
docker exec -it test /bin/bash