# About
The terraform script that we have created is specifically designed to automate the deployment of the infrastructure. It enables us to easily provision and configure the necessary resources in a consistent and efficient manner. 
<br>
This is script is modular and one can find the different modules with relevant names and the resources in their respective folders.

## Usage
To be able to deploy the script, create a secrets.tfvars file where you specify your AWS account's access keys. 
Make changes to the variables in terraform.tfvars if needed. 
<br>
After execution the script takes around ~10min to deploy and provision the infrastructure.

## List of items that are automated
1. 1x VPC.
2. Security group for the VPC.
3. Application LoadBalancer that is between two public subnets where the frontend instances of ECS fargate are taking place.
4. Route 53 with publically hosted zones for.
5. 2x ECR repos (backend and frontend).
6. ECS cluster with 2 services for the frontend and the backend + their autoscaling groups and security groups
7. Task definitions from the ECR repos (Note that there must be images inside the repos).
8. 2x Public Subnets in eu-central-1a and 1b for the frontend instances.
9. 2x Private Subnets in eu-central-1b and 1a for the backend instances.
10. Ready to set up Graylog EC2 instance
11. Ready to set up Jenkins Server EC2 instance
12. RDS in a two private AZs (the script asks for a db.password upon execution)
13. Grafana cluster in ECS that is ready for setup.

***
## What is not automated
1. Generation ot SSL certifates and passing them to the ALB
2. Pushing the Docker images to ECR
3. No bastion hosts.

***
Diagram of the infrastructure
![g4gov-final-diagram](https://user-images.githubusercontent.com/37861327/212493217-4bbbe4d6-5ca5-453d-8607-0093ff6dc9cc.png)



In the terminal run the following commands.

```bash
terraform init
terraform plan
terraform apply
```
