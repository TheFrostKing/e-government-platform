# What is G4gov?
It is a case study project for university. It is a whole semester's project and the aim of it is students to gain relevant skills and knowledge about cloud technology (mostly AWS, but not limited to) and apply their knowledge directly in the cloud platform. Different subjects cover main key areas such as Monitoring and Security,  Automation and Orchestration, Security and Network Orchestration. We work in groups of 3 and the name comes from the idea of our use case scenario - an e-government platform. Our goal is to build a secure and monitored environment, built with latest concepts and best practices, that is able to host an institutional level of platform application. 

## Main points we follow
1. Secure architecture by design<br>
2. Application is highly available and secure through Route 53
3. Application is scalable and can revert to previous versions - ECS is used
4. CI/CD integrated with Jenkins
5. Automation and deployment strategy

## ==Resources in this repo==
### Application
ReactJS + Flask boilerplate application, that is used to show the CI/CD integration with Jenkins. 
The application is configured to work with AWS PostgreSQL and needs to be tweaked if it's being reused. That is easy to happen since I use the very popular library SQLAlchemy and one can find the `config.py` and `.env` in the `./backend` folder.
***
### Jenkins
![image](https://user-images.githubusercontent.com/37861327/212493108-801e629b-8819-4aaa-85b2-742a14d22d34.png)
