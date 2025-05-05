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

patch -p1 < "openwrt/package/emortal/default-settings/patch1.patch"


# 定义路径变量
UCI_DEFAULTS="package/emortal/default-settings/files/99-my-default-settings"



# 添加执行权限
chmod +x "$UCI_DEFAULTS"
