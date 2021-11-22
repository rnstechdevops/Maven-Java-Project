FROM centos

LABEL Maintainer=RNS Email=rns@rnstech.com

RUN yum update -y
RUN yum -y install java
RUN java -version

#RUN mkdir /opt/tomcat/

WORKDIR /opt
RUN curl -O http://mirrors.estointernet.in/apache/tomcat/tomcat-9/v9.0.55/bin/apache-tomcat-9.0.55.tar.gz
RUN tar xzvf apache-tomcat-9.0.55.tar.gz -C /opt/
RUN cp -R /opt/apache-tomcat-9.0.55/ /opt/tomcat

WORKDIR /opt/tomcat/webapps
COPY target/*.war /opt/tomcat/webapps/webapp.war

EXPOSE 8080

ENTRYPOINT ["/opt/tomcat/bin/catalina.sh", "run"]
