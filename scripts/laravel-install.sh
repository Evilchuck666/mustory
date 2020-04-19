#!/bin/bash

# DOWNLOADS LARAVEL PROJECT
applicationName="$1";

cd /home/vagrant/"$applicationName" || exit;

composer create-project --prefer-dist laravel/laravel code;

echo "$applicationName" > /home/vagrant/.laravel-installed;
