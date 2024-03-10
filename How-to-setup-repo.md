# How to setup repo
This file contains the explanation of how to setup the repository.


1. Fork the repository. 
1. Update [this line](./.github/workflows/Terraform-Apply.yml) to `false` 
1. Populate the secrets as explained in the file [How to setup secrets](./How-to-setup-secrets.md)
1. Run the Docker-build-and-push pipeline [link](https://github.com/TaEduard/Example-Microservice/actions/workflows/Docker-build-and-push.yml)
1. Run the IaC pipeline [link](https://github.com/TaEduard/Example-Microservice/actions/workflows/Terraform-Apply.yml)
1. Run the SSH key rotation pipeline [link](https://github.com/TaEduard/Example-Microservice/actions/workflows/Rotate-ssh-key.yml)
1. Update [this line](./.github/workflows/Terraform-Apply.yml) to `true`
1. Run the IaC pipeline [link](https://github.com/TaEduard/Example-Microservice/actions/workflows/Terraform-Apply.yml)
1. Configure the github runner vm [How to configure Github Runner VM](./How-to-configure-githubRunnerVM.md)
1. Run the Kubectl apply pipeline [link](https://github.com/TaEduard/Example-Microservice/actions/workflows/Terraform-Apply.yml)


 