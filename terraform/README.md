## README

```
$ tree terraform/
terraform/
├── README.md
├── main.tf
├── modules
│   ├── alexa
│   │   └── lambda
│   │       ├── dinnercaster2-alexa
│   │       │   └── lambda_function.py
│   │       ├── dinnercaster2-alexa.zip
│   │       └── main.tf
│   └── api
│       ├── dynamodb
│       │   └── main.tf
│       └── lambda
│           ├── dinnercaster2-get-dinner
│           │   └── lambda_function.py
│           ├── dinnercaster2-get-dinner.zip
│           ├── dinnercaster2-get-dinnerlist
│           │   └── lambda_function.py
│           ├── dinnercaster2-get-dinnerlist.zip
│           ├── dinnercaster2-init-dynamodb
│           │   └── lambda_function.py
│           ├── dinnercaster2-init-dynamodb.zip
│           └── main.tf
├── secret.tfvars
├── secret.tfvars.example
├── terraform.tfstate
├── terraform.tfstate.backup
└── variables.tf

terraform plan -var-file="secret.tfvars"
terraform apply -var-file="secret.tfvars"
```
