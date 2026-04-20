#!/bin/bash

# 1. 修改默认管理 IP (从 192.168.1.1 改为 192.168.2.1)
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 2. 修改默认主机名 (可选)
sed -i "s/ImmortalWrt/OpenWrt/g" package/base-files/files/bin/config_generate

# 3. 创建自动配置文件
# 这个文件会出现在固件的 /etc/uci-defaults/99-custom-settings
# 并在固件刷好后第一次启动时执行
mkdir -p package/base-files/files/etc/uci-defaults
cat <<EOF > package/base-files/files/etc/uci-defaults/99-custom-settings
#!/bin/sh

# 设置 root 密码为 asd931477504
(echo "asd931477504"; sleep 1; echo "asd931477504") | passwd > /dev/null

# 设置 WAN 口 PPPoE 拨号
uci set network.wan.proto='pppoe'
uci set network.wan.username='075502705802@163.gd'
uci set network.wan.password='67052117'
uci commit network

exit 0
EOF

# 4. 确保脚本有执行权限
chmod +x package/base-files/files/etc/uci-defaults/99-custom-settings
