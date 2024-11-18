### cluster 
prefix = ""
virtual_machine_prefix = ""
resource_group_name  = ""
location = ""
cluster_node_count = ""
is_multi_az = ""
# start_from_lun = #optional if there are some disks attached
tags = {
    user  = ""
  }


### data disk
data_storage_account_type = "PremiumV2_LRS" #"UltraSSD_LRS"
data_disk_size_gb         = "256"
data_disk_count           = 19
data_disk_iops_read_write = "4211" #only for ultra and SSDv2 disk
data_disk_mbps_read_write = "125"  #only for ultra and SSDv2 disk
