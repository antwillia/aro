#! /bin/bash

echo "Pull kubeconfig and add to azure key vault"

cd modules/aro_deploy
terraform init
terraform apply -auto-approve -var cluster_name=aro-atwlab

# cd modules/az_key_vault
# terraform init
# terraform apply -auto-approve 

cd modules/gitops_operator
terraform init
terraform apply -auto-approve 