#masters
touch $HADOOP_CONFIG_HOME/masters
echo node1 >> $HADOOP_CONFIG_HOME/masters

#slaves
echo node2 > $HADOOP_CONFIG_HOME/slaves
echo node3 >> $HADOOP_CONFIG_HOME/slaves
echo node4 >> $HADOOP_CONFIG_HOME/slaves

#hadoop-env.sh
#echo export JAVA_HOME=/usr/lib/jvm/java-8-oracle >> hadoop-env.sh
echo 'export HADOOP_HOME_WARN_SUPPRESS="TRUE"' >> $HADOOP_CONFIG_HOME/hadoop-env.sh
echo 'export HADOOP_PID_DIR=$HOME/soft/apache/hadoop/hadoop-2.6.0/pids' >> $HADOOP_CONFIG_HOME/hadoop-env.sh


