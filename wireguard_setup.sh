#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
deepblue='\033[0;34m'
purple='\033[0;35m'
skyblue='\033[0;36m'
plain='\033[0m'

#检查用户权限
[[ $EUID -ne 0 ]] && echo -e "[${red}Error${plain}] You are not the root!Please run this script as sudo!" && exit 1

#更新内核
centos_update_kernel(){
    yum -y install epel-release
    sed -i "0,/enabled=0/s//enabled=1/" /etc/yum.repos.d/epel.repo
    yum remove -y kernel-devel
    rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
    rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
    yum --disablerepo="*" --enablerepo="elrepo-kernel" list available
    yum -y --enablerepo=elrepo-kernel install kernel-ml
    sed -i "s/GRUB_DEFAULT=saved/GRUB_DEFAULT=0/" /etc/default/grub
    grub2-mkconfig -o /boot/grub2/grub.cfg
    wget https://elrepo.org/linux/kernel/el7/x86_64/RPMS/kernel-ml-devel-4.19.1-1.el7.elrepo.x86_64.rpm
    rpm -ivh kernel-ml-devel-4.19.1-1.el7.elrepo.x86_64.rpm
    yum -y --enablerepo=elrepo-kernel install kernel-ml-devel
    read -p "需要重启VPS，再次执行脚本选择安装wireguard，是否现在重启 ? [Y/n] :" yn
	[ -z "${yn}" ] && yn="y"
	if [[ $yn == [Yy] ]]; then
		echo -e "VPS 重启中..."
		reboot
	fi
}

#生成随机端口函数
rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(cat /dev/urandom | head -n 10 | cksum | awk -F ' ' '{print $1}')
    echo $(($num%$max+$min))
}

config_client(){
    cat > /etc/wireguard/client.conf <<-EOF
[Interface]
PrivateKey = $c1
Address = 10.0.0.2/24 
DNS = 8.8.8.8
MTU = 1420

[Peer]
PublicKey = $s2
Endpoint = $serverip:$port
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25
EOF

}

#判断系统
check_sys(){
    if [ ! -e '/etc/redhat-release' ]; then
    echo "仅支持centos7"
    exit
    fi
    if  [ -n "$(grep ' 6\.' /etc/redhat-release)" ] ;then
    echo "仅支持centos7"
    exit
    fi
}

#centos7安装wireguard
centos_wireguard_install(){
    check_sys
    curl -Lo /etc/yum.repos.d/wireguard.repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
    yum install -y dkms gcc-c++ gcc-gfortran glibc-headers glibc-devel libquadmath-devel libtool systemtap systemtap-devel
    yum -y install wireguard-dkms wireguard-tools
    yum -y install qrencode
    mkdir /etc/wireguard
    cd /etc/wireguard
    wg genkey | tee sprivatekey | wg pubkey > spublickey
    wg genkey | tee cprivatekey | wg pubkey > cpublickey
    s1=$(cat sprivatekey)
    s2=$(cat spublickey)
    c1=$(cat cprivatekey)
    c2=$(cat cpublickey)
    serverip=$(curl ipv4.icanhazip.com)
    port=$(rand 10000 60000)
    chmod 777 -R /etc/wireguard
    systemctl stop firewalld
    systemctl disable firewalld
    yum install -y iptables-services 
    systemctl enable iptables 
    systemctl start iptables 
    iptables -P INPUT ACCEPT
    iptables -P OUTPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -F
    service iptables save
    service iptables restart
    echo 1 > /proc/sys/net/ipv4/ip_forward
    echo "net.ipv4.ip_forward = 1" > /etc/sysctl.conf	

cat > /etc/wireguard/wg0.conf <<-EOF
[Interface]
PrivateKey = $s1
Address = 10.0.0.1/24 
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ListenPort = $port
DNS = 8.8.8.8
MTU = 1420

[Peer]
PublicKey = $c2
AllowedIPs = 10.0.0.2/32
EOF

    config_client
    wg-quick up wg0
    systemctl enable wg-quick@wg0
    echo "wireguard安装完成，请注意在管理控制台中开放udp对应的wireguard端口"
    echo "电脑端请下载client.conf，手机端可直接使用软件扫码"
    echo "$(cat /etc/wireguard/client.conf)" | qrencode -o - -t UTF8
}

#centos7升级wireguard
centos_wireguard_update(){
    yum update -y wireguard-dkms wireguard-tools
    echo "更新完成"
}

#centos7卸载wireguard
centos_wireguard_remove(){
    yum remove -y wireguard-dkms wireguard-tools
    rm -rf /etc/wireguard/
    ifconfig wg0 down
    echo "卸载完成"
}

#ubuntu安装wireguard
ubuntu_wireguard_install(){
    apt update -y
    apt install software-properties-common -y
    add-apt-repository ppa:wireguard/wireguard -y
    apt update -y
    apt install wireguard resolvconf qrencode -y
    cd /etc/wireguard
    wg genkey | tee sprivatekey | wg pubkey > spublickey
    wg genkey | tee cprivatekey | wg pubkey > cpublickey

    s1=$(cat sprivatekey)
    s2=$(cat spublickey)
    c1=$(cat cprivatekey)
    c2=$(cat cpublickey)
    serverip=$(curl ipv4.icanhazip.com)
    port=$(rand 10000 60000)

    cat > /etc/wireguard/wg0.conf<<-EOF
[Interface]
PrivateKey = $(cat sprivatekey)
Address = 10.0.0.1/24 
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ListenPort = $port
DNS = 8.8.8.8
MTU = 1420
[Peer]
PublicKey = $(cat cpublickey)
AllowedIPs = 10.0.0.2/32
EOF
	
    chmod 777 -R /etc/wireguard
    echo 1 > /proc/sys/net/ipv4/ip_forward
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p > /dev/null

    config_client
    wg-quick up wg0
    systemctl enable wg-quick@wg0
    echo "wireguard安装完成，请注意在管理控制台中开放udp对应的wireguard端口"
    echo "电脑端请下载client.conf，手机端可直接使用软件扫码"
    echo "$(cat /etc/wireguard/client.conf)" | qrencode -o - -t UTF8
}

#ubuntu升级wireguard
ubuntu_wireguard_update(){
    apt upgrade -y wireguard
    echo "更新完成"
}

#ubuntu卸载wireguard
ubuntu_wireguard_remove(){
    apt autoremove -y wireguard resolvconf qrencode
    rm -rf /etc/wireguard/
    ifconfig wg0 down
    echo "卸载完成"
}

#debian安装wireguard
debian_wireguard_install(){
    apt update -y
    apt install linux-headers-$(uname -r) -y
    echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable.list
    echo -e 'Package: *\nPin: release a=unstable\nPin-Priority: 150' > /etc/apt/preferences.d/limit-unstable
    apt update -y
    apt install wireguard resolvconf qrencode -y
    cd /etc/wireguard
    wg genkey | tee sprivatekey | wg pubkey > spublickey
    wg genkey | tee cprivatekey | wg pubkey > cpublickey

    s1=$(cat sprivatekey)
    s2=$(cat spublickey)
    c1=$(cat cprivatekey)
    c2=$(cat cpublickey)
    serverip=$(curl ipv4.icanhazip.com)
    port=$(rand 10000 60000)

    cat > /etc/wireguard/wg0.conf<<-EOF
[Interface]
PrivateKey=$(cat sprivatekey)
Address=10.0.0.1/24
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ListenPort = $port
DNS = 8.8.8.8
MTU=1420
[Peer]
PublicKey=$(cat cpublickey)
AllowedIPs=10.0.0.2/32
EOF

    chmod 777 -R /etc/wireguard
    echo 1 > /proc/sys/net/ipv4/ip_forward
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p > /dev/null

    config_client
    wg-quick up wg0
    systemctl enable wg-quick@wg0
    echo "wireguard安装完成，请注意在管理控制台中开放udp对应的wireguard端口"
    echo "电脑端请下载client.conf，手机端可直接使用软件扫码"
    echo "$(cat /etc/wireguard/client.conf)" | qrencode -o - -t UTF8
}

#debian升级wireguard
debian_wireguard_update(){
    apt upgrade -y wireguard
    echo "更新完成"
}

#卸载wireguard
debian_wireguard_remove(){
    apt autoremove -y wireguard resolvconf qrencode
    rm -rf /etc/wireguard/
    ifconfig wg0 down
    echo "卸载完成"
}

#显示客户端二维码
read_qrcode(){
    echo -e ${red}"Here's your /etc/wireguard directory"${plain}
    ls /etc/wireguard
    read -p "请输入需要读取的配置文件路径(如:client.conf):" config
    echo "$(cat /etc/wireguard/$config)" | qrencode -o - -t UTF8
}

#设置多用户
config_multiuser(){

    serverip=$(curl ipv4.icanhazip.com)
    port=`wg | grep "listening port" | tr -cd "[0-9]"`
    
    cd /etc/wireguard
    echo -e ${red}"Here's your /etc/wireguard directory"${plain}
    ls /etc/wireguard
    read -p "please input the private network ip:" ip
    read -p "please input the client name:" name
    wg genkey | tee cprivatekey1 | wg pubkey > cpublickey1
    wg set wg0 peer $(cat cpublickey1) allowed-ips 10.0.0.${ip}/32
    wg-quick save wg0
    cat > /etc/wireguard/client${ip}_${name}.conf<<-EOF
[Interface]
PrivateKey = $(cat cprivatekey1)
Address = 10.0.0.${ip}/24
DNS = 8.8.8.8
MTU = 1420
[Peer]
PublicKey = $(cat spublickey)
Endpoint = $serverip:$port
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25
EOF

    echo "$(cat client${ip}_${name}.conf)" | qrencode -o - -t UTF8
}

#开始菜单
start_menu(){
    clear
    echo -e ${skyblue}"
 __      __.__                                             .___                __                
/  \    /  \__|______   ____   ____  __ _______ _______  __| _/   ______ _____/  |_ __ ________  
\   \/\/   /  \_  __ \_/ __ \ / ___\|  |  \__  \\_  __ \/ __ |   /  ___// __ \   __\  |  \____ \ 
 \        /|  ||  | \/\  ___// /_/  >  |  // __ \|  | \/ /_/ |   \___ \\  ___/|  | |  |  /  |_> >
  \__/\  / |__||__|    \___  >___  /|____/(____  /__|  \____ |  /____  >\___  >__| |____/|   __/ 
       \/                  \/_____/            \/           \/       \/     \/           |__|    
富强，民主，文明，和谐。
自由，平等，公正，法治。
爱国，敬业，诚信，友善。
"
    echo -e ${red}"介绍：wireguard一键安装工具"
    echo -e "已在centos7+ ubuntu16.04+ debian9+ 测试通过"
    echo -e "========================="
    echo -e ${deepblue}"1.  centos升级系统内核"
    echo -e "2.  centos安装wireguard"
    echo -e "3.  centos升级wireguard"
    echo -e "4.  centos卸载wireguard"
    echo -e ${green}"5.  ubuntu安装wireguard"
    echo -e "6.  ubuntu升级wireguard"
    echo -e "7.  ubuntu卸载wireguard"
    echo -e ${yellow}"8.  debian安装wireguard"
    echo -e "9.  debian升级wireguard"
    echo -e "10  debian卸载wireguard"
    echo -e ${purple}"11. 显示客户端二维码"
    echo -e ${skyblue}"12. 设置多用户"  
    echo -e ${red}"0. 退出脚本"
    echo -e ${plain}
    read -p "请输入数字:" num
    case "$num" in
    1)
    centos_update_kernel
    ;;
    2)
    centos_wireguard_install
    ;;
    3)
    centos_wireguard_update
    ;;
    4)
    centos_wireguard_remove
    ;;
    5)
    ubuntu_wireguard_install
    ;;
    6)
    ubuntu_wireguard_update
    ;;
    7)
    ubuntu_wireguard_remove
    ;;
    8)
    debian_wireguard_install
    ;;
    9)
    debian_wireguard_update
    ;;
    10)
    debian_wireguard_remove
    ;;
    11)
    read_qrcode
    ;;
    12)
    config_multiuser
    ;;
    0)
    exit 1
    ;;
    *)
    clear
    echo "请输入正确数字"
    sleep 5s
    start_menu
    ;;
    esac
}

start_menu
