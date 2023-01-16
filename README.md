# What is G4gov?
It is a case study project for university. It is a whole semester's project and the aim of it is students to gain relevant skills and knowledge about cloud technology (mostly AWS, but not limited to) and apply their knowledge directly in the cloud platform. Different subjects cover main key areas such as Monitoring and Security,  Automation and Orchestration, Security and Network Orchestration. We work in groups of 3 and the name comes from the idea of our use case scenario - an e-government platform. Our goal is to build a secure and monitored environment, built with latest concepts and best practices, that is able to host an institutional level of platform application. 

## Main points we follow
1. Secure architecture by design<br>
2. Application is highly available and secure through Route 53
3. Application is scalable and can revert to previous versions - ECS is used
4. CI/CD integrated with Jenkins
5. Automation and deployment strategy

# ==Resources in this repo==

## Terraform
We have implemented Terraform for provision and deployment of our pieces of infrastructure
See the terraform [Readme](https://github.com/TheFrostKing/e-government-platform/tree/main/terraform)
<br>

## Application
ReactJS + Flask boilerplate application, that is used to show the CI/CD integration with Jenkins. 
The application is configured to work with AWS PostgreSQL and needs to be tweaked if it's being reused. That is easy to happen since I use the very popular library SQLAlchemy and one can find the `config.py` and `.env` in the `./backend` folder.
Sample tests are written with pytest to demonstrate testing stage of the pipeline.
<br>

## Jenkins <br>
Jenkins server is used to manage the code of the e-government application. The pipeline plays a crucial role in providing the main service of the project – the website.
### How it works?
1.	Checkout – the master’s branch is pulled from the configured repo in the working directory of the Jenkins instane<br>
2. Pre-clean stage is there to make sure there are not previous files that can interrupt the pipeline.
3.	Tests – creates local tests (currently with pytest and flake8), but can be adapted to everything.
4.	Building stage – dockerizes both the frontend and the backend
5.	Push to ECR stage – finds already created private repositories (names of these repos need be specified in the env variables in the Jenkinsfile) and pushes the images
6.	Deploy to ECS stage – first it updates existing task definitions (task-definition names need be specified in the Jenkinsfile) with the new iterations of the application. After the update of the task definitions, existing ECS services are updated with the latest version of the respective task definition. (Again ECS services must already exist and are specified in the Jenkinsfile)
7.	Publish to S3 – zip artifacts from build and send them to S3. (the name of the existing s3 bucket should be specified)
   
 - There are helper scripts in the `./scripts` folder that make sure ECS task definitions are updated and one for pulling out the secret from the secret        manager of the RDS [secret.py](https://github.com/TheFrostKing/e-government-platform/blob/main/scripts/secret.py).
 - ### Jenkins process diagram
    # <picture>![image](https://user-images.githubusercontent.com/37861327/212493108-801e629b-8819-4aaa-85b2-742a14d22d34.png)</picture>

 - ### Overview of the stages
    # <picture><br>![jenkins image](https://user-images.githubusercontent.com/37861327/212673262-d91e9c79-e8f0-4d01-ae6b-3833a2786321.jpeg)</picture>

***
## <p align="center"> Website Screenshots </p>
### <p align="center"> Login page. </p>
![website](https://user-images.githubusercontent.com/37861327/212670652-9b68b40a-18a3-4855-8c71-81710cd06299.png)
***
### <p align="center"> Cookie sessions and stickiness from the Load Balancer.</p>
![image](https://user-images.githubusercontent.com/37861327/212671015-d71e066b-ca95-4742-b879-719926798525.png)
***
### <p align="center"> Succsessful communication between the frontend and backend and the RDS.</p>
![image](https://user-images.githubusercontent.com/37861327/212673968-63892681-c612-4d34-b18e-0e94698e3f6d.png)

