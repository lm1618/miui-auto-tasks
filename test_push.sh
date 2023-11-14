#!/bin/bash
#cd  /root/miui-auto-tasks
cd "$( dirname "${BASH_SOURCE[0]}" )"
pwd
#rm -f test.txt
echo `date` >> test.txt ###向test.txt中插入一条"时间日志"
#/usr/bin/python3 miuitask.py 
/usr/bin/python3 xiaomi.py >> test.txt
/usr/bin/python3 xiaomi2.py >> test.txt
/usr/bin/python3 xiaomi3.py >> test.txt

#/usr/bin/python3 xiaomi_all.py >> test.txt

tail -n 26 test.txt

#cat test.txt

r=$(($RANDOM%50)) ###随机生成一个10以内的随机数
rm -f test.cron                ###删除以前的命令文件
echo $[r]" 6 * * * /root/miui-auto-tasks/test.sh" >> test.cron #创建并将任务写入cron文件
echo "40 3 * * * "/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" > /dev/null"   >> test.cron        
chmod 777  test.sh  ###给予shell脚本最高执行权限
crontab test.cron    ###启动cron任务文件，用于定时自动执行

line=$(tail -n 26 test.txt)

#pushplus的相关参数 添加token
TOKEN="XXXXXXXXXXXXX"
TITLE="社区签到提醒"
CONTENT=$line
URL="https://www.pushplus.plus/send/"

# 定义文件用于记录是否已经发送过通知
SENT_FLAG_FILE="sent.flag"

# 判断文件是否存在
if [ -e "$SENT_FLAG_FILE" ]; then
    # 获取文件的创建时间（秒级时间戳）
    file_creation_time=$(stat -c %Y "$SENT_FLAG_FILE")

    # 获取第二天的0点时间（秒级时间戳）
    next_day_start_time=$(date -d "tomorrow" +%s)

    # 判断文件的创建时间是否大于等于第二天的0点时间
    if [ "$file_creation_time" -ge "$next_day_start_time" ]; then
        # 删除标志文件
        rm "$SENT_FLAG_FILE"
    fi
fi

# 检查是否已经发送过通知
if [ ! -e "$SENT_FLAG_FILE" ]; then
    # 发送HTTP POST请求
    response=$(curl -s -X POST -d "token=$TOKEN&title=$TITLE&content=$CONTENT" "$URL")

    # 解析响应JSON，您需要根据实际情况来提取返回码
    code=$(echo "$response" | jq -r '.code')
    echo $response

    # 判断返回码是否为900（用户账号使用受限）
    if [ "$code" -eq 900 ]; then
        # 创建标志文件，表示已经发送过通知
        touch "$SENT_FLAG_FILE"
    fi
fi

