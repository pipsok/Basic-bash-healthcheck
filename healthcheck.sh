#!/bin/bash
print_separator() {
    echo "====================="
}
check_network(){
	if 	ping -c 1 1.1.1.1 > /dev/null 2>&1 
		then
			echo -e "Internet: ${GREEN}OK${RESET}"
			print_separator
	else
			echo -e "Internet: ${RED}DOWN${RESET}"
			print_separator
	fi
}
print_title(){
	echo "========== $1 =========="
}
check_service(){
	if systemctl is-active --quiet "$1" 
	then
		echo -e "${GREEN}OK${RESET}"
	else
		echo -e "${RED}DOWN${RESET}"
	fi
}
print_section() {
    echo -e "$1"
	print_separator
}
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"
USER=$(whoami)
HOST=$(hostname)
KERNEL=$(uname -r)
UPTIME=$(uptime -p)
DISK=$(df --total | tail -n 1 | awk '{print $5}')
FREE=$(free --giga | awk 'NR == 2{print $3}')
TOTAL=$(free --giga | awk 'NR == 2{print $2}')
JOURNALERRORS=$(journalctl -p err -b | wc -l)
print_section "HEALTH CHECK BY PAWEL"
echo ""
print_title "SYSTEM"
print_section "User: ${RED}$USER${RESET}"
print_section "Hostname: $HOST"
print_section "Kernel: $KERNEL"
print_section "Uptime: $UPTIME"
print_title "MEMORY"
print_section "Disk: / -> $DISK"
print_section "Memory: ${FREE}GB / ${TOTAL}GB"
print_title "SERVICES"
check_network
print_section "Journal Errors: $JOURNALERRORS"
for service in NetworkManager bluetooth cups sshd
do
    echo "$service: $(check_service "$service")"
	print_separator
done