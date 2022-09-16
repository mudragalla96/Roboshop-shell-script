
echo installing nginx
yum install nginx -y
echo downloading the nginx
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

cd /usr/share/nginx/html


echo removing old web content
rm -rf *

echo extarcting nginx
unzip /tmp/frontend.zip

mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf

echo starting nginx
systemctl enable nginx
systemctl restart nginx