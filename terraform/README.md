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
│       └── lambda
│           ├── dinnercaster2-get-dinner
│           │   └── lambda_function.py
│           ├── dinnercaster2-get-dinnerlist
│           │   └── lambda_function.py
│           ├── dinnercaster2-init-dynamodb
│           │   └── lambda_function.py
│           └── main.tf
├── secret.tfvars
├── secret.tfvars.example
├── terraform.tfstate
├── terraform.tfstate.backup
└── variables.tf

terraform plan -var-file="secret.tfvars"
```
