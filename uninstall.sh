#!/bin/bash
service elasticsearch stop
rm -rf /var/run/elasticsearch
rm -rf /etc/elasticsearch
rm -rf /var/log/elasticsearch
if [ -e /etc/systemd ];
then 
	systemctl disable elasticsearch
	rm -rf /usr/lib/systemd/system/elasticsearch.service
	systemctl daemon-reload
else
	chkconfig elasticsearch off
	rm -rf /etc/init.d/elasticsearch
fi
userdel -rZ elasticsearch &>/dev/null
echo "其他文件删除完毕，请手工删除该目录或运行install.sh重新安装！"
