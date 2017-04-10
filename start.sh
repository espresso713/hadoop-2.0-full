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

#ssh-keygen
docker exec -it -u hadoop node1 ssh-keygen -t rsa -q -f "/home/hadoop/.ssh/id_rsa" -N ""
docker exec -it -u hadoop node2 ssh-keygen -t rsa -q -f "/home/hadoop/.ssh/id_rsa" -N ""
docker exec -it -u hadoop node3 ssh-keygen -t rsa -q -f "/home/hadoop/.ssh/id_rsa" -N ""
docker exec -it -u hadoop node4 ssh-keygen -t rsa -q -f "/home/hadoop/.ssh/id_rsa" -N ""

#ssh without a prompt(node1 -> node1, node2, node3, node4)
docker exec -it -u hadoop node1 ssh-copy-id -i /home/hadoop/.ssh/id_rsa.pub -o StrictHostKeyChecking=no hadoop@node1
docker exec -it -u hadoop node1 ssh-copy-id -i /home/hadoop/.ssh/id_rsa.pub -o StrictHostKeyChecking=no hadoop@node2
docker exec -it -u hadoop node1 ssh-copy-id -i /home/hadoop/.ssh/id_rsa.pub -o StrictHostKeyChecking=no hadoop@node3
docker exec -it -u hadoop node1 ssh-copy-id -i /home/hadoop/.ssh/id_rsa.pub -o StrictHostKeyChecking=no hadoop@node4

#ssh without a prompt(node2 -> node1, node2, node3, node4)
docker exec -it -u hadoop node2 ssh-copy-id -i /home/hadoop/.ssh/id_rsa.pub -o StrictHostKeyChecking=no hadoop@node1
docker exec -it -u hadoop node2 ssh-copy-id -i /home/hadoop/.ssh/id_rsa.pub -o StrictHostKeyChecking=no hadoop@node2
docker exec -it -u hadoop node2 ssh-copy-id -i /home/hadoop/.ssh/id_rsa.pub -o StrictHostKeyChecking=no hadoop@node3
docker exec -it -u hadoop node2 ssh-copy-id -i /home/hadoop/.ssh/id_rsa.pub -o StrictHostKeyChecking=no hadoop@node4

#run bootstrap.sh
docker exec -it -u hadoop node1 sh -c '/etc/bootstrap.sh';	

#deploy a hadoop jar to datanode
docker exec -it -u hadoop node1 sh -c 'tar -C $HADOOP_HOME/.. -zcvf $HADOOP_HOME/../hadoop-2.6.0-1.0.tar.gz hadoop-2.6.0'
docker exec -it -u hadoop node1 sh -c 'scp $HADOOP_HOME/../hadoop-2.6.0-1.0.tar.gz hadoop@node2:/home/hadoop/soft/apache/hadoop/'
docker exec -it -u hadoop node1 sh -c 'scp $HADOOP_HOME/../hadoop-2.6.0-1.0.tar.gz hadoop@node3:/home/hadoop/soft/apache/hadoop/'
docker exec -it -u hadoop node1 sh -c 'scp $HADOOP_HOME/../hadoop-2.6.0-1.0.tar.gz hadoop@node4:/home/hadoop/soft/apache/hadoop/'

docker exec -it -u hadoop node2 sh -c 'tar -C /home/hadoop/soft/apache/hadoop -zxvf /home/hadoop/soft/apache/hadoop/hadoop-2.6.0-1.0.tar.gz'
docker exec -it -u hadoop node3 sh -c 'tar -C /home/hadoop/soft/apache/hadoop -zxvf /home/hadoop/soft/apache/hadoop/hadoop-2.6.0-1.0.tar.gz'
docker exec -it -u hadoop node4 sh -c 'tar -C /home/hadoop/soft/apache/hadoop -zxvf /home/hadoop/soft/apache/hadoop/hadoop-2.6.0-1.0.tar.gz'

#zookeeper
./zkStart.sh

#hadoop start
#docker exec -it --user hadoop node1 sh -c '$HADOOP_HOME/bin/hdfs namenode -format';
#docker exec -it --user hadoop node1 sh -c '$HADOOP_HOME/sbin/start-all.sh';

#zookeeper format
docker exec -it --user hadoop node1 sh -c '$HADOOP_HOME/bin/hdfs zkfc -formatZK';

#journalnode run(node1, node2, node3)
docker exec -it --user hadoop node1 sh -c '$HADOOP_HOME/sbin/hadoop-daemon.sh start journalnode';
docker exec -it --user hadoop node2 sh -c '$HADOOP_HOME/sbin/hadoop-daemon.sh start journalnode';
docker exec -it --user hadoop node3 sh -c '$HADOOP_HOME/sbin/hadoop-daemon.sh start journalnode';

#active namenode 
docker exec -it --user hadoop node1 sh -c '$HADOOP_HOME/bin/hdfs namenode -format';
docker exec -it --user hadoop node1 sh -c '$HADOOP_HOME/sbin/hadoop-daemon.sh start namenode';
docker exec -it --user hadoop node1 sh -c '$HADOOP_HOME/sbin/hadoop-daemon.sh start zkfc';

#datanode
docker exec -it --user hadoop node1 sh -c '$HADOOP_HOME/sbin/hadoop-daemons.sh start datanode';

#standby namenode
docker exec -it --user hadoop node2 sh -c '$HADOOP_HOME/bin/hdfs namenode -bootstrapStandby';
docker exec -it --user hadoop node2 sh -c '$HADOOP_HOME/sbin/hadoop-daemon.sh start namenode';
docker exec -it --user hadoop node2 sh -c '$HADOOP_HOME/sbin/hadoop-daemon.sh start zkfc';

#yarn
docker exec -it --user hadoop node1 sh -c '$HADOOP_HOME/sbin/start-yarn.sh';

#history server
docker exec -it --user hadoop node1 sh -c '$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver';


docker exec -it --user hadoop node1 /bin/bash






