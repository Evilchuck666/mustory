#!/bin/bash

applicationName="$1";

if [ ! -f /home/vagrant/.laravel-installed ]; then
    cd /home/vagrant/"$applicationName" || exit;

    composer create-project --prefer-dist laravel/laravel code;

    echo "$applicationName" > /home/vagrant/.laravel-installed;
fi;
