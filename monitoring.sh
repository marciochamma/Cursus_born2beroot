#!bin/bash

## PROJECT REQUEST

# The architectute of your operating system and its kernel version
arch=$(uname --all)

# The number of physical processors.
pcpu=$(grep "physical id" /proc/cpuinfo | wc -l)

# The number of virtual processors.
vcpu=$(grep processor /proc/cpuinfo | wc -l)

# The current available RAM on your server and its utilization rate as a percentage.
ramused=$(free --mega | awk '$1 == "Mem:" {print $3}')
ramtotal=$(free --mega | awk '$1 == "Mem:" {print $2}')
ramperc=$(free --mega | awk '$1 == "Mem:" {printf("%.2f", $3/$2*100)}')

# The current available memory on your server and its utilization rate as a percentage.
diskused=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{used += $3} END {print used}')
disktotal=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{total += $2} END {printf("%.f", total/1024)}')
diskperc=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{used += $3} {total += $2} END {printf("%.1f", used/total*100)}')

# The current utilization rate of your processors as a percentage.
cpuload=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')

# The date and time of the last reboot.
lastboot=$(uptime --since)

# Whether LVM is active or not.
lvm=$(if [ $(lsblk | grep lvm | wc -l) -eq 0 ]; then echo no; else echo yes; fi)

# The number of active connections.
tcp=$(ss -ta | grep ESTAB | wc -l)

# The number of users using the server.
userlog=$(users | wc -w)

# The IPv4 address of your server and its MAC (Media Access Control) address.
ip=$(hostname -I)
mac=$(ip link | awk '$1 == "link/ether" {print $2}')

# The number of commands executed with the sudo program.
sudo=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

#--------------#

wall "	#Architecture: $arch
	#CPU physical: $pcpu
	#vCPU: $vcpu
	#Memory Usage: $ramused/${ramtotal}MB ($ramperc%)
	#Disk Usage: $diskused/${disktotal}Gb ($diskperc%)
	#CPU Load: $cpuload%
	#Last boot: $lastboot
	#LVM use: $lvm
	#Connections TCP: $tcp ESTABLISHED
	#User log: $userlog
	#Network: IP $ip ($mac)
	#Sudo: $sudo cmd"
