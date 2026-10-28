terraform {
  backend "azurerm" {
    resource_group_name  = "7944-tfstate-RG"
    storage_account_name = "7944tfstatesa"
    container_name       = "tfstatefiles"
    key                  = "project-7944.tfstate"

    use_azuread_auth = true
    use_cli          = true
  }
}