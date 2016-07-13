SET @@SESSION.SQL_LOG_BIN=0;

DELETE FROM mysql.user;
DROP DATABASE IF EXISTS test;

CREATE USER 'root'@'%' IDENTIFIED BY '<<root_password>>';
GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;

CREATE DATABASE <<database>>;
CREATE USER '<<user>>'@'%' IDENTIFIED BY '<<password>>';
GRANT ALL ON `<<user>>`.* TO '<<database>>'@'%';
FLUSH PRIVILEGES;
