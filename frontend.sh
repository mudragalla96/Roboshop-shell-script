 echo installing nginx
 yum install nginx -y &>>/tmp/frontend
 echo status = $?

echo downloading the nginx web content
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
cd /usr/share/nginx/html
echo status = $?
echo removing the old content
rm -rf *

echo extracting web content
unzip /tmp/frontend.zip &>>/tmp/frontend
echo status = $?
mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
echo status = $?
echo starting nginx services
systemctl enable nginx &>>/tmp/frontend
systemctl restart nginx &>>/tmp/frontend
echo status = $?