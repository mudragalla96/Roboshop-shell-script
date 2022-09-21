COMPONENT=rabbitmq
source common.sh
LOG_FILE=/tmp/${COMPONENT}

echo "Install RabbitMQ Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOG_FILE
StatusCheck $?

echo "Install Erlang & RabbitMQ"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm rabbitmq-server -y &>>$LOG_FILE
StatusCheck $?

echo "Start RabbitMQ Server"
 systemctl enable rabbitmq-server &>>$LOG_FILE
 systemctl restart rabbitmq-server &>>$LOG_FILE
StatusCheck $?

echo "Add Application User RabbitMQ"
rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
StatusCheck $?

echo "Add Application User Tags in RabbitMQ "
 rabbitmqctl set_user_tags roboshop administrator &>>$LOG_FILE
StatusCheck $?

 echo "Add Permissions for App user in RabbitMQ"
 rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
 StatusCheck $?