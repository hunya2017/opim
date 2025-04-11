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

./scripts/feeds update istore
./scripts/feeds install -d y -p istore luci-app-store

# 定义路径变量
UCI_DEFAULTS="package/emortal/default-settings/files/99-default-settings"

# 确保文件存在
if [ ! -f "$UCI_DEFAULTS" ]; then
  echo "#!/bin/sh" >"$UCI_DEFAULTS"
  echo "exit 0" >>"$UCI_DEFAULTS"
fi

# 在 exit 0 之前插入内容
sed -i "/exit 0/i\
# 日志重定向\n\
exec >/tmp/setup.log 2>&1\n\
\n\
# 设置 root 密码\n\
root_password=\"password\"\n\
[ -n \"$root_password\" ] && (echo \"$root_password\"; sleep 1; echo \"$root_password\") | passwd > /dev/null\n\
\n\
# 设置 LAN IP\n\
lan_ip_address=\"192.168.10.1\"\n\
[ -n \"$lan_ip_address\" ] && {\n\
  uci set network.lan.ipaddr=\"$lan_ip_address\"\n\
  uci commit network\n\
}\n\
\n\
# 设置 DHCP 租期\n\
uci set dhcp.lan.leasetime=\"2m\"\n\
\n\
# 添加静态 DHCP 租约\n\
uci add dhcp host\n\
uci add_list dhcp.@host[-1].mac=\"6A:CE:3B:D4:CB:8B\"\n\
uci set dhcp.@host[-1].ip=\"192.168.10.158\"\n\
\n\
uci add dhcp host\n\
uci add_list dhcp.@host[-1].mac=\"30:9C:23:E1:E3:72\"\n\
uci set dhcp.@host[-1].ip=\"192.168.10.107\"\n\
\n\
uci add dhcp host\n\
uci add_list dhcp.@host[-1].mac=\"7C:2B:E1:13:6E:83\"\n\
uci set dhcp.@host[-1].ip=\"192.168.10.180\"\n\
\n\
uci commit dhcp\n\
\n\
# 配置 zerotier\n\
uci set zerotier.sample_config.enabled=\"1\"\n\
uci del zerotier.sample_config.join\n\
uci add_list zerotier.sample_config.join=\"d3ecf5726da3eeac\"\n\
uci set zerotier.sample_config.nat=\"1\"\n\
uci commit zerotier\n\
\n\
# 配置 vlmcsd 服务\n\
uci set vlmcsd.config.enabled=\"1\"\n\
uci set vlmcsd.config.auto_activate=\"1\"\n\
uci set vlmcsd.config.internet_access=\"1\"\n\
uci commit vlmcsd\n\
\n\
echo \"All done!\"" "$UCI_DEFAULTS"

# 添加执行权限
chmod +x "$UCI_DEFAULTS"
