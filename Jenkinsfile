pipeline {
    agent any
    tools {
        jdk 'java'
        maven 'maven'
    }
    environment {
        SCANNER_HOME = tool 'sonar'
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

        stage('Compile') {
            steps {
                sh 'mvn clean compile'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv('sonar') {
                        sh 'mvn sonar:sonar'
                    }
                }
            }
        }
        stage('Unit Tests') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --format HTML', odcInstallation: 'owasp'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn package'
            }
        }
        stage('Docker Build and Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker'){
                        sh 'docker build -t pavan1309/petclinic:latest .'
                        sh 'docker push pavan1309/petclinic:latest'

                    }  
                }   
            }
        }
        stage('Image Scan') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker') {
                        sh 'trivy image --exit-code 1 --severity HIGH,CRITICAL pavan1309/petclinic:latest'
                    }
                }
            }
        }

    }
}
