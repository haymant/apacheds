FROM centos:7

MAINTAINER "Haymant Lee @ https://github.com/haymant"

ADD apacheds.sh /usr/local/bin/	

RUN yum -y update && yum -y install java-1.7.0-openjdk openldap-clients telnet vim openssl \
  && curl -s http://www-eu.apache.org/dist//directory/apacheds/dist/2.0.0-M23/apacheds-2.0.0-M23-x86_64.rpm -o /tmp/apacheds.rpm \
	&& yum -y localinstall /tmp/apacheds.rpm && rm -rf /tmp/apacheds.rpm && mkdir -p /bootstrap/data \
	&& ln -s /bootstrap/data /data && chmod +x /usr/local/bin/apacheds.sh \
	&& chmod -R a+rwx /data && chmod -R a+rwx /var/lib/apacheds-2.0.0_M23 \
  && chmod -R a+rwx /opt/apacheds-2.0.0_M23 

RUN sed -e 's/RUN_AS_USER="apacheds"//g' -i /opt/apacheds-2.0.0_M23/bin/apacheds
RUN sed -e 's/RUN_AS_GROUP="apacheds"//g' -i /opt/apacheds-2.0.0_M23/bin/apacheds

RUN echo "TLS_REQCERT allow" >> /etc/openldap/ldap.conf

VOLUME /bootstrap

ENTRYPOINT /usr/local/bin/apacheds.sh

EXPOSE 10636
