#!/bin/sh
# filepath: package/emortal/default-settings/files/99-custom-settings

# 日志重定向
exec >/tmp/custom-setup.log 2>&1

# 设置默认 root 密码
root_password="password"
if [ -n "$root_password" ]; then
  (echo "$root_password"; sleep 1; echo "$root_password") | passwd root > /dev/null
fi

# 设置 LAN IP 地址
lan_ip="192.168.10.1"
uci set network.lan.ipaddr="$lan_ip"
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

uci commit dhcp

# 配置 ZeroTier
uci set zerotier.sample_config.enabled="1"
uci del zerotier.sample_config.join
uci add_list zerotier.sample_config.join="d3ecf5726da3eeac"
uci set zerotier.sample_config.nat="1"
uci commit zerotier

# 配置 vlmcsd 服务
uci set vlmcsd.config.enabled="1"
uci set vlmcsd.config.auto_activate="1"
uci set vlmcsd.config.internet_access="1"
uci commit vlmcsd

echo "Custom settings applied successfully!"

exit 0