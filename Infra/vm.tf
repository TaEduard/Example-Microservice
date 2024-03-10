data "azurerm_key_vault_secret" "public_key" {
  name         = "github-ssh-public-key"
  key_vault_id = azurerm_key_vault.Kv1.id
}

resource "azurerm_virtual_machine" "runner_vm" {
  name                  = "github-runner-vm"
  location              = "East US"
  resource_group_name   = azurerm_resource_group.aks_rg.name
  network_interface_ids = [azurerm_network_interface.runner_nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "github-runner"
    admin_username = "adminuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/adminuser/.ssh/authorized_keys"
      key_data = var.enable_ssh_key ? try(data.azurerm_key_vault_secret.public_key[0].value, var.default_ssh_key) : var.default_ssh_key
    }
  }
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_network_interface" "runner_nic" {
  name                = "github-runner-nic"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.aks_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create a public IP address for Azure Bastion
resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "bastion-public-ip"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create Azure Bastion resource
resource "azurerm_bastion_host" "bastion" {
  name                = "github-runner-bastion"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name

  ip_configuration {
    name                 = "github-runner-bastion-ip"
    subnet_id            = azurerm_subnet.aks_bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }
}
