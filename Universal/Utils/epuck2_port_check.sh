#!/bin/bash
# Code obtained through Matthieu Broisin.
# ToDo It will be nice to add technical reference

for sysdevpath in $(find /sys/bus/usb/devices/usb*/ -name dev); do
    (
        syspath="${sysdevpath%/dev}"
        devname="$(udevadm info -q name -p $syspath)"
        
        if [[ "$devname" == "bus/"* ]]
        then 
		exit
	fi
				
        eval "$(udevadm info -q property --export -p $syspath)"
        
        if [ -z "$ID_USB_INTERFACE_NUM" ] || [ -z "$ID_SERIAL" ]
        then 
		exit
        fi
        
	if [[ "$ID_SERIAL" == *"STM32F407"* ]]
	then
		echo "/dev/$devname - $ID_SERIAL : Microcontroller (SDU1)"
	elif [[ "$ID_SERIAL" == *"EPUCK"* ]]
	then
		if [ "$ID_USB_INTERFACE_NUM" = "00" ]
		then
			echo "/dev/$devname - $ID_SERIAL : GDB"
		else
			echo "/dev/$devname - $ID_SERIAL : Serial Monitor (SD3)"
		fi
	fi
    )
done
