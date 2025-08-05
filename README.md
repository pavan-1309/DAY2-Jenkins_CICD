Spring Petclinic – CI/CD Pipeline
=================================

This project sets up a complete CI/CD pipeline for the Spring Framework Petclinic application using Jenkins, SonarQube, Docker, Trivy, and OWASP Dependency Check.

Source Code
-----------
GitHub Repository:
https://github.com/spring-petclinic/spring-framework-petclinic.git

Pipeline Stages
---------------

1. Checkout
   - Pulls the latest source code from GitHub.

2. Clean & Compile
   - Cleans old build artifacts and compiles the source code:
     mvn clean compile

3. SonarQube Analysis
   - Performs static code analysis using SonarQube:
     mvn sonar:sonar -DskipTests

4. SonarQube Quality Gate
   - Waits for SonarQube quality gate result to determine code health.
     Jenkins will abort if quality gate fails.

5. Unit Tests
   - Runs all unit tests:
     mvn test

6. OWASP Dependency Check
   - Scans dependencies for known vulnerabilities:
     mvn org.owasp:dependency-check-maven:check

7. Package Build (WAR/JAR)
   - Packages the application:
     mvn package

8. Docker Build & Push
   - Builds a Docker image and pushes it to Docker Hub:
     docker build -t pavan1309/petclinic:latest .
     docker push pavan1309/petclinic:latest

9. Trivy Image Scan
   - Scans the Docker image for vulnerabilities:
     trivy image --exit-code 1 --severity HIGH,CRITICAL --format table -o trivy-report.txt pavan1309/petclinic:latest

10. Post Actions
    - Archive build artifacts (WAR file)
    - Archive Trivy scan report
    - Mark pipeline status (success/failure)

Accessing the Web Application
-----------------------------
- Docker Command: docker run --name petclinic -p 8082:8080 pavan1309/petclinic:latest
- Local Access: http://localhost:8082/petclinic/
- Public Access: http://<your-public-ip>:8082/petclinic/

Tools
--------------------
- Jenkins – Automation server for orchestrating the pipeline
- Maven – Build tool for compiling and packaging
- SonarQube – Static code quality and security analysis
- OWASP Dependency Check – Detects vulnerabilities in third-party libraries
- Docker – Containerizes the application
- Trivy – Scans Docker images for security issues

Generated Artifacts
-------------------
- target/petclinic.war – Packaged Spring Boot application
- trivy-report.txt – Docker vulnerability scan results

Security & Credentials
----------------------
- Jenkins securely injects Docker Hub and SonarQube credentials using Jenkins Credentials Manager.
- No sensitive information is hardcoded in the Jenkinsfile or source code.

GitHub Webhook Integration
--------------------------
- A GitHub webhook is configured to trigger the Jenkins pipeline automatically on every push.
- Webhook URL:
  http://13.126.71.252:8080/github-webhook/
- Ensure "GitHub hook trigger for GITScm polling" is enabled in the Jenkins job.

Jenkinsfile
-----------
- The CI/CD workflow is implemented using a declarative Jenkinsfile stored in the root of the repository.
