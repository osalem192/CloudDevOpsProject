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

        stage('Update ArgoCD Repo') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'GitHub_Credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    script {
                        // 1. Update deployment YAML
                        sh """
                        sed -i 's|image:.*|image: ${IMAGE_TAG}|' Kubernetes/app-deployment.yaml
                        """

                        // 2. Clone the ArgoCD repo into a subdirectory
                        sh """
                        git clone https://${USERNAME}:${PASSWORD}@github.com/osalem192/CloudDevOpsProject_ArgoCD_SyncRepo.git argocd-repo
                        """

                        // 3. Copy the updated file into the cloned repo
                        sh "cp Kubernetes/app-deployment.yaml argocd-repo/"

                        // 4. Commit & push only if there are actual changes
                        sh """
                        cd argocd-repo
                        git config user.name "jenkins"
                        git config user.email "jenkins@myorg.com"

                        if [ -n "$(git status --porcelain)" ]; then
                        git add .
                        git commit -m "Update deployment image to ${IMAGE_TAG}"
                        git push origin main
                        echo "✅ Successfully pushed to ArgoCD repository"
                        else
                        echo "ℹ️ No changes to commit"
                        fi
                        """
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
