#!/bin/bash
set -euo pipefail

. exports-private.sh

az account set --subscription $AZURE_SUBSCRIPTION_ID

# Generate Azure client id and secret.
export RBAC_JSON="rbac.json"

if test -f "$RBAC_JSON"; then
	RBAC="$(cat $RBAC_JSON)"
else
    RBAC_NAME="--name $AZURE_SERVICE_PRINCIPAL"
    RBAC_ROLE="--role 'Contributor'"
    RBAC_SCOPES="--scopes /subscriptions/${AZURE_SUBSCRIPTION_ID}"
	RBAC="$(az ad sp create-for-rbac $RBAC_NAME $RBAC_ROLE $RBAC_SCOPES)"
	echo $RBAC > $RBAC_JSON
fi

echo $RBAC 

export ARM_TENANT_ID="$(jq -r '.tenant' "rbac.json")"
export ARM_CLIENT_ID="$(jq -r '.appId' "rbac.json")" 
export ARM_CLIENT_SECRET="$(jq -r '.password' "rbac.json")" 

echo "############# INIT: "
terraform init -backend-config=config/dev_backend.tfvars #$TARGETS
echo "############# PLAN: "
terraform plan -var-file=config/dev.tfvars #$TARGETS
echo "############# APPLY: "
terraform apply -auto-approve -var-file=config/dev.tfvars #$TARGETS

# ###########################################################################
# #### Configure AKS connection in local env 
# ###########################################################################
echo "############# OUTPUT: "
# terraform output configure
# terraform output kube_config > ~/.kube/aksconfig
az aks get-credentials --resource-group $AZURE_RESOURCE_GROUP --name $AZURE_AKS_CLUSTER_NAME || true
# export KUBECONFIG=~/.kube/aksconfig
kubectl get nodes
#export nrfhealthpod=`kubectl get pods -n 5gc-nrf-ns --no-headers -o custom-columns=":metadata.name" | grep nrfhealth`
#kubectl exec --namespace 5gc-nrf-ns $nrfhealthpod -- sh -c "robot nrfhealth.robot"

# ###########################################################################
# #### Connect to AKS
# ###########################################################################

az aks get-credentials --resource-group $AZURE_RESOURCE_GROUP --name $AZURE_AKS_CLUSTER_NAME || true

#az aks get-credentials --resource-group rg-nrf000-amdocslabs-aks --name aks-nrf000-amdocslabs || true