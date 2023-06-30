JAVA_HOME=/usr/jdk/java-11.0.9.11
JAVA_OPTS=""

CATALINA_HOME=/disk11/apache-tomcat-9.0.64

CATALINA_BASE=/disk11/tomcat-instances/fnx-mqpos
export JAVA_HOME JAVA_OPTS CATALINA_HOME CATALINA_BASE

$CATALINA_HOME/bin/catalina.sh stop
