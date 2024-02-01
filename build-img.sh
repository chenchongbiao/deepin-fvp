#!/bin/bash

# 何命令失败（退出状态非0），则脚本会终止执行
set -o errexit
# 尝试使用未设置值的变量，脚本将停止执行
set -o nounset

# 不进行交互安装
export DEBIAN_FRONTEND=noninteractive

ROOTFS=`mktemp -d`
TARGET_ARCH=arm64
COMPONENTS=stable
DISKSIZE="2048"
DISKIMG="deepin.img"
readarray -t REPOS < ./config/apt/sources.list
PACKAGES=`cat ./config/packages.list/packages.list | grep -v "^-" | xargs | sed -e 's/ /,/g'`

sudo apt install -y curl git mmdebstrap qemu-user-static usrmerge usr-is-merged binfmt-support systemd-container
# 开启异架构支持
sudo systemctl start systemd-binfmt

# 生成 img
# 创建一个空白的镜像文件。
dd if=/dev/zero of=$DISKIMG bs=1M count=$DISKSIZE
# 将img文件格式化为ext4文件系统
mkfs.ext4 $DISKIMG
# 挂载 deepin.img 镜像
sudo mount -o loop $DISKIMG $ROOTFS
sudo rm -rf $ROOTFS/lost+found

# 创建根文件系统
sudo mmdebstrap \
    --hook-dir=/usr/share/mmdebstrap/hooks/merged-usr \
    --include=$PACKAGES \
    $COMPONENTS \
    --arch=$TARGET_ARCH \
    --customize=./config/hooks.chroot/second-stage \
    $ROOTFS \
    "${REPOS[@]}"

sudo echo "deepin-tc" | sudo tee $ROOTFS/etc/hostname > /dev/null
sudo echo "Asia/Shanghai" | sudo tee $ROOTFS/etc/timezone > /dev/null
sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai $ROOTFS/etc/localtime

# 卸载
# sudo umount $ROOTFS
