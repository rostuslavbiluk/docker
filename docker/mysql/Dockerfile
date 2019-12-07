FROM mysql:5.6

ADD my.cnf /etc/mysql/conf.d/my.cnf

RUN apt-get update \
    && apt-get install -y wget

CMD ["mysqld", "--initialize"]

WORKDIR "/var/www"

EXPOSE 3306
