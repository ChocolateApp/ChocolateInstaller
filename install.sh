#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "Hi, thanks for installing Chocolate, I'm your guide for this installation."
pythonRequirement="https://raw.githubusercontent.com/Impre-visible/Chocolate/main/requirements.txt"
#check if pip3 is installed
if ! [ -x "$(command -v python3)" ]; then
    apt install -y python3
    echo "I installed python3"
fi
if ! [ -x "$(command -v pip3)" ]; then
    apt install -y python3-pip
    echo "I installed pip3"
    pip3 install crudini --quiet --exists-action i
fi
pip3 install -r "$pythonRequirement" --quiet --exists-action i
#clone the repo
chocolateRepo="https://github.com/ChocolateApp/Chocolate.git"
linuxStart="https://raw.githubusercontent.com/ChocolateApp/ChocolateInstallLinux/main/start.sh"
git clone "$chocolateRepo" Chocolate/ --quiet
#edit the gitingore
echo "start.sh" >> Chocolate/.gitignore
echo "database.db" >> Chocolate/.gitignore

echo "We need to set up the default settings"
echo ""
echo "We need a TMDB API key, follow this link and the instructions to get one: https://developers.themoviedb.org/3/getting-started/introduction"
read -p "Please, enter your TMDB API key: " tmdbApiKey
#write the tmdb api key in the config.ini file
crudini --set Chocolate/config.ini APIKeys tmdb $tmdbApiKey
echo "Done!"
echo "We need to set the default language"
echo "The language must be in the format: DE, EN, etc...! Here's the list of supported languages: DE, EN, ES, FR, IT, NL, PL"
read -p "Enter the language: " language
#write the language in the config.ini file
crudini --set Chocolate/config.ini ChocolateSettings language $language
echo "I set the language"

#install in /etc/chocolate
mv Chocolate /etc/chocolate
#install start.sh
wget -q "$linuxStart" -O /etc/chocolate/start.sh
chmod +x /etc/chocolate/start.sh
#set the alias
echo "alias chocolate='python3 /etc/chocolate/start.sh'" >> ~/.bashrc

echo "All the settings can be changed in the config.ini file, or on the settings page in Chocolate"
echo "Everything is set up, now you can run Chocolate with the command 'chocolate'"