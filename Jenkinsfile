pipeline{
    agent any

    environment {
        PATH=sh(script:"echo $PATH:/usr/local/bin", returnStdout:true).trim()
        AWS_REGION = "eu-central-1"
        AWS_ACCOUNT_ID=sh(script:'export PATH="$PATH:/usr/local/bin" && aws sts get-caller-identity --query Account --output text', returnStdout:true).trim()
        ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        FRONTEND_REPO = "frontend" 
        BACKEND_REPO = "backend"
        APP_NAME = "myapp"
        HOME_FOLDER = "/home/ec2-user"
        GIT_FOLDER = sh(script:'echo ${GIT_URL} | sed "s/.*\\///;s/.git$//"', returnStdout:true).trim()
        FRONTEND_SERVICE="FrontendService"
        BACKEND_SERVICE="backendService"
        FRONTEND_TASK_REVISION=sh(script:'sh ./scripts/frontend_grep.sh', returnStdout:true).trim()
        BACKEND_TASK_REVISION=sh(script:'sh ./scripts/backend_grep.sh', returnStdout:true).trim()
        FRONTEND_TASK_FAMILY="frontend"
        BACKEND_TASK_FAMILY="backend-task"
        
    }
    stages{
        
        stage('Clean Working Directory') {
            steps {
                step([$class: 'WsCleanup'])
                checkout scm
            }
        }

        stage('Tests') {
            steps {

                echo 'pull db secret for backend from the secret manager and insert it into the code'
                sh './scripts/secret.sh'

                echo 'setting venv'
                sh 'python3 -m venv ./backend/env'
                sh 'source ./backend/env/bin/activate'
                sh 'pip3 install -r ./backend/requirements.txt'

                echo 'flake test'
                sh 'python3 -m flake8 ./backend/app.py'

                sh 'pip3 install pytest'
                echo 'pytests'
                sh 'pip3 install -r ./backend/requirements.txt'
                sh 'python3 -m pytest -W ignore ./backend/tests/test.py'

            }
        }

        stage('Build App Docker Image') {
            steps {
                echo 'Building App Image'
                sh 'docker build --force-rm -t "$ECR_REGISTRY/$FRONTEND_REPO" -f ./frontend/Dockerfile ./frontend'
                sh 'docker build --force-rm -t "$ECR_REGISTRY/$BACKEND_REPO" -f ./backend/Dockerfile ./backend'
                sh 'docker image ls'
            }
        }

        stage('Push Image to ECR Repo') {
            steps {
                echo 'Pushing App Image to ECR Repo'
                sh 'aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin "$ECR_REGISTRY"'
                sh 'docker push "$ECR_REGISTRY/$FRONTEND_REPO"'
                sh 'docker push "$ECR_REGISTRY/$BACKEND_REPO"'
            }
        }

        stage('Deploy to ECS') {
            steps { 

                echo 'create task definiton for frontend'
                sh 'aws ecs --task-definition describe-task-definition backend-task >> frontend_definition.json' 

                echo 'create task definiton for backend'
                sh 'aws ecs --task-definition describe-task-definition frontend >> backend_definition.json'
                
                echo 'try to remove if output*.json files exist'
                sh 'sudo rm output*.json || true'

                echo 'Create a new task definition fomatch_patternr frontend or update an existing one'
                sh 'sudo python3 ./scripts/match_pattern.py'
                sh 'aws ecs register-task-definition --cli-input-json file://./output_frontend.json'
                sh 'aws ecs register-task-definition --cli-input-json file://./output_backend.json'
            
                echo 'update backend service'
                sh 'aws ecs update-service --cluster test-fargate --service ${BACKEND_SERVICE} --task-definition ${BACKEND_TASK_FAMILY}:${BACKEND_TASK_REVISION}'
                
                echo 'update frontend service'
                sh 'aws ecs update-service --cluster test-fargate --service ${FRONTEND_SERVICE} --task-definition ${FRONTEND_TASK_FAMILY}:${FRONTEND_TASK_REVISION}'   
            
            }
        }
        
         stage('Publish Artifacts to S3') {
            steps {
                s3Upload consoleLogLevel: 'INFO', dontSetBuildResultOnFailure: false, dontWaitForConcurrentBuildCompletion: false, entries: [[bucket: 'jenkinsartifcats/${JOB_NAME}-${BUILD_NUMBER}.', excludedFile: '/backend/env', flatten: false, gzipFiles: true, keepForever: false, managedArtifacts: true, noUploadOnFailure: false, selectedRegion: 'eu-central-1', showDirectlyInBrowser: false, sourceFile: '', storageClass: 'STANDARD', uploadFromSlave: false, useServerSideEncryption: false, userMetadata: [[key: '', value: '']]]], pluginFailureResultConstraint: 'FAILURE', profileName: 'Svetlin', userMetadata: []
            }
        }

    }

         post {
            
                always {
                    echo 'Remove all dangling docker images from Jenkins Server'
                    sh 'docker image prune -a -f --filter "until=10m"'
                    // Clean after build
                    echo 'rm workspace'
                    cleanWs notFailBuild: true

                }
        }
}
