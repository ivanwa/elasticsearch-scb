#!/bin/bash
ES_HOME=$(cd "$(dirname "$0")"; pwd)

echo -e "-------------------------------\n\t正在配置安装...\n-------------------------------"
useradd -M -s /sbin/nologin elasticsearch

mkdir /var/run/elasticsearch
chown elasticsearch:elasticsearch /var/run/elasticsearch/
chown elasticsearch:elasticsearch $ES_HOME/log/
chown elasticsearch:elasticsearch $ES_HOME/data/
if [ $ES_HOME != '/usr/local/elasticsearch-scb' ];
then
	SED_HOME=${ES_HOME//\//\\\/}
	sed -i "s/\/usr\/local\/elasticsearch-scb/$SED_HOME/g" $ES_HOME/config/elasticsearch
	sed -i "s/\/usr\/local\/elasticsearch-scb/$SED_HOME/g" $ES_HOME/init.d/elasticsearch
	sed -i "s/\/usr\/local\/elasticsearch-scb/$SED_HOME/g" $ES_HOME/init.d/elasticsearch.service
fi
ln -s $ES_HOME/config/ /etc/elasticsearch
ln -s $ES_HOME/log/ /var/log/elasticsearch
#判断是否为centos7
if [ -e /etc/systemd ];
then 
	cp $ES_HOME/init.d/elasticsearch.service /usr/lib/systemd/system/elasticsearch.service
	systemctl daemon-reload
else
	ln -s $ES_HOME/init.d/elasticsearch /etc/init.d/elasticsearch
fi
echo -e "-------------------------------\n\t安装完毕！正在启动\n-------------------------------"
service elasticsearch start
exit $?
