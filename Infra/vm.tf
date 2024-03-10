data "azurerm_key_vault_secret" "public_key" {
  name         = "github-ssh-public-key" # The name used when storing the public key in the Key Vault
  key_vault_id = azurerm_key_vault.Kv1.id
}
data "azurerm_key_vault_secret" "private_key" {
  name         = "github-ssh-private-key" # The name used when storing the public key in the Key Vault
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
      key_data = data.azurerm_key_vault_secret.public_key.value
    }
  }
}

resource "azurerm_network_interface" "runner_nic" {
  name                = "github-runner-nic"
  location            = "East US"
  resource_group_name = azurerm_resource_group.aks_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.aks_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "null_resource" "setup_github_runner" {
  depends_on = [azurerm_virtual_machine.runner_vm]

  triggers = {
    vm_id = azurerm_virtual_machine.runner_vm.id
  }

  connection {
    type        = "ssh"
    host        = azurerm_network_interface.runner_nic.private_ip_address
    user        = "adminuser"
    private_key = data.azurerm_key_vault_secret.private_key.value
  }

  provisioner "remote-exec" {
    inline = [
      "curl -o actions-runner-linux-x64-2.284.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.284.0/actions-runner-linux-x64-2.284.0.tar.gz",
      "tar xzf ./actions-runner-linux-x64-2.284.0.tar.gz",
      "cd actions-runner",
      "export GITHUB_RUNNER_TOKEN='${var.github_runner_token}'&& export GITHUB_URL='${var.github_repo_url}' && ./config.sh --url $GITHUB_URL --token $GITHUB_RUNNER_TOKEN",
      "./svc.sh install",
      "./svc.sh start",
    ]
  }
}
