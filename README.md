# azure-aks
Azure AKS - Deploy with terraform

Estimated time to deploy: 5 minutes

Run this commands with terraform

1. Authentication of the Azure Tenant

```bash
az login --tenant xxx
```

2. Run Terraform Plan

```bash
terraform plan -out main.tfplan
```

3. Apply the deploy

```bash
terraform apply main.tfplan
```

Get the Kubernetes configuration from the Terraform state and store it in a file that kubectl can read using the following command.

```bash
echo "$(terraform output kube_config)" > ./azurek8s
```

Set an environment variable so kubectl can pick up the correct config using the following command.

```bash
export KUBECONFIG=./azurek8s
```

Destroy resources

```bash
terraform plan -destroy -out main.destroy.tfplan
terraform apply main.destroy.tfplan
```

Reference: https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-terraform?pivots=development-environment-azure-cli
