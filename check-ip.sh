#!/bin/bash

# 执行ping命令，并检查结果
if ping -c 5 -W 2 -i 0.2 112.34.116.1 | grep "100% packet loss" > /dev/null
then
    echo "当前IP已经被封锁，正在尝试换IP..." 
    # 执行换IP的命令
    bash changeip.sh
    echo "IP已经更换完成。" | tee -a $LOG_FILE
else
    echo "当前IP未被封锁" 
fi
