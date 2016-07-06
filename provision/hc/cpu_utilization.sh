#!/bin/bash

# Modified from https://github.com/andrewpuch/consul_demo/blob/master/scripts/cpu_utilization.sh

CPU_UTILIZATION=`top -b -n2 | grep -o "[\.0-9]* id" | tail -1 | cut -f1 -d' '`
CPU_UTILIZATION=$(echo "scale = 2; 100-$CPU_UTILIZATION" | bc)
CPU_UTILIZATION=${CPU_UTILIZATION%.*}

if [ -z "$CPU_UTILIZATION" ]
then
    CPU_UTILIZATION=0
fi

echo "CPU: "$CPU_UTILIZATION"%"

if (( $CPU_UTILIZATION > 95 ));
then
    ps aux --sort=-pcpu | head -n 6
    exit 2
fi

if (( $CPU_UTILIZATION > 70 ));
then
    ps aux --sort=-pcpu | head -n 6
    exit 1
fi

exit 0
