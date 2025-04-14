#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# ./scripts/feeds update istore
# ./scripts/feeds install -d y -p istore luci-app-store

# 定义路径变量
UCI_DEFAULTS="package/emortal/default-settings/files/99-default-settings"

# 确保目录和文件存在
mkdir -p "$(dirname "$UCI_DEFAULTS")"
if [ ! -f "$UCI_DEFAULTS" ]; then
  echo "#!/bin/sh" >"$UCI_DEFAULTS"
  echo "exit 0" >>"$UCI_DEFAULTS"
fi

# 使用 cat <<EOF 创建插入内容
INSERT_CONTENT=$(cat <<EOF
# 日志重定向
exec >/tmp/setup.log 2>&1

<<<<<<< HEAD
# 
uci set network.lan.ipaddr='192.168.10.1'
uci commit network
=======
# Set a default root password if not already set


# Configure LAN
uci set network.lan.ipaddr="192.168.10.1"
uci commit network

>>>>>>> 67067c51cbf5a96e746c343690846a2a495c299f

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

# 配置 zerotier
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

echo "All done!"
EOF
)

# 手动插入内容到 exit 0 之前
awk -v insert="$INSERT_CONTENT" '
/^exit 0$/ {
    print insert
}
{ print }
' "$UCI_DEFAULTS" > "${UCI_DEFAULTS}.tmp" && mv "${UCI_DEFAULTS}.tmp" "$UCI_DEFAULTS"

# 添加执行权限
chmod +x "$UCI_DEFAULTS"
