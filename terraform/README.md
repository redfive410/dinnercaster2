## README

```
$ tree terraform/
terraform/
├── README.md
├── main.tf
├── modules
│   └── iam
│       └── main.tf
├── secret.tfvars
├── secret.tfvars.example
├── terraform.tfstate
├── terraform.tfstate.backup
└── variables.tf

terraform plan -var-file="secret.tfvars"
```
