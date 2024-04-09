# Using Terraform to build an ARO cluster

Azure Red Hat OpenShift (ARO) is a fully-managed turnkey application platform.

Supports Public ARO clusters and Private ARO clusters.

## Setup

Using the code in the repo will require having the following tools installed:

- The Terraform CLI
- The OC CLI

## Create the ARO cluster and required infrastructure

1. Modify the `terraform.tfvars` var file, you can use the `variables.tf` to see the full list of variables that can be set.

   >NOTE: You can define the subscription_id needed for the Auth using ```export TF_VAR_subscription_id="xxx"``` as well.

2. Deploy the cluster using the `aro_deploy.sh`

## Test Connectivity

1. Get the ARO cluster's api server URL.

   ```bash
   ARO_URL=$(az aro show -n $AZR_CLUSTER -g $AZR_RESOURCE_GROUP -o json | jq -r '.apiserverProfile.url')
   echo $ARO_URL
   ```

2. Get the ARO cluster's Console URL

   ```bash
   CONSOLE_URL=$(az aro show -n $AZR_CLUSTER -g $AZR_RESOURCE_GROUP -o json | jq -r '.consoleProfile.url')
   echo $CONSOLE_URL
   ```

3. Get the ARO cluster's credentials.

   ```bash
   ARO_USERNAME=$(az aro list-credentials -n $AZR_CLUSTER -g $AZR_RESOURCE_GROUP -o json | jq -r '.kubeadminUsername')
   ARO_PASSWORD=$(az aro list-credentials -n $AZR_CLUSTER -g $AZR_RESOURCE_GROUP -o json | jq -r '.kubeadminPassword')
   echo $ARO_PASSWORD
   echo $ARO_USERNAME
   ```

### Public Test Connectivity

1. Log into the cluster using oc login command from the create admin command above. ex.

    ```bash
    oc login $ARO_URL -u $ARO_USERNAME -p $ARO_PASSWORD
    ```

2. Check that you can access the Console by opening the console url in your browser.



# Using Terraform to get Kubeconfig and create a Azure Key Vault Secret

## Get the Kubeconfig, create a Azure Key Vault Secret and deploy the Red Hat Gitops Operator.

1. Modify the `variable.tf` file to your liking.

2. Deploy the `az_key_vault.sh`.  This will run the `az_key_vault` and `gitops_operator`.