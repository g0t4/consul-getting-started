#!/bin/bash

AVAILABLE_RAM=`grep MemAvailable /proc/meminfo | awk '{print $2}'`
TOTAL_RAM=`grep MemTotal /proc/meminfo | awk '{print $2}'`
RAM_UTILIZATION=$(echo "scale = 2; 100-$AVAILABLE_RAM/$TOTAL_RAM*100" | bc)
RAM_UTILIZATION=${RAM_UTILIZATION%.*}

echo "RAM: ${RAM_UTILIZATION}%, ${AVAILABLE_RAM} available of ${TOTAL_RAM} total "

if (( $RAM_UTILIZATION > 95 ));
then
    exit 2
fi

if (( $RAM_UTILIZATION > 70 ));
then
    exit 1
fi

exit 0
