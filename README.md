# Tomcat-newrelic
Docker image that runs tomcat with newrelic agent. 

Usage
-----
    docker run -d -e NEWRELIC_KEY=1234 -e NEWRELIC_APP_NAME=my_tomcat_at_newrelic drecchia/tomcat-newrelic:8.0.21-jre7
