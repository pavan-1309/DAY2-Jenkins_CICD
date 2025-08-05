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
                        sh '''
                            $SCANNER_HOME/bin/sonar \
                            -Dsonar.projectName=Petclinic \
                            -Dsonar.projectKey=petclinic \
                            -Dsonar.sources=. \
                            -Dsonar.java.binaries=.
                        '''
                    }
                }
            }
        }

        stage('SonarQube Quality Gate') {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                    script {
                        waitForQualityGate abortPipeline: true
                    }
                }
                echo 'SonarQube Quality Gate passed.'
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
                    withDockerRegistry(credentialsId: 'docker') {
                        sh 'docker build -t pavan1309/petclinic:latest .'
                        sh 'docker push pavan1309/petclinic:latest'
                    }
                }
            }
        }

        stage('Image Scan') {
            steps {
                script {
                    sh 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --exit-code 1 --severity HIGH,CRITICAL pavan1309/petclinic:latest'
                }
            }
        }

        stage('Deploy the Application') {
            steps {
                script {
                    sh 'docker rm -f petclinic || true'
                    sh 'docker run -d --name petclinic -p 8082:8080 pavan1309/petclinic:latest'
                }
            }
        }
    }
}
