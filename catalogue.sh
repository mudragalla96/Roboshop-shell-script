LOG_FILE=/tmp/catalogue

echo "Setup NodeJS Repo File"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
echo status = $?
echo "Installing NodeJS Server"
yum install nodejs -y ec  &>>$LOG_FILE
echo status = $?

echo "Add Roboshop Appilication User"
useradd roboshop  &>>$LOG_FILE
echo status = $?

echo "Download Catalogue Appilication Code"
 curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"  &>>$LOG_FILE
echo status = $?

 cd /home/roboshop

echo "Extract Catalogue Appilication Code"
 unzip /tmp/catalogue.zip  &>>$LOG_FILE
echo status = $?

 mv catalogue-main catalogue
 cd /home/roboshop/catalogue

echo "Install NodeJS Dependencies"
 npm install  &>>$LOG_FILE
echo status = $?

echo"Setup Catalogue Service"
 mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service  &>>$LOG_FILE
echo status = $?

systemctl daemon-reload  &>>$LOG_FILE
systemctl enable catalogue &>>$LOG_FILE

echo"Starting Catalogue Service"
systemctl start catalogue  &>>$LOG_FILE
echo status = $?