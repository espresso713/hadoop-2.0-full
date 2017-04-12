#stop
ssh zookeeper@node1 '/home/zookeeper/soft/apache/zookeeper/zookeeper-3.4.6/bin/zkServer.sh stop'
ssh zookeeper@node2 '/home/zookeeper/soft/apache/zookeeper/zookeeper-3.4.6/bin/zkServer.sh stop'
ssh zookeeper@node3 '/home/zookeeper/soft/apache/zookeeper/zookeeper-3.4.6/bin/zkServer.sh stop'

ssh hadoop@node1 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/sbin/hadoop-daemon.sh stop journalnode'
ssh hadoop@node2 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/sbin/hadoop-daemon.sh stop journalnode'
ssh hadoop@node3 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/sbin/hadoop-daemon.sh stop journalnode'

ssh hadoop@node1 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/sbin/hadoop-daemon.sh stop namenode'
ssh hadoop@node1 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/sbin/hadoop-daemon.sh stop zkfc'

ssh hadoop@node1 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/sbin/hadoop-daemons.sh stop datanode'

ssh hadoop@node2 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/sbin/hadoop-daemon.sh stop namenode'
ssh hadoop@node2 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/sbin/hadoop-daemon.sh stop zkfc'

ssh hadoop@node1 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/sbin/stop-yarn.sh'

ssh hadoop@node1 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/sbin/mr-jobhistory-daemon.sh stop historyserver'