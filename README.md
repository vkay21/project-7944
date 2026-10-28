# CCGC 5502 Terraform Project

**Student Name:       **Voke Akatugba  
**Resource prefix:    **7944  
**Deployment region:  **East US 2

## Overview

This project provisions Azure infrastructure using Terraform and eight child
modules:

- Resource group
- Virtual network, subnet, and network security group
- Log Analytics workspace, Recovery Services vault, and diagnostics storage
- Three Linux VMs using for_each
- One Windows Server 2022 VM using count
- Four 10 GB data disks and their attachments
- Public Standard Load Balancer
- PostgreSQL Flexible Server

Terraform state is stored separately in Azure Blob Storage in Canada Central.

## Main configuration

- Linux: Ubuntu 24.04 LTS, Standard_F1ads_v7, zones 1, 2, and 4
- Windows: Windows Server 2022, Standard_D2s_v7, availability set
- Database: PostgreSQL 16, GP_Standard_D2s_v3, 32 GB storage, zone 3
- Storage: Standard LRS
- Web server: Nginx, installed automatically on the Linux VMs
- SSH provisioner: prints each Linux hostname and checks its local web page

## Required tags

| Tag | Value |
|---|---|
| Project | CCGC 5502 Terraform Project |
| Name | voke.akatugba |
| ExpirationDate | 2027-12-31 |
| Environment | Learning |

Tags are passed to resources that support them. The expiration tag does not
automatically delete resources.

## Prerequisites

- Terraform and Azure CLI
- An Azure subscription with suitable permissions, quota, and SKU access
- Existing backend storage and container matching backend.tf
- Storage Blob Data Contributor access to the backend container
- SSH key pair, with the private key loaded into the SSH agent

Review resource names, image versions, region, zones, and SKU availability
before deploying. Update admin_source_cidr in main.tf to your current public
IPv4 address followed by /32.

## Authentication

Sign in and select the intended subscription:

```bash
az login
export ARM_SUBSCRIPTION_ID="$(az account show --query id --output tsv)"
ssh-add ~/.ssh/id_rsa
```

Set passwords privately in a macOS zsh terminal:

```bash
read -s "TF_VAR_windows_admin_password?Windows administrator password: "
export TF_VAR_windows_admin_password

read -s "TF_VAR_postgresql_admin_password?PostgreSQL administrator password: "
export TF_VAR_postgresql_admin_password
```

These environment variables must be available in the terminal running
Terraform. Never commit passwords or private keys. Sensitive values can be
stored in Terraform state and saved plans, so protect both.

## Deployment

```bash
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
terraform apply --auto-approve
```

## Verification

```bash
terraform state list | nl
terraform output
terraform plan
curl --fail --max-time 15 "$(terraform output -raw web_url)"
```

The current configuration contains 48 Terraform-managed resource instances,
including three null_resource instances for provisioners.

After deployment, the plan should report no changes. The load balancer page
should display a Linux VM hostname.

## Assignment adjustments and limitations

- East US 2 was selected after checking subscription SKU access and quotas.
- Ubuntu 24.04 LTS is a provisional substitution following the architecture
  diagram. The checked CentOS 8.2 image was Generation 1, while the available
  candidate VM sizes required Generation 2. Instructor acceptance remains
  to be confirmed.
- Linux VMs use separate availability zones following the detailed
  instructions. The rubric instead mentions an availability set;
  instructor clarification remains outstanding.
- Standard Load Balancer replaces the retired Basic SKU and matches the
  architecture diagram.
- The Recovery Services vault is named rsv-7944 because its name must begin
  with a letter.
- PostgreSQL B1ms and B2s deployment attempts returned SkuNotAvailable.
  GP_Standard_D2s_v3 deployed successfully.
- PostgreSQL public network access is disabled. Private connectivity is
  not configured, so application SQL connectivity is not demonstrated.
- Azure Monitor agents and a Log Analytics workspace are provisioned,
  but data collection rules and associations are not configured.
- A Recovery Services vault is provisioned; VM backup policies and
  protected instances are not configured.
- Data disks are attached but not formatted or mounted inside the VMs.

The initial deployment required troubleshooting and recovery applies.
A clean, non-interactive rebuild must still be demonstrated for assessment.

## Cleanup

After evaluation, remove the project infrastructure to stop ongoing charges:

```bash
terraform plan -destroy
terraform destroy --auto-approve
```

