FROM sameersbn/ubuntu:14.04.20141026
MAINTAINER Sunchan Lee <sunchanlee@inslab.co.kr>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv C3173AA6 \
 && echo "deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main" >> /etc/apt/sources.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv C300EE8C \
 && echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu trusty main" >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y supervisor logrotate nginx mysql-server-5.5 mysql-client postgresql-client \
      imagemagick subversion git cvs bzr mercurial rsync ruby2.1 locales openssh-client \
      gcc g++ make patch pkg-config ruby2.1-dev libc6-dev \
      libmysqlclient18 libpq5 libyaml-0-2 libcurl3 libssl1.0.0 \
      libxslt1.1 libffi6 zlib1g \
 && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX \
 && gem install --no-document bundler \
 && rm -rf /var/lib/apt/lists/* # 20140918

RUN sed -i 's/key_buffer/key_buffer_size/g' /etc/mysql/my.cnf

ADD assets/setup/ /app/setup/
RUN chmod 755 /app/setup/install
RUN /app/setup/install

ADD assets/config/ /app/setup/config/
ADD assets/init /app/init
RUN chmod 755 /app/init

EXPOSE 80 443 3306

ENV REDMINE_RELATIVE_URL_ROOT /redmine

#ENV LDAP_HOST
#ENV LDAP_PORT
#ENV LDAP_BASE_DN

VOLUME ["/root/redmine/data"]
VOLUME ["/var/log/redmine"]
VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/app/init"]
CMD ["app:start"]
