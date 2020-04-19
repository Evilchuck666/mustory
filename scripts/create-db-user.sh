#!/bin/bash

applicationName="$1";

cd "/home/vagrant/$applicationName/scripts" || exit;

username="$2";
password="$3";

cp createDbUser.sql{,.bak};

sed -i "s/dbUsername/$username/" createDbUser.sql;
sed -i "s/dbPassword/$password/" createDbUser.sql;

mysql -h localhost --user="root" --password="secret" < createDbUser.sql;

rm -rf createDbUser.sql;
mv createDbUser.sql{.bak,};