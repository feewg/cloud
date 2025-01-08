#!/bin/bash

# 提示用户输入 swap 大小
if [ -t 0 ]; then
    # 如果是交互式终端
    read -p "Enter swap size (e.g., 1m, 512m, 1g): " swap_size
else
    # 非交互式模式，提供默认值并显示提示
    echo "Enter swap size (e.g., 1m, 512m, 1g):"
    read swap_size
fi

# 检查用户输入是否为空
if [[ -z "$swap_size" ]]; then
    echo "Error: Swap size is required. Please try again."
    exit 1
fi

# 提取数值和单位
size_value=${swap_size%[a-zA-Z]*}
size_unit=${swap_size##*[0-9]}

# 将大小转换为兆字节
case $size_unit in
    m|M)
        count=$size_value
        ;;
    g|G)
        count=$((size_value * 1024))
        ;;
    *)
        echo "Invalid size unit. Please use m for megabytes or g for gigabytes."
        exit 1
        ;;
esac

# 创建 swap 文件
sudo dd if=/dev/zero of=/swapfile bs=1M count=$count

# 设置 swap 文件权限
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# 添加到 /etc/fstab
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# 验证 swap 设置
sudo swapon --show
free -h

echo "Swap file created and activated successfully!"
