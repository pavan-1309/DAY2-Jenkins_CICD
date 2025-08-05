pipeline {
    agent any

    tools {
        jdk 'java'
        maven 'maven'
    }

    environment {
        SONARQUBE_SERVER = 'sonar' // Jenkins SonarQube server name
        SCANNER_HOME = tool 'sonar-scanner' // Must match Jenkins tool name
    }

    stages {

        stage('Checkout') {
            steps {
                git 'https://github.com/spring-petclinic/spring-framework-petclinic.git'
            }
        }

        stage('Clean & Compile') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Code Coverage Report') {
            steps {
                sh 'mvn jacoco:report'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv("${SONARQUBE_SERVER}") {
                        sh '''
                            ${SCANNER_HOME}/bin/sonar-scanner \
                            -Dsonar.projectKey=petclinic \
                            -Dsonar.projectName=Petclinic \
                            -Dsonar.sources=. \
                            -Dsonar.java.binaries=target/classes \
                            -Dsonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml
                        '''
                    }
                }
            }
        }

        stage('Dependency Check') {
            steps {
                sh 'mvn org.owasp:dependency-check-maven:check'
            }
        }

        stage('Package Build') {
            steps {
                sh 'mvn package -DskipTests'
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        docker login -u $DOCKER_USER -p $DOCKER_PASS
                        docker build -t $DOCKER_USER/petclinic:latest .
                        docker push $DOCKER_USER/petclinic:latest
                    '''
                }
            }
        }

        stage('Trivy Scan') {
            steps {
                sh 'trivy image --exit-code 0 --severity HIGH,CRITICAL $DOCKER_USER/petclinic:latest || true'
            }
        }
        stage('Deploy the Application') {
            steps {
                sh '''
                    docker run -d --name petclinic -p 8082:8080 $DOCKER_USER/petclinic:latest
                '''
            }
        }

    }
}
