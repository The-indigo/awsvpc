#!/bin/bash
sudo apt-get update
sudo apt-get install wget apache2 unzip -y
sudo systemctl start apache2
sudo systemctl enable apache2
wget https://www.tooplate.com/zip-templates/2117_infinite_loop.zip
unzip -o 2117_infinite_loop.zip
cp -r 2117_infinite_loop/* /var/www/html
systemctl restart apache2