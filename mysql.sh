LOG_FILE=/tmp/mysql
source common.sh
echo "Setup MySQL Repo"
 curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG_FILE}
 StatusCheck $?

echo "Disable MySQL Default Module to Enable 5.7 MySQL"
 dnf module disable mysql -y &>>$LOG_FILE
StatusCheck $?
echo "Install MySQL Server"
 yum install mysql-community-server -y &>>$LOG_FILE
StatusCheck $?
echo "Start MySQL Service"
systemctl enable mysqld &>>$LOG_FILE
systemctl restart mysqld &>>$LOG_FILE
StatusCheck $?

DEFAULT_PASSWORD=$( grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')

echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('mypass');
     FLUSH PRIVILEGES;"



