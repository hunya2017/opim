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



# 修改openwrt登陆地址,把下面的 10.0.0.1 修改成你想要的就可以了
# sed -i 's/192.168.1.1/192.168.24.1/g' package/base-files/files/bin/config_generate

# 修改 子网掩码
# sed -i 's/255.255.255.0/255.255.0.0/g' package/base-files/files/bin/config_generate

# 修改主机名字，把 iStore OS 修改你喜欢的就行（不能纯数字或者使用中文）
# sed -i 's/OpenWrt/iStore OS/g' package/base-files/files/bin/config_generate

# 替换终端为bash
# sed -i 's/\/bin\/ash/\/bin\/bash/' package/base-files/files/etc/passwd

# ttyd 自动登录
# sed -i "s?/bin/login?/usr/libexec/login.sh?g" ${GITHUB_WORKSPACE}/openwrt/package/feeds/packages/ttyd/files/ttyd.config

# 添加新的主题
# git clone https://github.com/kenzok8/luci-theme-ifit.git package/lean/luci-theme-ifit

# 添加常用软件包
# git clone https://github.com/kenzok8/openwrt-packages.git package/openwrt-packages

# 删除默认密码
# sed -i "/CYXluq4wUazHjmCDBCqXF/d" package/lean/default-settings/files/zzz-default-settings

# 取消bootstrap为默认主题
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 修改 WiFi 名称
# sed -i 's/OpenWrt/OpenWrt/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 默认打开 WiFi
# sed -i 's/disabled=1/disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# Configure pppoe connection
#uci set network.wan.proto=pppoe
#uci set network.wan.username='yougotthisfromyour@isp.su'
#uci set network.wan.password='yourpassword'

# 移除重复软件包
# rm -rf feeds/luci/themes/luci-theme-argon

# Themes
# git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon
# git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git lpackage/uci-theme-argon
# echo 'src-git argon https://github.com/jerrykuku/luci-theme-argon' >>feeds.conf.default
# git clone -b 18.06 https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
# echo 'src-git argon-config https://github.com/jerrykuku/luci-app-argon-config' >>feeds.conf.default

# 添加额外软件包


# 科学上网插件


# 科学上网插件依赖



# openclash
# svn export https://github.com/kenzok8/openwrt-packages/luci-app-openclash  package/luci-app-openclash
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-openclash  package/luci-app-openclash
# 加入OpenClash核心
# chmod -R a+x $GITHUB_WORKSPACE/preset-clash-core.sh
# if [ "$1" = "rk33xx" ]; then
#     $GITHUB_WORKSPACE/preset-clash-core.sh arm64
# elif [ "$1" = "rk35xx" ]; then
#     $GITHUB_WORKSPACE/preset-clash-core.sh arm64
# elif [ "$1" = "x86" ]; then
#     $GITHUB_WORKSPACE/preset-clash-core.sh amd64
# fi

# adguardhome
# svn export https://github.com/kenzok8/openwrt-packages/luci-app-adguardhome package/luci-app-adguardhome
# svn export https://github.com/kenzok8/openwrt-packages/adguardhome package/adguardhome
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-adguardhome package/luci-app-adguardhome
# svn export https://github.com/kiddin9/openwrt-packages/trunk/adguardhome package/adguardhome

# mosdns
# svn export https://github.com/kenzok8/openwrt-packages/luci-app-mosdns package/luci-app-mosdns
# svn export https://github.com/kenzok8/openwrt-packages/mosdns package/mosdns
# svn export https://github.com/kenzok8/openwrt-packages/v2dat package/v2dat
# svn export https://github.com/kiddin9/openwrt-packages/trunk/luci-app-mosdns package/luci-app-mosdns
# svn export https://github.com/kiddin9/openwrt-packages/trunk/mosdns package/mosdns
# svn export https://github.com/kiddin9/openwrt-packages/trunk/v2dat package/v2dat


# 自定义定制选项
# NET="package/base-files/files/bin/config_generate"
# ZZZ="package/emortal/default-settings/files/99-default-settings"
# 定义路径变量
UCI_DEFAULTS="package/emortal/default-settings/files/etc/uci-defaults/99-custom-init"

# 创建目录
mkdir -p "$(dirname "$UCI_DEFAULTS")"

# 写入首次启动脚本内容
cat << 'EOF' > "$UCI_DEFAULTS"
#!/bin/sh

# 日志重定向
exec >/tmp/setup.log 2>&1

# 设置 root 密码
root_password="password"
[ -n "$root_password" ] && (echo "$root_password"; sleep 1; echo "$root_password") | passwd > /dev/null

# 设置 LAN IP
lan_ip_address="192.168.10.1"
[ -n "$lan_ip_address" ] && {
  uci set network.lan.ipaddr="$lan_ip_address"
  uci commit network
}

# 设置 DHCP 租期
uci set dhcp.lan.leasetime='2m'

# 添加静态 DHCP 租约
uci add dhcp host
uci add_list dhcp.@host[-1].mac='6A:CE:3B:D4:CB:8B'
uci set dhcp.@host[-1].ip='192.168.10.158'

uci add dhcp host
uci add_list dhcp.@host[-1].mac='30:9C:23:E1:E3:72'
uci set dhcp.@host[-1].ip='192.168.10.107'

uci add dhcp host
uci add_list dhcp.@host[-1].mac='7C:2B:E1:13:6E:83'
uci set dhcp.@host[-1].ip='192.168.10.180'

uci commit dhcp

# 配置 zerotier
uci set zerotier.sample_config.enabled='1'
uci del zerotier.sample_config.join
uci add_list zerotier.sample_config.join='d3ecf5726da3eeac'
uci set zerotier.sample_config.nat='1'
uci commit zerotier

# 配置 vlmcsd 服务
uci set vlmcsd.config.enabled='1'
uci set vlmcsd.config.auto_activate='1'
uci set vlmcsd.config.internet_access='1'
uci commit vlmcsd

echo "All done!"
exit 0
EOF

# 添加执行权限
chmod +x "$UCI_DEFAULTS"

