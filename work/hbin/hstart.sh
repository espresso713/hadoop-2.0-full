#zookeeper
ssh zookeeper@node1 '/home/zookeeper/soft/apache/zookeeper/zookeeper-3.4.6/bin/zkServer.sh start'
ssh zookeeper@node2 '/home/zookeeper/soft/apache/zookeeper/zookeeper-3.4.6/bin/zkServer.sh start'
ssh zookeeper@node3 '/home/zookeeper/soft/apache/zookeeper/zookeeper-3.4.6/bin/zkServer.sh start'

#zookeeper format
ssh hadoop@node1 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/bin/hdfs zkfc -formatZK'

#journalnode run(node1, node2, node3)
ssh hadoop@node1 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/sbin/hadoop-daemon.sh start journalnode'
ssh hadoop@node2 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/sbin/hadoop-daemon.sh start journalnode'
ssh hadoop@node3 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/sbin/hadoop-daemon.sh start journalnode'

#active namenode 
ssh hadoop@node1 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/bin/hdfs namenode -format'
ssh hadoop@node1 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/sbin/hadoop-daemon.sh start namenode'
ssh hadoop@node1 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/sbin/hadoop-daemon.sh start zkfc'

#datanode
ssh hadoop@node1 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/sbin/hadoop-daemons.sh start datanode'

#standby namenode
ssh hadoop@node2 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/bin/hdfs namenode -bootstrapStandby'
ssh hadoop@node2 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/sbin/hadoop-daemon.sh start namenode'
ssh hadoop@node2 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/sbin/hadoop-daemon.sh start zkfc'

#yarn
ssh hadoop@node1 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/sbin/start-yarn.sh'

#history server
ssh hadoop@node1 '/home/hadoop/soft/apache/hadoop/hadoop-2.6.0/sbin/mr-jobhistory-daemon.sh start historyserver'