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

# 定义路径变量
UCI_DEFAULTS="package/emortal/default-settings/files/99-my-default-settings"



# 添加执行权限
chmod +x "$UCI_DEFAULTS"
# 修复 luci-app-store 版本号，防止 apk mkpkg 报错
LUCISTORE_MK="feeds/istore/luci/luci-app-store/Makefile"
if [ -f "$LUCISTORE_MK" ]; then
    sed -i 's/\(PKG_VERSION:=.*\)-\([0-9]\+\)/\1-r\2/' "$LUCISTORE_MK"
    echo "已修正 luci-app-store 版本号为 apk 兼容格式"
fi
