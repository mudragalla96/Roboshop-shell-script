ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo You should run this script as root user or with sudo privileges.
  exit 1
fi

StatusCheck () {
  if [ $1 -eq 0 ]; then
    echo -e status = "\e[32mSUCCESS\e[0m"
  else
    echo -e status = "\e[31mFAILURE\e0m"
    exit 1
  fi
}

APP_PREREQ () {
  id roboshop &>>${LOG_FILE}
  if [ $? -ne 0 ]; then
   echo "Add Roboshop Application User"
   useradd roboshop &>>${LOG_FILE}
   StatusCheck $?

  fi
  echo "Download ${COMPONENT} Application Code"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG_FILE}
  StatusCheck $?

  cd /home/roboshop

  echo "Clean Old App Content"
  rm -rf ${COMPONENT} &>>${LOG_FILE}
  StatusCheck $?

  echo "Extract ${COMPONENT} Application Code"
  unzip /tmp/${COMPONENT}.zip &>>${LOG_FILE}
  StatusCheck $?

  mv ${COMPONENT}-main ${COMPONENT}
  cd /home/roboshop/${COMPONENT}
}

SYSTEMD_SETUP () {
 echo "Update SystemD Service File"
sed -i -e 's/REDIS_ENDPOINT/redis.vykunta.internal/' -e 's/MONGO_ENDPOINT/mongodb.vykunta.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.vykunta.internal/' -e 's/MONGO_DNSNAME/mongodb.vykunta.internal/' -e 's/CARTENDPOINT/cart.vykunta.internal/' -e 's/DBHOST/mysql.vykunta.internal/' -e 's/CARTHOST/cart.vykunta.internal/' -e 's/USERHOST/user.vykunta.internal/' -e 's/AMQPHOST/rabbitmq.vykunta.internal/' /home/roboshop/${COMPONENT}/systemd.service
 StatusCheck $?


 echo "Setup ${COMPONENT} Service"
 mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${LOG_FILE}
 StatusCheck $?

 systemctl daemon-reload &>>${LOG_FILE}
 systemctl enable ${COMPONENT} &>>${LOG_FILE}

 echo "Start ${COMPONENT} Service"
 systemctl start ${COMPONENT} &>>${LOG_FILE}
 StatusCheck $?
 }


NodeJS() {

  echo "Setup NodeJS Repo File"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
  StatusCheck $?

  echo "Installing NodeJS Server"
  yum install nodejs -y &>>${LOG_FILE}
  StatusCheck $?

APP_PREREQ

  echo "Install NodeJS Dependencies"
  npm install &>>${LOG_FILE}
  StatusCheck $?

SYSTEMD_SETUP

}

JAVA () {
  echo "Install Maven"
  yum install maven -y &>>${LOG_FILE}
  StatusCheck $?

APP_PREREQ

 echo "Download Dependencies & Make Package"
 mvn clean package &>>${LOG_FILE}
 mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar &>>${LOG_FILE}
 StatusCheck $?

 SYSTEMD_SETUP

}

PYTHON () {
echo "Install Python 3"
yum install python36 gcc python3-devel -y &>>${LOG_FILE}
StatusCheck $?

APP_PREREQ

 cd /home/roboshop/${COMPONENT}
 echo "Install Python Dependencies for App "
 pip3 install -r requirements.txt &>>${LOG_FILE}
StatusCheck $?

APP_UID=$(id -u roboshop)
APP_GID=$(id -g roboshop)

echo "Update Payment Configuaration File"
sed -i -e "/uid/ c uid = ${APP_UID}" -e "/gid/ c gid = ${APP_GID}" /home/roboshop/${COMPONENT}/${COMPONENT}.ini &>>${LOG_FILE}
StatusCheck $?

SYSTEMD_SETUP
}