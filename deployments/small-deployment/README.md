Small deployment is used to deploy cluster machines into existing infrastructure in azure. It doesn;t deploy load balancer nor load balancer frontent ip/backend pool - it adds resources to exsisting ones.

The following variables need to be provided (e.g. via terraform.tfvars):
- resource_group_name  = "tf-multi-qa-denver-rg"
- virtual_network_name = "tf-multi-main-vnet"
- load_balancer_name = "tf-multi-LoadBalancer"
- lb_be_address_pool_name (default is set: "pfmp_pool", no need to set it if you used terraform for infrastructure)

You can also adjust data disks properties and the number of machines.

What will happen?
- new vms will be deployed
- new data disks will be added and attached to vms
- first three vms (tag: if_pfmp = true) will have their ips added to Load balancer backend pool

Check readme under deployments for terraform deployment steps.