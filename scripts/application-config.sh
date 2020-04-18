#!/bin/bash

applicationName=;

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

if [ ! -f /home/vagrant/.laravel-installed ]; then
    su vagrant -c "sh \"/home/vagrant/$applicationName/scripts/laravel-install.sh\" \"$applicationName\"";
fi