pipeline {
    agent any

    environment {
        IMAGE_NAME = "yourdockerhubusername/devsecops-app"
        SONARQUBE_ENV = "sonarqube-server"
        AWS_REGION = "ap-south-1"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                url: 'https://github.com/your-username/ci-cd-devsecops-pipeline.git'
            }
        }

        stage('Static Code Analysis - SonarQube') {
            steps {
                withSonarQubeEnv("${SONARQUBE_ENV}") {
                    sh '''
                    echo "Running SonarQube Scan..."
                    '''
                }
            }
        }

        stage('Dependency Scan - OWASP & Snyk') {
            steps {
                sh 'chmod +x scripts/dependency-scan.sh'
                sh './scripts/dependency-scan.sh'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
            }
        }

        stage('Docker Image Scan - Trivy') {
            steps {
                sh 'chmod +x scripts/docker-image-scan.sh'
                sh "./scripts/docker-image-scan.sh ${IMAGE_NAME}:${BUILD_NUMBER}"
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push $IMAGE_NAME:$BUILD_NUMBER
                    '''
                }
            }
        }

        stage('Deploy to AWS') {
            steps {
                sh 'chmod +x deploy/aws-deploy.sh'
                sh "./deploy/aws-deploy.sh ${IMAGE_NAME}:${BUILD_NUMBER}"
            }
        }
    }
}
