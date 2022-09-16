LOG_FILE=/tmp/mongodb
echo "setting Mongodb Repo"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
echo status = $?

echo "install Mongodb server"
yum install -y mongodb-org &>>$LOG_FILE
echo status = $?

echo "upadte MongoDB Listen Address"
sed  -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
echo status = $?
echo "starting Mongodb service"
systemctl enable mongod &>>$LOG_FILE
systemctl restart mongod &>>$LOG_FILE
echo status = $?

echo "Downloading MongoDB Schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
echo status = $?
 cd /tmp
 echo "Extract the Schema File"
 unzip mongodb.zip &>>$LOG_FILE
echo status = $?

 cd mongodb-main
echo "Load Users Service Schema"
 mongo < catalogue.js &>>$LOG_FILE
echo status = $?
echo "Load Users Service Schema"
 mongo < users.js &>>$LOG_FILE
echo status = $?
