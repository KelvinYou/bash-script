for PID in `ps -ef | pgrep -f /disk11/tomcat-instances/fnx-mqpos`;

do kill -9 $PID
done
echo "Killed process"

count=`ps -ef | grep /disk11/tomcat-instances/fnx-mqpos | grep -v grep | wc -l`
if [[ ${count} -lt 1 ]]; then

JAVA_HOME=/usr/jdk/java-11.0.9.11
CATALINA_HOME=/disk11/apache-tomcat-9.0.64
CATALINA_BASE=/disk11/tomcat-instances/fnx-mqpos

export JAVA_HOME JAVA_OPTS CATALINA_HOME CATALINA_BASE CATALINA_OPTS

set CATALINA_OPTS=-server -Xms256m -Xmx768m
set JAVA_OPTS=-Djdk.tls.trustNameService=true -Dorg.opensaml.httpclient.https.disableHostnameVerification=true -Djava.awt.headless=true

$CATALINA_HOME/bin/catalina.sh start

else
  echo "process aready exists!"
  exit 1
fi
