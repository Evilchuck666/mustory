#!/bin/bash

# VARIABLES TO FILL ON SETUP BASH SCRIPT
applicationName=;
databaseName=;
dbUsername=;
dbPassword=;

# SETTING VAGRANT HOSTNAME
echo $applicationName > /etc/hostname;
hostname $applicationName;
hostnamectl set-hostname $applicationName;

cat > /etc/hosts << EOF
127.0.0.1       localhost
127.0.1.1       $applicationName       $applicationName

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

## vagrant-hostmanager-start
192.168.10.10   $applicationName
## vagrant-hostmanager-end

#### HOMESTEAD-SITES-BEGIN
#### HOMESTEAD-SITES-END
EOF

# EXECUTE INSTALLATION OF LARAVEL AND DATABASE CONFIGURATION
if [ ! -f /home/vagrant/.laravel-installed ]; then
    su vagrant -c "bash \"/home/vagrant/$applicationName/scripts/laravel-install.sh\" \"$applicationName\"";
    su vagrant -c "bash \"/home/vagrant/$applicationName/scripts/database-config.sh\" \"$applicationName\" \"$databaseName\" \"$dbUsername\" \"$dbPassword\"";

    su root -c "bash \"/home/vagrant/$applicationName/scripts/create-db-user.sh\" \"$applicationName\" \"$dbUsername\" \"$dbPassword\"";
fi;