#!/bin/bash

# CONSTANTS STRING TO LOOK INSIDE .ENV FILE TO CONFIGURE DATABASE CONNECTION
_APP_NAME_STR="APP_NAME=";
_DB_DATABASE_STR="DB_DATABASE=";
_DB_USERNAME_STR="DB_USERNAME=";
_DB_PASSWORD_STR="DB_PASSWORD=";

# APPLICATION AND DATABASE NAMES
applicationName="$1";
databaseName="$2";

# USERNAME AND PASSWORD
dbUsername="$3";
dbPassword="$4";

# CREATES 2 ARRAYS, ONE FOR THE KEYS AND ANOTHER FOR THE VALUES
envKeys=("$_APP_NAME_STR" "$_DB_DATABASE_STR" "$_DB_USERNAME_STR" "$_DB_PASSWORD_STR");
envValues=("$applicationName" "$databaseName" "$dbUsername" "$dbPassword");

cd /home/vagrant/"$applicationName" || exit;
for index in "${!envKeys[@]}"
do
    # SAVES LINE NUMBER
    envLine[$index]=$(grep -nr "${envKeys[$index]}" code/.env | awk -F ":" '{print $1}');

    sed -i "${envLine[$index]}s/.*/${envKeys[$index]}${envValues[$index]}/" code/.env;
done;