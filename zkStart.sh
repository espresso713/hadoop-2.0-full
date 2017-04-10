#zookeeper
docker exec -it -u zookeeper node1 sh -c 'tar -C $ZOOKEEPER_HOME/.. -zcvf $ZOOKEEPER_HOME/../zookeeper-3.4.6-1.0.tar.gz zookeeper-3.4.6'
docker exec -it -u zookeeper node1 sh -c 'scp $ZOOKEEPER_HOME/../zookeeper-3.4.6-1.0.tar.gz root@node2:/home/zookeeper/soft/apache/zookeeper/'
docker exec -it -u zookeeper node1 sh -c 'scp $ZOOKEEPER_HOME/../zookeeper-3.4.6-1.0.tar.gz root@node3:/home/zookeeper/soft/apache/zookeeper/'

docker exec -it -u zookeeper node2 sh -c 'tar -C /home/zookeeper/soft/apache/zookeeper -zxvf /home/zookeeper/soft/apache/zookeeper/zookeeper-3.4.6-1.0.tar.gz'
docker exec -it -u zookeeper node3 sh -c 'tar -C /home/zookeeper/soft/apache/zookeeper -zxvf /home/zookeeper/soft/apache/zookeeper/zookeeper-3.4.6-1.0.tar.gz'

docker exec -it -u zookeeper node1 sh -c 'touch $ZOOKEEPER_HOME/zookeeper-data/myid';
docker exec -it -u zookeeper node2 sh -c 'touch $ZOOKEEPER_HOME/zookeeper-data/myid';
docker exec -it -u zookeeper node3 sh -c 'touch $ZOOKEEPER_HOME/zookeeper-data/myid';
docker exec -it -u zookeeper node1 sh -c 'echo 1 > $ZOOKEEPER_HOME/zookeeper-data/myid';
docker exec -it -u zookeeper node2 sh -c 'echo 2 > $ZOOKEEPER_HOME/zookeeper-data/myid';
docker exec -it -u zookeeper node3 sh -c 'echo 3 > $ZOOKEEPER_HOME/zookeeper-data/myid';
docker exec -it -u zookeeper node1 sh -c '$ZOOKEEPER_HOME/bin/zkServer.sh start';
docker exec -it -u zookeeper node2 sh -c '$ZOOKEEPER_HOME/bin/zkServer.sh start';
docker exec -it -u zookeeper node3 sh -c '$ZOOKEEPER_HOME/bin/zkServer.sh start';