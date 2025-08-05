pipeline {
    agent any
    tools {
        jdk 'java'
        maven 'maven'
    }

    // environment {
    //     SCANNER_HOME=tool 'sonar-scanner'
    // }

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
        stage('docker build') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'docker']) {
                        sh 'docker build -t petclinic:latest .'
                        sh 'docker tag petclinic:latest pavan1309/petclinic:latest'
                        sh 'docker push pavan1309/petclinic:latest'
                    }
            }
        }
    }

}
