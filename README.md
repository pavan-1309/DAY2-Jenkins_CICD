# DAY2-Jenkins_CICD

Spring Framework Petclinic - CI/CD Pipeline
===========================================

This project implements a complete CI/CD pipeline for the Spring Petclinic project using Jenkins, SonarQube, Docker, and Trivy.

Source Code: https://github.com/spring-petclinic/spring-framework-petclinic.git

Pipeline Stages
---------------

1. Checkout
   - Pulls the latest source code from the GitHub repository.

2. Clean & Compile
   - Executes Maven commands to clean old artifacts and compile the Java source:
     mvn clean compile

3. SonarQube Analysis
   - Runs static code analysis via SonarQube:
     mvn sonar:sonar -DskipTests

4. Unit Tests
   - Executes all unit tests:
     mvn test

5. Dependency Check
   - Scans for known vulnerabilities using OWASP Dependency Check:
     mvn org.owasp:dependency-check-maven:check

6. Build (WAR/JAR)
   - Packages the application:
     mvn package

7. Docker Build & Push
   - Builds a Docker image and pushes it to Docker Hub:
     docker build -t pavan1309/petclinic:latest .
     docker push pavan1309/petclinic:latest

8. Trivy Scan
   - Scans the Docker image for vulnerabilities:
     trivy image --exit-code 1 --severity HIGH,CRITICAL --format table -o trivy-report.txt <your-username>/petclinic:latest

Tools Used
----------
- Jenkins
- Maven
- SonarQube
- OWASP Dependency Check
- Docker
- Trivy

Artifacts
---------
- target/petclinic.war – built application
- trivy-report.txt – vulnerability scan report

Security
--------
- Docker and SonarQube credentials are securely injected through Jenkins credentials.

Jenkinsfile
-----------
- The pipeline is implemented using a declarative Jenkinsfile.


