#!/bin/sh
docker rm -f host1
docker rm -f host2
docker build -t host1:1.0 -f Dockerfile1 .
docker build -t host2:1.0 -f Dockerfile2 .

