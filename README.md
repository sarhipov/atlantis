## Assymptions, Notes
### For simplicity(considered out of scope)
* GitHub secrets stored manually in AWS Secrets manager under `github-access-credentials` (check `Preparation` store credentials step )
* EKS cluster api-server have public access
* Security Groups allowing access to/from 0.0.0.0/0

### Other things:
* Atlantis granted minimum permissions (via worker IAM role) to execute `terraform plan && terraform apply`. I did test both just with ec2 state.
* Atlantis deployed with `default` values, except the ones changed in helm(check `eks_config` state).
* `remote-state` state creates 'terraform state S3 bucket' and 'terraform state lock DynamoDB table' should be executed first and has local state only
* EKS users(admin and read-only) are dummy, with no permissions/policies attached
* States are 'logically' separated (vs one state deploying everything with singe 'terraform apply')
* DNS  zone/records, TLS certificate for ELB considered to be optional, and done as separate stand-alone state(`https`). Atlantis can be accessed via https://atlantis.topia.engineering or via NodePort


## Preparation
### 1. Configure repository

* Setup Git Host access credentials following official guide: https://www.runatlantis.io/docs/access-credentials.html

### 2. Store credentials

- Create secret with `github-access-credentials` name in Secrets Manager and store access credentials with following content.
  Later those credentials will be used in Terraform
  ```
  user: <VALUE>
  token: <VALUE>
  secret: <VALUE>
  host: <VALUE>
  ```

## Terraform
### 0. Login to AWS cli
Use Your AWS credentials (sso, etc ) to authenticate to Your AWS account

### 2. Create state bucket and state lock
* apply `remote-state` state to create
  - terraform state S3 bucket
  - state lock DynamoDB table
```
cd environments/devops/remote-state
terraform init 
terraform apply
```

### 3. Create network
* apply `network` state to create
  - VPC(s) and VPC route tables
  - subnets and subnets route tables
```
cd environments/devops/network
terraform init
terraform apply
```

### 4. Create and configure EKS cluster
* apply `eks` and `eks_config` to create
  - EKS cluster amd install it's addons
  - cert manager and aws loadbalancer controller
  - atlantis 
```
cd environments/devops/eks
terraform init
terraform apply

cd environments/devops/eks_config
terraform init
terraform apply
```