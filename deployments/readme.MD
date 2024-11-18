Specification: https://confluence.gtie.dell.com/display/OHCI/PowerFlex+infrastructure+provisioning+automation+on+Azure

### DEPLOYMENT OPTIONS IN REPO ###
Deploy full intrastructure from scratch:
- co-res 
- local-nvme

Deploy just cluster nodes (add to existing infra- vnet, nsg,lb, nat gw...)
- local-nvme-small-deployment
- small-deployment

Add only managed disks to existing machines
- disks-only




## Manually prepare key pair inside ssh-keys if needed (otherwise default key will be used)
>cd ssh-keys  
>ssh-keygen -m PEM -t rsa -b 4096 -C "azureuser@myserver.pem" -f terraform-azure  
>chmod 400 terraform-azure  

Update vars in selected deployment directory to point to new public key file, e.g.:
> public_key_path = { installer : "../../ssh-keys/terraform-azure.pem.pub" }


## To deploy infrastructure

1. Export authentication variables

export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000" #service principal appId  
export ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000" # service principal password  
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"  
export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"  

2. Adjust vars in terraform.tvars
>cd deployments\co-res
>
Edit terraform.tfvars
 
3. Run Terraform
You can use workspaces to separate environments managed by the same Terraform states. It's not necessary.
>cd deployments\co-res
>
> terraform init 
>
>terraform workspace new workspace1
> 
> terraform plan -out tfplan.tfplan
> 
> terraform apply tfplan.tfplan

4. Post terraform steps
Update disk tier (run script from the same tf directory as "apply"). You can also execute this step manually in Azure (vm/Disks/os-disk/size and performance/disk tier). It's currently impossible to manage this with Terraform.
> ./../resources/scripts/update_os_disk_tier.sh
