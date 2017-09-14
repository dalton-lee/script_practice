#!/bin/bash

#当前日期
today=`date "+%Y%m%d"`

# 设置回收路径
trashPath=$HOME/.Trash

# 创建回收文件夹
if [ ! -d "$trashPath" ]; then
    mkdir $trashPath
fi

# 清除命令中的所有开关选项
args=${@##-*}

# 移动文件并备份，如有必要，修改错误信息并输出
msg=`mv --backup=t $args $trashPath 2>&1`
if [ ! "$msg" = "" ]; then
    echo ${msg//mv/.rm.sh}  # 将错误信息中的“mv”替换成".rm.sh"
fi

# 设置标志文件路径
flagFile=$trashPath/.flag

# ======================================
# 每天第一次使用这个命令后，清理一段时间以前回收的文件
# ------------------------------  
# 定义清理旧文件的函数
function clearOldFile()
{
    echo "delete old file, please wait ..."
    find $trashPath -maxdepth 1 -ctime +7 |xargs /bin/rm -rf
    echo $today > $flagFile # 输出今天的日期到标志文件
}

if [ -f "$flagFile" ]; then
    lastDate=`cat $flagFile`  # 读取标志文件中的日期
    if [ "$lastDate" -ne "$today" ]; then  # 如果不是今天的日期就清理
        clearOldFile
    fi
else  # 标志文件不存在也要清理
    clearOldFile
fi
