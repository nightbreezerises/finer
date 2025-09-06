#!/bin/bash
#必须在finer目录下执行，日志存放在/log目录下

# 检查参数
if [ $# -lt 1 ]; then
    echo "用法: $0 <脚本路径>"
    exit 1
fi

# 输入脚本路径（相对路径）
relpath="$1"

# 确保输入文件存在
if [ ! -f "$relpath" ]; then
    echo "错误: 文件 $relpath 不存在"
    exit 1
fi

# 去掉扩展名，换成 .log，并放到 log/ 下
base_logpath="log/${relpath%.*}.log"
logpath="$base_logpath"

# 确保目录存在
mkdir -p "$(dirname "$logpath")"

# 如果日志文件已存在，自动递增文件名
n=1
while [ -f "$logpath" ]; do
    logpath="${base_logpath%.log}($n).log"
    n=$((n + 1))
done

# 启动脚本并写入日志（实时输出）
nohup stdbuf -oL -eL bash "$relpath" > "$logpath" 2>&1 &
echo "已启动 $relpath，日志写入 $logpath"
