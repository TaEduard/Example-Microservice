# GitHub Actions Workflows

This repository uses GitHub Actions for continuous integration and continuous delivery (CI/CD) processes. Below is an overview of the workflows included in this repository and their purposes.

## Workflows


### Docker: build and push

- **File:** `./Build-And-Push-Imgs.yml`
- **Description:** This workflow builds Docker images for the project and pushes them to a Docker registry. It is triggered when a change is merged for paths: `'service_a/**'`, `'service_b/**'`
- **Requred Secrets:** 
1. `CR_PAT` - Github PAT with permissions to push packages


### Terraform: Apply

- **File:** `./Build-Infra.yml`
- **Description:** This workflow applies the terraform infrastructure.
- **Requred Secrets:** 
1. `ARM_CLIENT_ID` - SPN client Id
1. `ARM_CLIENT_SECRET` - SPN client secret
1. `ARM_SUBSCRIPTION_ID` - SPN subscription id
1. `ARM_TENANT_ID` - SPN tennant id



### Generate and Push SSH Key to Azure Key Vault
- **File:** `./Rotate-ssh-key.yml`
- **Description:** This workflow rotates the ssh key created for the runner vm.
- **Requred Secrets:** 
1. `ARM_CLIENT_ID` - SPN client Id
1. `ARM_CLIENT_SECRET` - SPN client secret
1. `ARM_SUBSCRIPTION_ID` - SPN subscription id
1. `ARM_TENANT_ID` - SPN tennant id


### Kubectl: Apply
- **File:** `./Configure-kubernetes.yml`
- **Description:** This workflow rotates the ssh key created for the runner vm. 
- **Requred Secrets:** 
1. `ARM_CLIENT_ID` - SPN client Id
1. `ARM_CLIENT_SECRET` - SPN client secret
1. `ARM_SUBSCRIPTION_ID` - SPN subscription id
1. `ARM_TENANT_ID` - SPN tennant id






## Usage

To trigger a workflow manually, navigate to the "Actions" tab in the GitHub repository, select the workflow you want to run, and click "Run workflow".

For more details on each workflow, please refer to the comments within the workflow files themselves.


## Contributing

If you wish to add a new workflow or modify an existing one, please follow our contribution guidelines.

## Questions & Support

For questions or support regarding our workflows, please open an issue in this repository.
