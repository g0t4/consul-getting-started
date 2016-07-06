#!/bin/bash

# Modified from https://github.com/andrewpuch/consul_demo/blob/master/scripts/hdd_utilization.sh

HDD_UTILIZATION=`df -lh | awk '{if ($6 == "/") { print $5 }}' | head -1 | cut -d'%' -f1`
HDD_UTILIZATION=${HDD_UTILIZATION%.*}

echo "HDD: "$HDD_UTILIZATION"%"

if (( $HDD_UTILIZATION > 95 ));
then
    exit 2
fi

if (( $HDD_UTILIZATION > 70 ));
then
    exit 1
fi

exit 0
