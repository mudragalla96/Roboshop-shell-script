
echo installing nginx
yum install nginx -y &>>/tmp/frontend
echo downloading the nginx
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>/tmp/frontend

cd /usr/share/nginx/html &>>/tmp/frontend


echo removing old web content
rm -rf * &>>/tmp/frontend

echo extarcting nginx
unzip /tmp/frontend.zip &>>/tmp/frontend

mv frontend-main/static/* . &>>/tmp/frontend
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>/tmp/frontend

echo starting nginx
systemctl enable nginx &>>/tmp/frontend
systemctl restart nginx &>>/tmp/frontend