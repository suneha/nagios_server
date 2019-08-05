FROM centos:7

RUN yum -y install httpd php gcc glibc glibc-common wget perl gd gd-devel unzip zip make
RUN useradd nagios \
    && groupadd nagcmd \
    && usermod -a -G nagcmd nagios \
    && usermod -a -G nagcmd apache \
    && wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.3.tar.gz \
    && tar -zxvf nagios-4.4.3.tar.gz \
    && cd nagios-4.4.3 \
    && ./configure --with-nagios-group=nagios --with-command-group=nagcmd \
    && make all \
    && make install \
    && make install-init \
    && make install-config \
    && make install-commandmode \
    && make install-webconf \
    && make install-exfoliation \
    && htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin test101 \
    && sed -i 's/^\([[:blank:]]*[[:blank:]]email[[:blank:]]*[[:blank:]]*\).*$/\1suneha.rawat@gslab.com/' /usr/local/nagios/etc/objects/contacts.cfg \
    && wget https://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz \
    && tar -zxvf nagios-plugins-2.2.1.tar.gz \
    && cd nagios-plugins-2.2.1 \
    && ./configure --with-nagios-user=nagios --with-nagios-group=nagios \
    && make \
    && make install

ENTRYPOINT ["/usr/sbin/init"]
CMD ["systemctl start nagios"]
