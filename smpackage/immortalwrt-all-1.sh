#!/bin/bash
# =================================================================
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
# =================================================================

# 添加 iStore
git clone https://github.com/linkease/istore package/istore

# 添加 nikki
git clone https://github.com/nikkinikki-org/OpenWrt-nikki.git package/OpenWrt-nikki

# 添加 momo
git clone https://github.com/nikkinikki-org/OpenWrt-momo.git package/OpenWrt-momo

# 添加 AdGuardHome 插件
git clone https://github.com/rufengsuixing/luci-app-adguardhome package/luci-app-adguardhome
