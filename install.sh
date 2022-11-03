#!/bin/bash

#check if user in sudo group
if [ $(id -u) -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi
echo "Hi, thanks for installing Chocolate, I'm your guide for this installation."

pythonRequirement="https://raw.githubusercontent.com/Impre-visible/Chocolate/main/requirements.txt"

if ! [ -x "$(command -v python3)" ]; then
    apt install -y python3
    echo "I installed python3"
fi
if ! [ -x "$(command -v pip3)" ]; then
    apt install -y python3-pip
    echo "I installed pip3"
    sudo apt-get install -y crudini
fi
pip3 install -r "$pythonRequirement" --quiet --exists-action i
chocolateRepo="https://github.com/ChocolateApp/Chocolate.git"
linuxStart="https://raw.githubusercontent.com/ChocolateApp/ChocolateInstallLinux/main/start.sh"
git clone "$chocolateRepo" Chocolate/ --quiet
echo "start.sh" >> Chocolate/.gitignore
echo "database.db" >> Chocolate/.gitignore

echo "We need to set up the default settings"
echo ""
echo "Let's start by creating a TMDB API key, it's very important, so please follow this link and the instructions to get one: https://developers.themoviedb.org/3/getting-started/introduction"
echo ""
read -p "When it's done, you can enter your TMDB API key here: " tmdbApiKey
crudini --set Chocolate/config.ini APIKeys tmdb $tmdbApiKey
echo ""
echo "Congrats, you have a TMDB API key!"
echo ""
echo "We need now to set the default language, a lot of languages are supported, but you can find the list of languages here: https://developers.themoviedb.org/3/getting-started/languages"
echo "The language must be in the format: DE, EN, etc...!"
read -p "Enter the language: " language
crudini --set Chocolate/config.ini ChocolateSettings language $language

mv Chocolate /etc/chocolate 2>/dev/null
wget -q "$linuxStart" -O /etc/chocolate/start.sh
chmod +x /etc/chocolate/start.sh

echo "alias chocolate='/etc/chocolate/start.sh'" >> ~/.bashrc

echo "Awesome, Chocolate is installed to /etc/chocolate and is now ready to use!"
echo "You can start Chocolate by typing 'chocolate' in the terminal. You can edit the settings directly on the settings page in Chocolate."
echo "You have to add your path to the settings page, or it won't work."
