#!/bin/bash
#cd  /root/miui-auto-tasks
cd "$( dirname "${BASH_SOURCE[0]}" )"
pwd
echo `date` >> test.txt ###向test.txt中插入一条"时间日志"
/usr/bin/python3 miuitask.py
r=$(($RANDOM%50)) ###随机生成一个10以内的随机数
rm -f test.cron                ###删除以前的命令文件
echo $[r]" 8 * * * "$( dirname "${BASH_SOURCE[0]}" )"/test.sh" >> test.cron #创建并将任务写入cron文件
echo "40 3 * * * "/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" > /dev/null"   >> test.cron        
chmod 777  test.sh  ###给予shell脚本最高执行权限
crontab test.cron    ###启动cron任务文件，用于定时自动执行
