#!/bin/bash
dnf update -y
dnf install -y httpd
echo \<html\>\<body\>\<h1\>Default Page\!\</h1\>\</body\>\</html\> > /var/www/html/index.html
echo \<html\>\<body\>\<h1\>Web Server Test1 Page\!\</h1\>\</body\>\</html\> > /var/www/html/test1.html
echo \<html\>\<body\>\<h1\>Web Server Test2 Page\!\</h1\>\</body\>\</html\> > /var/www/html/test2.html
sed -i '$aAlias /test1/ /var/www/html/test1.html' /etc/httpd/conf.d/welcome.conf
sed -i '$aAlias /test2/ /var/www/html/test2.html' /etc/httpd/conf.d/welcome.conf
systemctl enable --now httpd.service
