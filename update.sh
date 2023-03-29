#!/bin/bash

# 下载 phone.dat 文件
wget https://raw.githubusercontent.com/xluohome/phonedata/master/phone.dat -O phone.dat.new

# 判断下载是否成功
if [ $? -ne 0 ]; then
    echo "wget phone.dat failed"
    exit 1
fi

# 如果本地存在 phone.dat 文件，则比较新旧文件内容是否相同
if [ -f phone.dat ]; then
    diff phone.dat phone.dat.new
    if [ $? -eq 0 ]; then
        echo "phone.dat is not changed"
        exit 0
    fi
fi

# 替换并更新 phone.dat 文件，并生成新的 base64phone.go 文件
mv phone.dat.new phone.dat
rm -f base64phone.go
echo "package phonedata" > base64phone.go
echo "" >> base64phone.go
echo "func init() {" >> base64phone.go
data=$(cat phone.dat | base64)
echo "    Base64data = \`$data\`" >> base64phone.go
echo "}" >> base64phone.go

# 运行 phonedata.go 文件，从电话号码 19653600740 中解析出归属地信息
# go run cmd/phonedata.go 19653600740