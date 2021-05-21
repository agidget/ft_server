service nginx start                       
service mysql start                       
service php7.3-fpm start

#mySQL launch
#https://www.shellhacks.com/mysql-run-query-bash-script-linux-command-line/
mysql -u root <<MYRUN
    CREATE DATABASE my_db;
    CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';
    GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' IDENTIFIED BY 'admin';
    FLUSH PRIVILEGES;
MYRUN

#while true; do sleep 2; done

bash