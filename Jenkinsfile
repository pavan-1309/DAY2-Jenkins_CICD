pipeline {
    agent any
    tools {
        jdk 'java'
        maven 'maven'
    }

    stages {
        stage('Clean workspace') {
            steps {
                echo 'Cleaning workspace...'
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/pavan-1309/DAY2-Jenkins_CICD.git'
            }
        }

        stage('compile') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Test Cases') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --format HTML ', odcInstallation: 'owasp'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage('build') {
            steps {
                sh 'mvn package'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    docker.withRegistry('creds:dockerhub', toolName: 'docker') {
                        sh "docker build -t image1 ."
                        sh "docker tag image1 pavan1309/image1:latest"
                        sh "docker push pavan1309/image1:latest"
                    }
                }
            }
        }
    }
}
