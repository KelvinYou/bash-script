JAVA_HOME=/usr/jdk/java-11.0.9.11
CATALINA_HOME=/disk11/apache-tomcat-9.0.64
CATALINA_BASE=/disk11/tomcat-instances/fnx-mqpos

export JAVA_HOME JAVA_OPTS CATALINA_HOME CATALINA_BASE CATALINA_OPTS

set CATALINA_OPTS=-server -Xms256m -Xmx768m
set JAVA_OPTS=-Djdk.tls.trustNameService=true -Dorg.opensaml.httpclient.https.disableHostnameVerification=true -Djava.awt.headless=true

$CATALINA_HOME/bin/catalina.sh start
