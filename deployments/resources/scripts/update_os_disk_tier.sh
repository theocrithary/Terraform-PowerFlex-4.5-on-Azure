#!/bin/bash

CLUSTER_OS_DISKS=$(terraform output -json pfmp_os_disk_names)
RESOURCE_GROUP=$(terraform output resource_group_name | jq -r)

az login --service-principal -u ${ARM_CLIENT_ID} -p ${ARM_CLIENT_SECRET} --tenant ${ARM_TENANT_ID}

x=3
echo $CLUSTER_OS_DISKS | jq -r '.[0:3][]' | jq -r '.[]' | while read i;  
do 
    if [[ $x > 0 ]]; 
    then 
        echo "Updating tier of: $i to P40"
        az disk update -n $i -g $RESOURCE_GROUP --set tier=P40 --no-wait  
        ((x--))
    fi  
done

updated_count=0
temp_file=$(mktemp)


while true; do
    echo "Checking disk tiers... (every 10s)"

    echo $CLUSTER_OS_DISKS | jq -r '.[0:3][]' | jq -r '.[]' | while read i;
    do
        CURRENT_TIER=$(az disk show --resource-group $RESOURCE_GROUP --name $i | grep 'tier.*P[1-8]0' | awk '{print $2}' | tr -d '",')
        
        if [[ $CURRENT_TIER == "P40" ]]; then
            echo "Disk $i has tier P40."
            ((updated_count++))
        else
            echo "Disk $i: current tier $CURRENT_TIER, has not reached tier P40 yet."
        fi
        echo "$updated_count" > $temp_file
    done

    # Sleep for 10 seconds before checking again
    read_updated_count=$(< $temp_file)
    if [[ $read_updated_count -ge 3 ]]; then
        break
    else
        sleep 10
    fi    
done

rm -f $temp_file
echo "All disks have reached tier P40!"


