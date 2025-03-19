SELECT user, host, plugin FROM mysql.user WHERE user = 'root';

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Password123';
FLUSH PRIVILEGES;


sudo systemctl restart mysql
