#!/bin/bash

applicationName=$1;

if [ ! -f ~/.laravel-installed ]; then
    cd /home/vagrant/$applicationName;

    composer create-project --prefer-dist laravel/laravel code;

    if [ -f /home/vagrant/$applicationName/code ]; then
        echo $applicationName > ~/.laravel-installed;
    fi
fi