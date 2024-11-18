variable "nsg_rules_vnet" {
  type = list(map(string))
  default = [

    {
      name                   = "PowerFlex_HTTPs_from_inside"
      priority               = 100
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "443"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex_Gateway_8080"
      priority               = 110
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "8080"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex_SSO_internal_pod_listener"
      priority               = 120
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "8083"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex_SDR_listener"
      priority               = 130
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "11088"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex_SDS_listener_Tcp_7072"
      priority               = 140
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "7072"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex_MDM_peer_connection"
      priority               = 150
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "7611"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex_ActiveMQ_1"
      priority               = 160
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "61714"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex_ActiveMQ_2"
      priority               = 170
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "8161"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex_Thin_Deployer"
      priority               = 180
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "9433"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex_SDS_listener_Udp_9098"
      priority               = 200
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Udp"
      source_port_range      = "*"
      destination_port_range = "9098"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex_Gateway_80"
      priority               = 210
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "80"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex"
      priority               = 220
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "28765"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex_SDS_listener_Udp_9099"
      priority               = 230
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Udp"
      source_port_range      = "*"
      destination_port_range = "9099"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex_SDS_listener_Udp_7072"
      priority               = 240
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Udp"
      source_port_range      = "*"
      destination_port_range = "7072"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex_ActiveMQ"
      priority               = 250
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "61613"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex_LIA_listener"
      priority               = 260
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "9099"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex_Gateway_8443"
      priority               = 270
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "8443"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex_AMS_and_MDM_listener"
      priority               = 280
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "6611"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex_MDM_Cluster_member"
      priority               = 290
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "9011"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "Default_mTLS_port_for_MDM"
      priority               = 300
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "8611"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "RKE2_server_and_agent_nodes_Canal_CNI_with_WireGuard_IPv6_dual-stack"
      priority               = 310
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Udp"
      source_port_range      = "*"
      destination_port_range = "51821"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "RKE2_Cilium_CNI_health_checks"
      priority               = 320
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Icmp"
      source_port_range      = "*"
      destination_port_range = "*"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "RKE2_NodePort_port_range"
      priority               = 330
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "30000-32767"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "RKE2_server_and_agent_nodes_Calico_CNI_with_VXLAN"
      priority               = 340
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "4789"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "RKE2_server_and_agent_nodes_kubelet"
      priority               = 350
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "10250"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "RKE2_agent_nodes_Kubernetes_API"
      priority               = 360
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "9345"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "RKE2_docker-registry_Udp"
      priority               = 370
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Udp"
      source_port_range      = "*"
      destination_port_range = "50"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "NodePort_access_from_proxy"
      priority               = 380
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "31550"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "RKE2_Kubernetes_API"
      priority               = 390
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "6443"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "RKE2_cert_manager"
      priority               = 400
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "9402"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "RKE2_server_and_agent_nodes_Canal_CNI_with_WireGuard_IPv4"
      priority               = 410
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Udp"
      source_port_range      = "*"
      destination_port_range = "51820"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "RKE2_docker-registry_Tcp"
      priority               = 420
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "50"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "RKE2_server_and_agent_nodes_Cilium_CNI_VXLAN_required_only_for_Flanner_VXLAN"
      priority               = 430
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Udp"
      source_port_range      = "*"
      destination_port_range = "8472"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "RKE2_server_nodes_etcd_peer_port"
      priority               = 440
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "2380"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "RKE2_server_and_agent_nodes_Calico_CNI_with_BGP"
      priority               = 450
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "179"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "RKE2_server_and_agent_nodes_Calico_Typha_health_checks"
      priority               = 460
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "9098"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "RKE2_server_and_agent_nodes_Calico_Canal_CNI_health_checks"
      priority               = 470
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "9099"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "Allow_ssh_from_installer"
      priority               = 480
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "22"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "Allow_SSH_from_proxy"
      priority               = 490
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "22"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "RKE2_server_and_agent_nodes_Calico_CNI_with_Typha"
      priority               = 500
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "5473"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "RKE2_server_nodes_etcd_client_port"
      priority               = 510
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "2379"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "RKE2_server_and_agent_nodes_Cilium_CNI_health_checks"
      priority               = 520
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "4240"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    { name                   = "RKE2-docker-registry"
      priority               = 530
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "5000"
      # source_address_prefix      = var.vnet_cidr_range
    destination_address_prefix = "*" },
    {
      name                   = "RKE2-docker-registry-udp"
      priority               = 540
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Udp"
      source_port_range      = "*"
      destination_port_range = "5000"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex-Core-SDT-4420udp"
      priority               = 550
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Udp"
      source_port_range      = "*"
      destination_port_range = "4420"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex-Core-SDT-4420tcp"
      priority               = 560
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "4420"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex-Core-SDT-12200tcp"
      priority               = 570
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "12200"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex-Core-SDT-12200udp"
      priority               = 580
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Udp"
      source_port_range      = "*"
      destination_port_range = "12200"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex-Core-SDT-8009tcp"
      priority               = 590
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "8009"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "PowerFlex-Core-SDT-8009udp"
      priority               = 600
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Udp"
      source_port_range      = "*"
      destination_port_range = "8009"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
        {
      name                   = "Allow_SMB_Share_UDP"
      priority               = 610
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Udp"
      source_port_range      = "*"
      destination_port_range = "137-138"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "Allow_SMB_Share_TCP"
      priority               = 620
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "445"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "INTERNAL-ALLOW-RDP-UDP"
      priority               = 700
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Udp"
      source_port_range      = "*"
      destination_port_range = "3389"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    },
    {
      name                   = "INTERNAL-ALLOW-RDP-TCP"
      priority               = 710
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "3389"
      # source_address_prefix      = var.vnet_cidr_range
      destination_address_prefix = "*"
    }
  ]
}

variable "nsg_rules_pods" {
  type = list(map(string))
  default = [
    {
      name                       = "PowerFlex_gw_core_installation_upload_files"
      priority                   = 900
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "10.42.0.0/24"
      destination_address_prefix = "*"
    },
    {
      name                       = "pod_to_pod_connectivity"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.42.0.0/24"
      destination_address_prefix = "*"
    }
  ]
}

variable "nsg_rules_with_fixed_source" {
  type = list(map(string))
  default = [

    {
      name                       = "AllowAzureLoadBalancerInBound"
      priority                   = 2000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
    },
    {
      name                       = "DenyVnetInBound"
      priority                   = 3000
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow-UDP-4789_for-VXLAN"
      priority                   = 1200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "4789"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    }
  ]
}
