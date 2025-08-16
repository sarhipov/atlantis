## Assymptions, Notes
### For simplicity (considered out of scope)
  * GitHub secrets stored in AWS Parameter store as `/atlantis/github_user`, `/atlantis/github_token`, `/atlantis/github_secret`, `/atlantis/github_hostname`. NOTE, that `/atlantis/github_token` is stored in terraform.tfvars.local file (not committed to git). 
  * EKS cluster api-server have public access
  * Security Groups allowing access to/from 0.0.0.0/0

### Other things:
* Atlantis granted minimum permissions (via worker IAM role) to execute `terraform plan && terraform apply`. I did test both just with ec2 state.
* Atlantis deployed with `default` values, except the ones changed in helm(check `eks_config` state).
* `remote-state` state creates 'terraform state S3 bucket' and should be executed first and has local state only
* EKS users(admin and read-only) are dummy, with no permissions/policies attached
* States are 'logically' separated (vs one state deploying everything with single 'terraform apply')
* DNS  zone/records, TLS certificate for ELB considered to be optional, and done as separate stand-alone state(`https`). Atlantis can be accessed via ALB or via NodePort


## Terraform
### 0. Login to AWS cli 
Use Your AWS credentials (sso, etc ) to authenticate to Your AWS account

### 1. Create a state bucket
* apply `remote-state` state to create terraform state S3 bucket
```bash
cd environments/devops/remote-state
terraform init 
terraform apply
```

### 2. Configure a repository and store credentials
   
* Set up Git Host access credentials following official guide: https://www.runatlantis.io/docs/access-credentials.html
Copy token, that will be used in next step as  `github_token`

### 3. Store credentials

* set value of the below variable that received in a previous step
```  
 "atlantis/github_token" = {
    value = "YOUR_TOKEN_HERE"
    type  = "SecureString"
  }
```
* apply `parameters` state to create secrets. 
```bash
cd environments/devops/parameters
terraform init 
terraform apply
```

### 4. Create network
* apply `network` state to create VPC and subnetworks 
```bash
cd environments/devops/network/vpc
terraform init
terraform apply
```

### 5. Create and configure EKS cluster 
* apply `eks` and `eks_config` state to create eks cluster, install addons and applications
```bash
cd environments/devops/eks
terraform init
terraform apply

cd environments/devops/eks_config
terraform init
terraform apply
```
