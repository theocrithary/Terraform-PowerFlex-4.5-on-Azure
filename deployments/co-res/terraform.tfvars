### cluster 
resource_group_name = ""
prefix              = ""
location            = ""
is_multi_az         = false
cluster_node_count  = 3
tags = {
  user = ""
}

### data disk
data_storage_account_type = "PremiumV2_LRS" #"UltraSSD_LRS"
data_disk_size_gb         = "256"
data_disk_count           = 1
data_disk_iops_read_write = "3000" #only for ultra and SSDv2 disk
data_disk_mbps_read_write = "125"  #only for ultra and SSDv2 disk
