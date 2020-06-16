FROM alpine
#MAINTAINER lin <935436445@qq.com>

# 
VOLUME ["/sys/fs/cgroup","/var/www/localhost/htdocs"]

RUN echo "https://mirrors.aliyun.com/alpine/v3.9/main/" > /etc/apk/repositories \
    && echo "https://mirrors.aliyun.com/alpine/v3.9/community/" >> /etc/apk/repositories \
    && apk update \
    ##############################################################
    && apk add --no-cache openrc \
    #&& apk add mysql mysql-client\
#       && echo '=====> Installing Apache2 ...' \
    && apk add --no-cache apache2 \
    && echo 'ServerName localhost' >> /etc/apache2/httpd.conf \
    && echo '=====> Installing PHP and Plugins ...' \
    && apk add --no-cache  php7 php7-apache2 php7-openssl php7-mysqli php7-pdo_mysql php7-gd php7-curl php7-fileinfo php7-mbstring php7-json \
    #avoid start apache2 notice `awk: /etc/network/interfaces: No such file or directory`
    && sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf \
    && echo 'rc_provide="loopback net"' >> /etc/rc.conf \
    && sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf \
    && sed -i '/tty/d' /etc/inittab \
    && sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname \
    && sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh \
    && sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh \
    && echo 'nohup service apache2 start &' > /etc/local.d/a.start \
    && chmod +x /etc/local.d/a.start \
    && rc-update add local \
    && sed -i '/expose_php/s/^;//;/expose_php/s/On/Off/' /etc/php7/php.ini
    #&& sed -i '/mod_rewrite.so/s/^#//'  /etc/apache2/httpd.conf


#RUN 
# 
EXPOSE 80 

# 启动命令
CMD ["/sbin/init"]
