#!/bin/bash
# A simple iptables firewall configuration

PATH=/sbin:/bin:/usr/sbin:/usr/bin; export PATH

iptables -F #清除所有已制定的rule
iptables -X #清除用户自定义的chain/table
iptables -Z #将所有的chain的计数和流量统计归零

#接受本机localhost的任何请求，否则，数据库连接等将无法工作
iptables -A INPUT -i lo -j ACCEPT

# 允许所有从服务器端发起的连接，由此返回的响应数据应该是允许的！比如VPS发起的yum update , 必须要允许外部的update数据进来
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#阻止简单扫描和攻击的规则
#NONE 包(所有标识bit都没有设置)主要是扫描类的数据包
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
#防止sync-flood 攻击
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
#ALL包（所有的标注bit都被设置了）也是网络扫描的数据包
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

#open ports for different services
iptables -A INPUT -p tcp --dport 22 -j ACCEPT #SSH
iptables -A INPUT -p tcp --dport 80 -j ACCEPT #HTTP
iptables -A INPUT -p tcp --dport 3690 -j ACCEPT #SVN
#iptables -A INPUT -p tcp --dport 443 -j ACCEPT #HTTPS
#iptables -A INPUT -p tcp --dport 25 -j ACCEPT #SMTP
#iptables -A INPUT -p tcp --dport 465 -j ACCEPT #Secure SMTP
#iptables -A INPUT -p tcp --dport 110 -j ACCEPT #POP3
#iptables -A INPUT -p tcp --dport 995 -j ACCEPT #Secure POP

#ICMP configuration
#To prevent ICMP DDOS,we do not allow ICMP type 8(echo-request) or limit this request with 1/second
#some ICMP requests are allowed.
icmp_type="0 3 4 11 12 14 16 18"
for ticmp in $icmp_type
do
    iptables -A INPUT -p icmp --icmp-type $ticmp -j ACCEPT
done
#iptables -A INPUT -p icmp --icmp-type 8 -m limit --limit 1/second -j ACCEPT

#default policies
#设置缺省的策略：屏蔽任何进入的数据请求，允许所有从Server发出的请求
iptables -P OUTPUT ACCEPT
iptables -P INPUT DROP

#save to /etc/sysconfig/iptables
/etc/init.d/iptables save