#!/bin/bash

# CLEAR CONSOLE
clear;

# CONSTANT VALUES FOR VM RAM
readonly _DEV="2048";
readonly _PRO="1024";

# CHOOSE WHICH KIND OF SETUP WILL BE PERFORMED.
echo "Which kind of environment is the installation for?";
echo "0. Development";
echo "1. Production";
read -r -p 'Type the environment (default Development): ' environment;
if [ "$environment" = "" ]; then
    environment="0";
fi;

# SETS APPLICATION AND DATABASE NAME
read -r -p 'Enter the name of the application:' applicationName;
if [ "$applicationName" = "" ]; then
    applicationName="music-biblio";
fi;

databaseName=${applicationName//-/_};

# SETS THE USERNAME AND PASSWORD DATABASES
read -r -p 'Enter the name of the mysql username administrator (default superadmin): ' dbUsername;
if [ "$dbUsername" = "" ]; then
    dbUsername="superadmin";
fi;

read -s -r -p 'Enter the password of the mysql administrator (default superadmin): ' dbPassword;
if [ "$dbPassword" = "" ]; then
    dbPassword="superadmin";
fi;

# SETTING RAM
if [ "$environment" = "0" ]; then
    ram="$_DEV";
    cpu="2";
else
    ram="$_PRO";
    cpu="1";
fi;

# CLONING HOMESTEAD PROJECT
rm -rf vagrant;
git clone https://github.com/laravel/homestead.git vagrant;

# GOING TO vagrant FOLDER, REMOVE GIT REPO AND INITIALIZE HOMESTEAD
cd vagrant || exit;
rm -rf .git .gitattributes .github;
./init.sh;

# STORE DATABASE VARIABLES
cat > ../scripts/setup-params << EOF
$applicationName
$databaseName
$dbUsername
$dbPassword
EOF

# INSTALL VAGRANT-HOSTMANAGER PLUGIN IF NEEDED
hostManagerPlugin=$(vagrant plugin list | grep vagrant-hostmanager);
if [ "$hostManagerPlugin" = "" ]; then
    vagrant plugin install vagrant-hostmanager;
fi;

# REMOVING Homestead.yaml FROM .gitignore AND OLD PHP VERSIONS
# FROM .travis.yml IF THE ENVIRONMENT IS FOR DEVELOPMENT PURPOSES.
if [ "$environment" = "0" ]; then
    sed -i '/\/Homestead.yaml/d' .gitignore;
    sed -i '/7\.[1-3]$/d' .travis.yml;
    sed -i '/nightly$/d' .travis.yml;
fi;

# CHANGING RAM AND CPU NUMBERS
sed -i "s/cpus: 2/cpus: $cpu/g" Homestead.yaml;
sed -i "s/memory: 2048/memory: $ram/g" Homestead.yaml;
sed -i "s/- homestead/- $databaseName/g" Homestead.yaml;

# CHANGE VM NAME
sed -i "/provider/a name: $applicationName" Homestead.yaml;

# CHANGING SYNCED FOLDERS
sed -i "s| - map: ~/code| - map: ../.|g" Homestead.yaml;
sed -i "s|to: /home/vagrant/code|to: /home/vagrant/$applicationName|g" Homestead.yaml;

# CHANGING SITES MAPPING
sed -i "s|homestead.test|$applicationName|g" Homestead.yaml;
sed -i "s|/public|/code/public|g" Homestead.yaml;

# CREATING SSH KEYS IF THEY DON'T EXIST
if [ ! -f ~/.ssh/id_rsa.pub ]; then
    # shellcheck disable=SC2002
    cat /dev/zero | ssh-keygen -t rsa -q -N "";
fi;

# COPY CUSTOM PROVISION SCRIPT TO vagrant DIR
cp ../scripts/application-config.sh .;
sed -i "s|applicationName=;|applicationName=$applicationName;|g" application-config.sh;

# ADD CUSTOM PROVISIONING SCRIPT TO Vagrantfile
sed -i "/aliasesPath = confDir/a initAppPath = confDir + \"\/application-config.sh\"" Vagrantfile;
sed -i "s/^end$//" Vagrantfile;
cat >> Vagrantfile << EOF
    if File.exist? initAppPath then
        config.vm.provision "shell", run: "always", path: initAppPath, privileged: true, keep_color: true
    end
end
EOF

vagrant up;
