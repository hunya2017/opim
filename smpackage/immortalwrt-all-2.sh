#!/bin/bash
# 定义路径变量
UCI_DEFAULTS="package/emortal/default-settings/files/99-MY-settings"
# 确保目录存在
mkdir -p "$(dirname "$UCI_DEFAULTS")"

# 直接创建/覆盖 99-MY-settings 文件
cat <<EOF >"$UCI_DEFAULTS"
#!/bin/sh
# 日志重定向
exec >/tmp/setup.log 2>&1

# Set a default root password if not already set
(echo "password"; sleep 1; echo "password") | passwd > /dev/null

# 设置主机ip地址 
uci set network.lan.ipaddr='192.168.10.1'
sleep 1
uci commit network

# 设置 DHCP 租期
uci set dhcp.lan.leasetime="2m"

# 添加静态 DHCP 租约
uci add dhcp host
uci add_list dhcp.@host[-1].mac="6A:CE:3B:D4:CB:8B"
uci set dhcp.@host[-1].ip="192.168.10.158"

uci add dhcp host
uci add_list dhcp.@host[-1].mac="30:9C:23:E1:E3:72"
uci set dhcp.@host[-1].ip="192.168.10.107"

uci add dhcp host
uci add_list dhcp.@host[-1].mac="7C:2B:E1:13:6E:83"
uci set dhcp.@host[-1].ip="192.168.10.180"

sleep 1
uci commit dhcp

# 配置 zerotier
uci set zerotier.sample_config.enabled="1"
uci del zerotier.sample_config.join
uci add_list zerotier.sample_config.join="d3ecf5726da3eeac"
uci set zerotier.sample_config.nat="1"
sleep 1
uci commit zerotier

# 配置 vlmcsd 服务
uci set vlmcsd.config.enabled="1"
uci set vlmcsd.config.auto_activate="1"
uci set vlmcsd.config.internet_access="1"
sleep 1
uci commit vlmcsd

echo "All done!"
exit 0
EOF

# 添加执行权限
chmod +x "$UCI_DEFAULTS"
