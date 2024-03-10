# How to setup secrets

List of secrets required by the repository for the github actions:

1. `CR_PAT` - Github PAT with permissions to push packages
1. `ARM_CLIENT_ID` - SPN client Id
1. `ARM_CLIENT_SECRET` - SPN client secret
1. `ARM_SUBSCRIPTION_ID` - SPN subscription id
1. `ARM_TENANT_ID` - SPN tennant id

## Easy way to create the SPN 
```
ad sp create-for-rbac --name TerraformSPN --role Contributor --scopes /subscriptions/<Your-SUB> --sdk-auth
```

## Easy way to create the storage account
Replace `<Your-Region>` with one of the regions available. 
To find the regions available run the command below:
```az account list-locations -o table``` 

```
az group create --name TFState --location <Your-Region>
az storage account create --name mystorerraform --resource-group TFState --location <Your-Region> --sku Standard_LRS --encryption-services blob
az storage container create --name terraformstate --account-name mystorerraform
```
