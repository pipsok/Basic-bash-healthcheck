#!/bin/bash
print_separator() {
    echo "====================="
}
check_network(){
	if 	ping -c 1 1.1.1.1 > /dev/null 2>&1 
		then
			echo -e "${GREEN}Internet: OK${RESET}"
	else
			echo -e "${RED}Internet: DOWN${RESET}"
	fi
}
print_title(){
	echo "========== $1 =========="
}
check_service(){
	if systemctl is-active --quiet "$1" 
	then
		echo "OK"
	else
		echo "DOWN"
	fi
}
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"
USER=$(whoami)
HOST=$(hostname)
KERNEL=$(uname -r)
UPTIME=$(uptime | awk '{print $3}')
DISK=$(df --total | tail -n 1 | awk '{print $5}')
FREE=$(free --giga | awk 'NR == 2{print $3}')
TOTAL=$(free --giga | awk 'NR == 2{print $2}')
JOURNALERRORS=$(journalctl -p err -b | wc -l)
print_separator
echo "HEALTH CHECK BY PAWEL"
print_separator
echo ""
print_title "SYSTEM"
echo "User: $USER"
print_separator
echo "Hostname: $HOST"
print_separator
echo "Kernel: $KERNEL"
print_separator
echo "Uptime: $UPTIME"
print_title "MEMORY"
echo "Disk: / -> $DISK"
print_separator
echo "Memory: ${FREE}GB / ${TOTAL}GB"
print_title "SERVICES"
echo "NetworkManager: $(check_service NetworkManager)"
print_separator
check_network
print_separator
echo "Journal Errors: $JOURNALERRORS"
print_separator
echo "SSHD: $(check_service sshd)"
print_separator
echo "Bluetooth: $(check_service bluetooth)"
print_separator
echo "Cups: $(check_service cups)"