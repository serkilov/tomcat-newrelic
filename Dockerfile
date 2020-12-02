FROM        tomcat:latest

MAINTAINER Arsen Serkilov

ENV JAVA_OPTS="-Xms256m -Xmx1024m"

RUN     apt-get update && apt-get install -y \
		unzip \
		wget

RUN	    ln -sf /usr/local/tomcat/webapps /webapps && \
		rm -rf /webapps/examples && \
		rm -rf /webapps/docs && \
		wget -q "https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip" -O /tmp/newrelic.zip && \
		unzip /tmp/newrelic.zip -d /usr/local/tomcat/ && \
		rm /tmp/newrelic.zip && \
		cd /usr/local/tomcat/newrelic

ENV JAVA_OPTS="$JAVA_OPTS -javaagent:/usr/local/tomcat/newrelic/newrelic.jar"
# Config to include the agent logs in Docker's stdout logging
ENV JAVA_OPTS="$JAVA_OPTS -Dnewrelic.config.log_file_name=STDOUT"
EXPOSE 8080
CMD ["catalina.sh", "run"]