# Powerflex AWS automation
This project will deploy APEX Block Storage (aka. PowerFlex) in AWS using Terraform based infrastructure as code and some manual steps that are required post deployment. 
This was tested using a RHEL 8 Linux server and may require small tweaks to the code depending on which OS you are using to run the Terraform deployment.

# YouTube Video
https://www.youtube.com/watch?v=glse3bcyPes

## Step 1: Pre-reqs

### Install Terraform
- https://developer.hashicorp.com/terraform/downloads
* e.g. RHEL
```
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform
```

### Install AWS CLI
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

### Configure AWS creds
```
aws configure
```
provide access key ID and secret access key
enter default region name (e.g. eu-west-1)
enter default output format (e.g. json)

### Clone the repo
```
git clone https://github.com/theocrithary/Terraform-PowerFlex-4.5-on-AWS.git
```

### Navigate to the working directory
```
cd Terraform-PowerFlex-4.5-on-AWS/provision/deployments/vpn-mode
```

### Rename the vars.tf.example file to vars.tf
```
mv vars-example-tf vars.tf
```

### Edit the vars.tf file and replace any variables with your own environment variables
```
vi vars.tf
```

## Step 2: Run the Terraform deployment

### terraform init
```
terraform init
```

### terraform validate & plan
```
terraform validate && terraform plan
```

### terraform apply
```
terraform apply -auto-approve
```

### Confirm the deployment completed successfully, with no errors




Resource Group: powerflexazure
Virtual Network: ashci-vnet01
Subnet: ashci_test
Network Security Group: powerflex-nsg
SSH_Keys: theo-crithary-keypair

SDC Client: apex-block-postgresql-theocrithary
OS: Ubuntu 22.04
AZ: Zone 1
Size: Standard_B2s
SSH: theo-crithary-keypair
OS Disk: default 30GB
Public IP: none
NIC security: none
Guest OS updates: image default


deploy 6x co-res nodes with the following;
- instance type: Standard_F48s_v2
- OS disk: 512GB Premium SSD LRS
- Additional disks:
    - apex-block-co-res-1-theocrithary_DataDisk_1 (Premium SSD v2, 500GB)
    - apex-block-co-res-1-theocrithary_DataDisk_2 (Premium SSD v2, 500GB)
    - apex-block-co-res-1-theocrithary_DataDisk_3 (Premium SSD v2, 500GB)



# Create the load balancer
A load balancer is the single point of contact for clients. When a network load balancer is used, the default listener accepts TCP requests and distributes them to the instances in your environment.
Steps
1. In the search box, enter Load balancer, and press Enter.
2. Click Create and enter the following details in Basic > Project details:
● Subscription: Select your subscription details.
● Resource group: Select the resource group that you created.
3. Under Instance details enter the following:
● Name: Enter the name of the load balancer.
● Region: Select the same region where the resource group and VNet are located.
● SKU: Select Standard.
● Type: Select Internal.
● Tier: Select Regional.
4. Click Next: Frontend IP Configurations and enter the following details:
● Click Add a Frontend IP Configuration.
● Name: Enter the name of the frontend IP address configuration.
● Virtual network: Select your virtual network.
● Subnet: Select your subnet.
● Assignment: Select Static.
● Address: Assign a free address in a default subnet.
● Availability zone: Keep the default setting Zone: redundant.
5. Click Next: Backend Pool and enter the following details:
● Click Add Backend Pool.
● Name: Enter the name of the backend pool.
● Virutal network: Keep the default setting.
● Backend Pool Configuration: Select the NIC s of the machines that will have the PowerFlex management platform installed.
6. Under IP configurations, click Add and enter the following details:
● Select the list of VMs that are part of the load balancer.
● Click Add, and click Save.
7. Click Next: Inbound rules and enter the following details:
● Click Add a load balancing rule.
● Name: Enter the name of the rule.
● IP Version: Select IPv4 .
● Frontend IP address: Select your load balancer IP address.
● Backend Pool: Select your backend pool.
● High availability port: Keep the default setting.
● Protocol: Select TCP.
● Port: 443.
● Backend port: 30400.
● Health probe: Click Create new and enter the following details:
    a. Name: Enter the name.
    b. Protocol: TCP.
    c. Port: 30400.
    d. Interval: 5 seconds.
    e. Click Save.
● Session persistence: None.
● Idle timeout: 4.
● Enable TCP Reset: Keep the default setting.
● Enable Floating IP: Keep the default setting.
● Click Save.
8. Click Next: Outbound rules: Keep the default setting and optionally click Next: Tags.


create a DNS entry for the load balancer IP if desired (optional)


## Step 3: Prepare all nodes with keys, root passwords and other required packages

### Copy the SSH keys and SSH to the installer instance
- Retrieve the IP address of the deployed installer instance by logging into the AWS console
- Copy the SSH key to the installer instance by using the ec2-user and key generated by the Terraform scripts
- SSH to the installer instance
```
cd ../../../keys/
scp -i "theo-crithary-keypair.pem" theo-crithary-keypair.pem azureuser@10.0.1.7:/home/azureuser/
ssh -i "theo-crithary-keypair.pem" azureuser@10.0.1.7
```

### Copy the SSH key to all storage nodes
```
chmod 400 powerflex-denver-key
cp powerflex-denver-key .ssh/id_rsa
```
- Retrieve the IP addresses of all co-res storage nodes from the AWS console
- Copy the SSH key to each co-res storage node
```
scp .ssh/id_rsa azureuser@10.0.1.4:.ssh/id_rsa
scp .ssh/id_rsa azureuser@10.0.1.17:.ssh/id_rsa
scp .ssh/id_rsa azureuser@10.0.1.9:.ssh/id_rsa
scp .ssh/id_rsa azureuser@10.0.1.13:.ssh/id_rsa
scp .ssh/id_rsa azureuser@10.0.1.14:.ssh/id_rsa
scp .ssh/id_rsa azureuser@10.0.1.16:.ssh/id_rsa
```

### Install Kubectl CLI tool (PFMP nodes only), enable root login and disable firewall on each co-res node
```
ssh 10.0.1.4
curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
sudo sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl mask --now firewalld
sudo passwd root
sudo reboot

ssh 10.0.1.17
curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
sudo sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl mask --now firewalld
sudo passwd root
sudo reboot

ssh 10.0.1.9
curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
sudo sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl mask --now firewalld
sudo passwd root
sudo reboot

ssh 10.0.1.13
sudo sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl mask --now firewalld
sudo passwd root
sudo reboot

ssh 10.0.1.14
sudo sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl mask --now firewalld
sudo passwd root
sudo reboot

ssh 10.0.1.16
sudo sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl mask --now firewalld
sudo passwd root
sudo reboot

```

## Step 4: Prepare to run the PFMP installer

### Prepare the JSON file for installer setup
- Retrieve the DNS of the load balancer from the AWS console
e.g. theocrithary-20240528T001402-01e5e64bde6920f2.elb.eu-west-1.amazonaws.com
- Retrieve one of the IP's by resolving the DNS name
```
dig +short theocrithary-20240528T001402-01e5e64bde6920f2.elb.eu-west-1.amazonaws.com | head -1
```
- Prepare the JSON file as per below and replace the "Nodes" hostname and IP with the co-res instances 1-3
```
{
    "Nodes":
    [
      {
        "hostname": "apex-block-co-res-1-theocrithary.internal.cloudapp.net",
        "ipaddress": "10.0.1.4"
      },
      {
        "hostname": "apex-block-co-res-2-theocrithary.internal.cloudapp.net",
        "ipaddress": "10.0.1.17"
      },
      {
        "hostname": "apex-block-co-res-3-theocrithary.internal.cloudapp.net",
        "ipaddress": "10.0.1.9"
      }
    ],
 
    "ClusterReservedIPPoolCIDR" : "10.42.0.0/23",
 
    "ServiceReservedIPPoolCIDR" : "10.43.0.0/23",
 
    "RoutableIPPoolCIDR" : [
	  {
	    "mgmt":"10.240.126.0/25"
	  }
    ],
    
    "PFMPHostname" : "10.0.1.18",
  
    "PFMPHostIP" : "10.0.1.18"
}
```

### Run the installer setup and install scripts
- Edit the JSON file and replace with the pre-prepared JSON file as per above
```
sudo vi /tmp/bundle/PFMP_Installer/config/PFMP_Config.json
```
- Run the setup script
```
sudo /tmp/bundle/PFMP_Installer/scripts/setup_installer.sh
```
- Copy the SSH key to the installer inventory directory
```
sudo cp ~/.ssh/id_rsa /tmp/bundle/atlantic/inventory/
```
- Run the installer script
```
sudo /tmp/bundle/PFMP_Installer/scripts/install_PFMP.sh azure
```
- Answer the prompts as follows;
```
Are ssh keys used for authentication connecting to the cluster nodes[Y]?:y
Please enter the ssh username for the nodes specified in the PFMP_Config.json[root]:azureuser
Are ssh keys the same for all the cluster nodes[Y]?:y
Please enter the location of the ssh key for the nodes specified in the PFMP_Config.json[id_rsa]:id_rsa
Are the nodes used for the PFMP cluster, co-res nodes [Y]?:y
```


### Open another SSH session on the installer server and watch the logs
```
ssh -i "theo-crithary-keypair.pem" azureuser@10.0.1.7
tail -f /tmp/bundle/atlantic/logs/bedrock.log
```

### Delete the installer VM

- Once the above script has completed and confirmed via the logs, you can then power off and delete the PFMP installer instance through the AWS console.

## Step 5: Login to PowerFlex Manager to complete setup

- Use a browser to open the PowerFlex Manager console; https://10.0.1.18

- Login with the default user account
```
admin / Admin123!
```

- Change the password when prompted

- Step through the Initial Config Wizard and select "I want to deploy a new instance of PowerFlex"

- Upload the compliance bundle (e.g. https://pflex-packages.s3.eu-west-1.amazonaws.com/pflex-45/Software_Only_Complete_4.5.1_234/PowerFlex_Software_4.5.1.0_103_r1.zip) 
      - requires a CIFs/SMB file share to host the file or a web server such as AWS S3 with a public URL

- Upload the compatibility management version file (e.g. https://pflex-packages.s3.eu-west-1.amazonaws.com/pflex-45/Software_Only_Complete_4.5.1_234/cm-20231011.gpg)
     - Settings -> compatibility management -> upload file

- Go back to the installation configuration wizard page by navigating to the ? in the top right and clicking on 'getting started'

- Configure the networks
```
      - Define networks -> Define
      - Name: powerflex-azure
      - Network Type: General Purpose LAN
      - VLAN ID: 1
      - Subnet: 10.0.1.0
      - Subnet Mask: 255.255.255.0
      - Gateway: blank
      - Primary DNS: blank
      - Secondary DNS: blank
      - DNS Suffix: blank
      - IP Address Range
      - Role: Server or Client
      - Starting IP: 10.0.1.4
      - Ending IP: 10.0.1.4
      - Starting IP: 10.0.1.17
      - Ending IP: 10.0.1.17
      - Starting IP: 10.0.1.9
      - Ending IP: 10.0.1.9
      - Starting IP: 10.0.1.13
      - Ending IP: 10.0.1.13
      - Starting IP: 10.0.1.14
      - Ending IP: 10.0.1.14
      - Starting IP: 10.0.1.16
      - Ending IP: 10.0.1.16
```

## Step 6: Install PowerFlex software on SDS storage nodes
- Prepare a CSV file with the correct root password, IP's of all nodes and verify the storage devices to be used
- Copy the required software from the "Complete Software" download bundle obtained from the Dell support site
- Be sure to copy the rpm's that match your instance OS version (e.g. PowerFlex_4.5.2000.135_Complete_Core_SW\PowerFlex_4.5.2000.135_SLES15.4.zip matches SLES 15.4)
- Copy the following packages;
```
- EMC-ScaleIO-activemq-5.xx.xxxx.noarch.rpm
- EMC-ScaleIO-mdm-4.5xx.xxx.sles15.4.x86_64.rpm
- EMC-ScaleIO-sds-4.5xx.xxx.sles15.4.x86_64.rpm
- EMC-ScaleIO-sdt-4.5xx.xxx.sles15.4.x86_64.rpm
- EMC-ScaleIO-lia-4.5xx.xxx.sles15.4.x86_64.rpm
- EMC-ScaleIO-sdr-4.5xx.xxx.sles15.4.x86_64.rpm
```
- Return to the PowerFlex Manager UI
- Go to the 'installation configuration wizard' page by navigating to the ? in the top right and clicking on 'getting started'
- Click 'Deploy With Installation File'
- Click 'Browse' and upload your RPM packages as prepared earlier
- After clicking 'Next', you will be at the CSV section
- Click 'Browse' and upload the CSV prepared earlier
- Click 'I accept the terms of the End User License Agreement (mandatory)'
- Click 'Next' and 'Go to Events Page' to track the installation progress
- Confirm the system is deployed successfully by navigating through each of the PowerFlex components and confirming their health status
- There may be an error with the storage pool spare capacity being less than the configured fault set. To resolve this error, change the default setting of the storage pool spare capacity from 35 to 50%


## Step 7: Install the SDC client on a Linux host

### RHEL
- Obtain the following files from the complete SW package and transfer to Linux host
```
- EMC-ScaleIO-sdc-4.5-1000.103.el8.x86_64.rpm
```
- Install the SDC package
```
sudo MDM_IP=10.0.1.13 rpm -ivh EMC-ScaleIO-sdc*.rpm
```
- Check if the driver is running
```
sudo systemctl status scini
```
- Check that the MDM has been configured correctly
```
sudo /opt/emc/scaleio/sdc/bin/drv_cfg --query_mdms
```
- Check if there are any existing volumes mapped to this host
```
sudo /opt/emc/scaleio/sdc/bin/drv_cfg --query_vols
```

## Step 8: Create a volume and map it to the SDC client
- Login to PowerFlex Manager console
- Navigate to the 'Block' storage tab and select 'Hosts'
- Observe the newly added SDC client host IP
- Navigate to the 'Block' tab and select 'Volumes'
- Click '+ Create Volume'
- Provide a name, size and select a storage pool, then click create
- After the volume is created, click 'map' when you see the popup in the bottom left corner of the console
- Select the SDC client from the host list and click 'map'

## Step 9: Test the volume
- SSH back into the SDC client and change to root
- Scan for any new volumes
```
sudo /opt/emc/scaleio/sdc/bin/drv_cfg --rescan
```
- Confirm the volume was connected
```
sudo /opt/emc/scaleio/sdc/bin/drv_cfg --query_vols
```
- Check the new block device and take note of the device name (e.g. scinia)
```
sudo lsblk -f
```
- Format the device with a filesystem (e.g. EXT4)
```
sudo mkfs -t ext4 /dev/scinia
```
- Create a new directory to mount the device
```
sudo mkdir /data0
```
- Mount the device to the new directory
```
sudo mount /dev/scinia /data0
```
- Change to the path and create a test file to confirm read/write access to the volume
```
cd /data0
sudo touch testfile
```