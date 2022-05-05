 ################################
# ftp_automatic v0.1       	#
# Artur Juvé Vidal, abril 2022 #
################################

#!/bin/bash

#variables de l'script
USER_NAME="tintin"
USER_FOLDER="/var/www/html/"

#instal•lar el servidor
apt-get update
apt-get install vsftpd

#crear un usuari per accedir al ftp
adduser $USER_NAME --no-create-home --gecos ""

#afegir un nou shell al sistema que no existeixi
echo "/dev/false" >> /etc/shells

#assignar a l'usuari el shell fals per tal que no pugui obrir sessió al sistema operatiu
usermod -s /dev/false $USER_NAME

#modificar el home de l'usuari
mkdir -p $USER_FOLDER
usermod -d $USER_FOLDER $USER_NAME

#canviar els permisos
adduser $USER_NAME www-data
chgrp www-data $USER_FOLDER -R
chmod g+w $USER_FOLDER -R

#engabiar tots els usuaris de ftp
echo $USER_NAME > /etc/vsftpd.chroot_list

#afegir l'usuari a la llista d'usuaris que poden accedir al servidor ftp (usuaris vàlids)
echo $USER_NAME > /etc/vsftpd.user_list

#fitxer de configuració
echo "" > /etc/vsftpd.conf
echo "listen=YES" >> /etc/vsftpd.conf
echo "anonymous_enable=NO" >> /etc/vsftpd.conf
echo "local_enable=YES" >> /etc/vsftpd.conf
echo "write_enable=YES" >> /etc/vsftpd.conf
echo "local_umask=022" >> /etc/vsftpd.conf
echo "dirmessage_enable=YES" >> /etc/vsftpd.conf
echo "use_localtime=YES" >> /etc/vsftpd.conf
echo "xferlog_enable=YES" >> /etc/vsftpd.conf
echo "connect_from_port_20=YES" >> /etc/vsftpd.conf
echo "idle_session_timeout=600" >> /etc/vsftpd.conf
echo "ftpd_banner=Welcome to blah FTP service." >> /etc/vsftpd.conf
echo "chroot_list_enable=YES" >> /etc/vsftpd.conf
echo "chroot_list_file=/etc/vsftpd.chroot_list" >> /etc/vsftpd.conf
echo "secure_chroot_dir=/var/run/vsftpd/empty" >> /etc/vsftpd.conf
echo "pam_service_name=vsftpd" >> /etc/vsftpd.conf
echo "rsa_cert_file=/etc/ssl/certs/ssl­cert­snakeoil.pem" >> /etc/vsftpd.conf
echo "rsa_private_key_file=/etc/ssl/private/ssl­cert­snakeoil.key" >> /etc/vsftpd.conf
echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf
echo "userlist_deny=YES" >> /etc/vsftpd.conf
echo "userlist_file=/etc/vsftpd.user_list" >> /etc/vsftpd.conf

#reiniciar el sistema
systemctl reload vsftpd
