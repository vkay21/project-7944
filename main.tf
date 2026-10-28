locals {
  prefix   = "7944"
  location = "eastus2"

  tags = {
    Project        = "CCGC 5502 Terraform Project"
    Name           = "voke.akatugba"
    ExpirationDate = "2027-12-31"
    Environment    = "Learning"
  }
}

module "rgroup" {
  source = "./modules/rgroup-7944"

  resource_group_name = "${local.prefix}-RG"
  location            = local.location
  tags                = local.tags
}

module "network" {
  source = "./modules/network-7944"

  resource_group_name = module.rgroup.resource_group_name
  location            = module.rgroup.location
  prefix              = local.prefix

  vnet_address_space      = ["10.79.0.0/16"]
  subnet_address_prefixes = ["10.79.1.0/24"]
  admin_source_cidr       = "142.112.152.244/32"

  tags = local.tags
}

module "common" {
  source = "./modules/common-7944"

  resource_group_name = module.rgroup.resource_group_name
  location            = module.rgroup.location
  prefix              = local.prefix

  storage_account_name = "7944vokediagsa"
  log_analytics_sku    = "PerGB2018"
  log_retention_days   = 30
  recovery_vault_sku   = "Standard"

  tags = local.tags
}

module "vmlinux" {
  source = "./modules/vmlinux-7944"

  resource_group_name = module.rgroup.resource_group_name
  location            = module.rgroup.location
  prefix              = local.prefix
  subnet_id           = module.network.subnet_id

  vm_size             = "Standard_F1ads_v7"
  admin_username      = "azureuser"
  ssh_public_key_path = "~/.ssh/id_rsa.pub"

  boot_diagnostics_storage_uri = module.common.storage_account_primary_blob_endpoint

  # Provisional Ubuntu substitution for the written CentOS requirement.
  image = {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "24.04.202610210"
  }

  linux_vms = {
    linux1 = {
      zone      = "1"
      dns_label = "voke7944-linux1"
    }
    linux2 = {
      zone      = "2"
      dns_label = "voke7944-linux2"
    }
    linux3 = {
      zone      = "4"
      dns_label = "voke7944-linux3"
    }
  }

  tags = local.tags

  depends_on = [module.network]
}
variable "windows_admin_password" {
  description = "Administrator password for the Windows VMs"
  type        = string
  sensitive   = true
}
module "vmwindows" {
  source = "./modules/vmwindows-7944"

  resource_group_name = module.rgroup.resource_group_name
  location            = module.rgroup.location
  prefix              = local.prefix
  subnet_id           = module.network.subnet_id

  vm_count       = 1
  vm_size        = "Standard_D2s_v7"
  admin_username = "azureadmin"
  admin_password = var.windows_admin_password

  dns_label_prefix = "voke7944-win"

  boot_diagnostics_storage_uri = module.common.storage_account_primary_blob_endpoint

  image = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "20348.5773.261025"
  }

  tags = local.tags

  depends_on = [module.network]
}

module "datadisk" {
  source = "./modules/datadisk-7944"

  resource_group_name = module.rgroup.resource_group_name
  location            = module.rgroup.location
  prefix              = local.prefix

  disk_size_gb         = 10
  storage_account_type = "Standard_LRS"

  virtual_machines = merge(
    {
      for key, id in module.vmlinux.vm_ids :
      key => {
        vm_id = id
        zone  = module.vmlinux.vm_zones[key]
      }
    },
    {
      for index, id in module.vmwindows.vm_ids :
      "win${index + 1}" => {
        vm_id = id
        zone  = null
      }
    }
  )

  tags = local.tags
}
module "loadbalancer" {
  source = "./modules/loadbalancer-7944"

  resource_group_name = module.rgroup.resource_group_name
  location            = module.rgroup.location
  prefix              = local.prefix

  network_interface_ids = module.vmlinux.network_interface_ids
  frontend_port         = 80
  backend_port          = 80

  tags = local.tags
}

variable "postgresql_admin_password" {
  description = "Administrator password for PostgreSQL"
  type        = string
  sensitive   = true
}

module "database" {
  source = "./modules/database-7944"

  resource_group_name = module.rgroup.resource_group_name
  location            = module.rgroup.location

  server_name            = "7944-voke-postgresql"
  administrator_login    = "pgadmin7944"
  administrator_password = var.postgresql_admin_password

  postgresql_version    = "16"
  sku_name              = "GP_Standard_D2s_v3"
  storage_mb            = 32768
  backup_retention_days = 7

  tags = local.tags
}