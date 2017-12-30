#!/bin/bash

echo "Let's setup a SWAP partition!"
free -m
read -p "Does SWAP have all zeros? (y/n) " hasswap

if [ "$hasswap" == "y" -o "$hasswap" == "yes" -o "$hasswap" == "Y" ]; then
	echo "No SWAP is already setup. Setting up a 2 GB swap space..."
else
	echo "SWAP is already setup."
    exit 0
fi 

dd if=/dev/zero of=/swapfile count=2048 bs=1M
checkswap=$(ls / | grep swapfile)

if [ "$checkswap" == "swapfile" ]; then
	echo "SWAP location confirmed. Continuing setup..."
else
	echo "Error, the swapfile is not located at the root."
    exit 1
fi 

chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo -e "\n/swapfile   none    swap    sw    0   0" >> /etc/fstab

echo "Complete. SWAP should show non-zero numbers below."
free -m