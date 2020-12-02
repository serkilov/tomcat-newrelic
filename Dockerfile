FROM        tomcat:latest

MAINTAINER Arsen Serkilov

ENV JAVA_OPTS="-Xms256m -Xmx1024m -XX:MaxPermSize=256m"
ENV NEWRELIC_KEY="1234567890"
ENV NEWRELIC_APP_NAME="myapp"

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

RUN 	cp /usr/local/tomcat/newrelic/newrelic.yml /usr/local/tomcat/newrelic/newrelic.yml.original && \
	    cat /usr/local/tomcat/newrelic/newrelic.yml.original | sed -e "s/'<\%= license_key \%>'/\'${NEWRELIC_KEY}\'/g" |
        sed -e "s/app_name:\ My\ Application/app_name:\ ${NEWRELIC_APP_NAME}/g" > /usr/local/tomcat/newrelic/newrelic.yml

ENV JAVA_OPTS="$JAVA_OPTS -javaagent:/usr/local/tomcat/newrelic/newrelic.jar"
# Config to include the agent logs in Docker's stdout logging
ENV JAVA_OPTS="$JAVA_OPTS -Dnewrelic.config.log_file_name=STDOUT"
EXPOSE 8080
CMD ["catalina.sh", "run"]