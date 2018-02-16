## README

```
$ tree terraform/
terraform/
├── README.md
├── main.tf
├── modules
│   ├── alexa
│   │   └── README.md
│   └── api
│       ├── dynamodb
│       │   └── main.tf
│       ├── iam
│       │   └── main.tf
│       └── lambda
│           └── main.tf
├── secret.tfvars
├── secret.tfvars.example
├── terraform.tfstate
├── terraform.tfstate.backup
└── variables.tf

terraform plan -var-file="secret.tfvars"
```
