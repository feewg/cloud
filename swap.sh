#!/bin/bash

# Prompt user for swap size
read -p "Enter swap size (e.g., 1m, 512m, 1g): " swap_size

# Extract the numeric value and unit from the input
size_value=${swap_size%[a-zA-Z]*}
size_unit=${swap_size##*[0-9]}

# Convert the size to megabytes
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

# Create swap file
sudo dd if=/dev/zero of=/swapfile bs=1M count=$count

# Set up the swap file
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Add swap file to /etc/fstab for persistence
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Verify swap
sudo swapon --show
free -h

echo "Swap file created and activated."