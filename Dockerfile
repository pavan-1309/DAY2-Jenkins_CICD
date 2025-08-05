FROM tomcat:10.1-jdk17
COPY target/petclinic.war /usr/local/tomcat/webapps/
EXPOSE 8080