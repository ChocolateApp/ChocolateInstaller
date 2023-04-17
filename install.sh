#!/bin/bash

#check if user in sudo group
if [ $(id -u) -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi
echo "Hi, thanks for installing Chocolate, I'm your guide for this installation."

if command -v python &>/dev/null; then
    python_version=$(python -c 'import sys; print("".join(map(str, sys.version_info[:3])))')
    python_version=$((python_version + 0))
    echo $python_version
    if [ $(echo "$python_version >= 390" | bc -l) -eq 1]; then
        echo "Python 3.9 or higher is installed"
    else
        echo "Python 3.9 or higher is required. Please install it and try again."
        exit 1
    fi
elif command -v python3 &>/dev/null; then
    python_version=$(python3 -c 'import sys; print("".join(map(str, sys.version_info[:3])))')
    if [ $(echo "$python_version >= 390" | bc -l) -eq 1 ]; then
        echo "Python 3.9 or higher is installed"
    else
        echo "Python 3.9 or higher is required. Please install it and try again."
        exit 1
    fi
else
    echo "Python is not installed. Installing Python 3.10..."
    sudo apt-get update && sudo apt-get install python3.10 -y
fi

# Vérifier si pip3 est installé
if command -v pip3 &>/dev/null; then
    echo "pip3 is installed"
else
    echo "pip3 is not installed. Installing pip3..."
    sudo apt-get update && sudo apt-get install python3-pip -y
fi

# Vérifier si node est installé
if command -v node &>/dev/null; then
    echo "node is installed"
else
    echo "node is not installed. Installing node..."
    sudo apt-get update && sudo apt-get install nodejs -y
fi

# Vérifier si npm est installé
if command -v npm &>/dev/null; then
    echo "npm is installed"
else
    echo "npm is not installed. Installing npm..."
    sudo apt-get update && sudo apt-get install npm -y
fi

# Vérifier si ffmpeg est installé
if command -v ffmpeg &>/dev/null; then
    echo "ffmpeg is installed"
else
    echo "ffmpeg is not installed. Installing ffmpeg..."
    sudo apt-get update && sudo apt-get install ffmpeg -y
fi

# Vérifier si crudini est installé
if command -v crudini &>/dev/null; then
    echo "crudini is installed"
else
    echo "crudini is not installed. Installing crudini..."
    sudo apt-get update && sudo apt-get install crudini -y
fi

# Cloner les dépôts GitHub
sudo mkdir -p /etc/chocolate/back /etc/chocolate/front
sudo git clone https://github.com/ChocolateApp/Chocolate.git /etc/chocolate/back
sudo git clone https://github.com/ChocolateApp/ChocolateReact.git /etc/chocolate/front

cd /etc/chocolate/front
sudo npm install --silent

cd /etc/chocolate/back
sudo pip install -r requirements.txt

# Copier le fichier start.sh
sudo curl -o /etc/chocolate/start.sh https://raw.githubusercontent.com/ChocolateApp/ChocolateInstallLinux/main/start.sh

# Ajouter la commande chocolate comme alias
sudo echo 'alias chocolate="sudo /etc/chocolate/start.sh"' >> ~/.bashrc

# Ajouter les variables de configuration pour TMDB et la langue par défaut
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

echo "alias chocolate='sudo sh /etc/chocolate/start.sh'" >> ~/.bashrc

echo "Awesome, Chocolate is installed to /etc/chocolate and is now ready to use!"
echo "You can start Chocolate by typing 'chocolate' in the terminal. You can edit the settings directly on the settings page in Chocolate."
echo "You have to add your path to the settings page, or it won't work."
