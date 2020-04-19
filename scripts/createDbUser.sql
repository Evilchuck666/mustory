CREATE USER 'dbUsername'@'localhost' IDENTIFIED BY 'dbPassword';
CREATE USER 'dbUsername'@'%' IDENTIFIED BY 'dbPassword';

GRANT ALL PRIVILEGES ON *.* TO 'dbUsername'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO 'dbUsername'@'%';

FLUSH PRIVILEGES;