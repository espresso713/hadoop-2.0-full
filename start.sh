docker rm -f node1
docker rm -f node2
docker rm -f node3
docker rm -f node4

#network
docker network rm mynet
docker network create --subnet=172.19.0.0/16 mynet

docker run -it --net mynet -h node1 --ip 172.19.0.2 -p 8081:50070 \
	--add-host node2:172.19.0.3 \
	--add-host node3:172.19.0.4 \
	--add-host node4:172.19.0.5 \
	-d --name node1 host1:1.0 

docker run -it --net mynet -h node2 --ip 172.19.0.3 \
	--add-host node1:172.19.0.2 \
	--add-host node3:172.19.0.4 \
	--add-host node4:172.19.0.5 \
	-d --name node2 host2:1.0
docker run -it --net mynet -h node3 --ip 172.19.0.4 \
	--add-host node1:172.19.0.2 \
	--add-host node2:172.19.0.3 \
	--add-host node4:172.19.0.5 \
	-d --name node3 host2:1.0

docker run -it --net mynet -h node4 --ip 172.19.0.5 \
	--add-host node1:172.19.0.2 \
	--add-host node2:172.19.0.3 \
	--add-host node3:172.19.0.4 \
	-d --name node4 host2:1.0		

docker exec -it --user root node1 sh -c '/etc/bootstrap.sh';	

#ssh-keygen
docker exec -it node1 ssh-keygen -t rsa -q -f "/root/.ssh/id_rsa" -N ""
docker exec -it node2 ssh-keygen -t rsa -q -f "/root/.ssh/id_rsa" -N ""
docker exec -it node3 ssh-keygen -t rsa -q -f "/root/.ssh/id_rsa" -N ""
docker exec -it node4 ssh-keygen -t rsa -q -f "/root/.ssh/id_rsa" -N ""

#ssh without a prompt(node1 -> node1, node2, node3, node4)
docker exec -it node1 ssh-copy-id -i /root/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@node1
docker exec -it node1 ssh-copy-id -i /root/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@node2
docker exec -it node1 ssh-copy-id -i /root/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@node3
docker exec -it node1 ssh-copy-id -i /root/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@node4

#ssh without a prompt(node2 -> node1, node2, node3, node4)
docker exec -it node2 ssh-copy-id -i /root/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@node1
docker exec -it node2 ssh-copy-id -i /root/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@node2
docker exec -it node2 ssh-copy-id -i /root/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@node3
docker exec -it node2 ssh-copy-id -i /root/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@node4

#deploy a hadoop jar to datanode
docker exec -it node1 sh -c 'tar -C $HADOOP_HOME/.. -zcvf $HADOOP_HOME/../hadoop-2.6.0-1.0.tar.gz hadoop-2.6.0'
docker exec -it node1 sh -c 'scp $HADOOP_HOME/../hadoop-2.6.0-1.0.tar.gz root@node2:/home/hadoop/soft/apache/hadoop/'
docker exec -it node1 sh -c 'scp $HADOOP_HOME/../hadoop-2.6.0-1.0.tar.gz root@node3:/home/hadoop/soft/apache/hadoop/'
docker exec -it node1 sh -c 'scp $HADOOP_HOME/../hadoop-2.6.0-1.0.tar.gz root@node4:/home/hadoop/soft/apache/hadoop/'

docker exec -it node2 sh -c 'tar -C /home/hadoop/soft/apache/hadoop -zxvf /home/hadoop/soft/apache/hadoop/hadoop-2.6.0-1.0.tar.gz'
docker exec -it node3 sh -c 'tar -C /home/hadoop/soft/apache/hadoop -zxvf /home/hadoop/soft/apache/hadoop/hadoop-2.6.0-1.0.tar.gz'
docker exec -it node4 sh -c 'tar -C /home/hadoop/soft/apache/hadoop -zxvf /home/hadoop/soft/apache/hadoop/hadoop-2.6.0-1.0.tar.gz'

#hadoop start
#docker exec -it --user hadoop node1 sh -c '$HADOOP_HOME/bin/hdfs namenode -format';
#docker exec -it --user hadoop node1 sh -c '$HADOOP_HOME/sbin/start-all.sh';

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

docker exec -it --user zookeeper node1 /bin/bash






