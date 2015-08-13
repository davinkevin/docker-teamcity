FROM podbox/tomcat8

RUN apt-get update \
 && apt-get install -yq git \
 && apt-get clean

RUN useradd -m teamcity \
 && mkdir /logs \
 && chown -R teamcity:teamcity /apache-tomcat /logs

USER teamcity
WORKDIR /apache-tomcat

ENV CATALINA_OPTS \
 -Xms768m \
 -Xmx768m \
 -Xss256k \
 -server \
 -XX:+UseCompressedOops \
 -Djsse.enableSNIExtension=false \
 -Djava.awt.headless=true \
 -Dfile.encoding=UTF-8 \
 -Duser.timezone=Europe/Paris

RUN sed -i 's/connectionTimeout="20000"/connectionTimeout="60000" useBodyEncodingForURI="true" socket.txBufSize="64000" socket.rxBufSize="64000"/' conf/server.xml

EXPOSE 8080
CMD ["./bin/catalina.sh", "run"]

# --------------------------------------------------------------------- teamcity
ENV TEAMCITY_DATA_PATH /apache-tomcat/teamcity 
ENV TEAMCITY_VERSION 9.1.1

RUN mkdir $TEAMCITY_DATA_PATH \
 && curl -LO http://download.jetbrains.com/teamcity/TeamCity-$TEAMCITY_VERSION.war \
 && unzip -qq TeamCity-$TEAMCITY_VERSION.war -d webapps/ROOT \
 && rm -f TeamCity-$TEAMCITY_VERSION.war \
 && echo '<meta name="mobile-web-app-capable" content="yes">' >> webapps/ROOT/WEB-INF/tags/pageMeta.tag

VOLUME ["${TEAMCITY_DATA_PATH}"]
