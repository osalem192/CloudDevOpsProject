pipeline {
    agent any

    environment {
        IMAGE_NAME = 'osalem192/triak'
        IMAGE_TAG = "v${env.BUILD_ID}"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/osalem192/CloudDevOpsProject.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building docker image..."
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ./Code_and_Dockerfile"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker_credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    script {
                        sh "echo $PASSWORD | docker login -u $USERNAME --password-stdin"
                        sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                    }
                }
            }
        }

        stage('Delete Local Docker Image') {
            steps {
                sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }

        stage('Update Deployment YAML') {
            steps {
                script {
                    sh "sed -i 's|image:.*|image: ${IMAGE_NAME}:${IMAGE_TAG}|' Kubernetes/app-deployment.yaml"
                    sh "cp Kubernetes/app-deployment.yaml ./app-deployment.yaml"
                }
            }
        }

        stage('Push to GitHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'GitHub_Credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    script {
                        sh "git config --global user.name 'Jenkins'"
                        sh "git config --global user.email 'Jenkins@gmail.com'"
                        sh "git add app-deployment.yaml"
                        sh "git remote set-url origin 'https://github.com/osalem192/CloudDevOpsProject_ArgoCD_SyncRepo.git'"
                        sh "git commit -m 'Jenkins build:${IMAGE_TAG}'"
                        sh "git push https://${USERNAME}:${PASSWORD}@github.com/osalem192/CloudDevOpsProject_ArgoCD_SyncRepo.git main"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully."
        }
        failure {
            echo "Pipeline failed."
        }
    }
}
