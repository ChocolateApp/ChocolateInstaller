#!/bin/bash

version=$(crudini --get /etc/chocolate/config.ini ChocolateSettings version)
curl -s -L https://raw.githubusercontent.com/ChocolateApp/Chocolate/main/config.ini > /etc/chocolate/configTemp.ini
latestVersion=$(crudini --get /etc/chocolate/configTemp.ini ChocolateSettings version)
rm configTemp.ini
version=$(echo $version | tr -d '.')
latestVersion=$(echo $latestVersion | tr -d '.')
version=$((version))
latestVersion=$((latestVersion))
if [ $version == $latestVersion ]; then
    python3 /etc/chocolate/app.py
    exit 0
elif [ $latestVersion > $version ]; then
    echo "You are running an old version of Chocolate"
    read -p "Do you want to update? [y/n] " updating
    echo
    if [[ $updating =~ ^[Yy]$ ]]; then
        echo "Updating..."
        sudo wget -q -O install.sh 'https://raw.githubusercontent.com/ChocolateApp/ChocolateInstallLinux/main/install.sh'
        #clear all /etc/chocolate files except config.ini, database.db
        rm -rf /etc/chocolate/static
        rm -rf /etc/chocolate/templates
        rm -rf /etc/chocolate/app.py
        rm -rf /etc/chocolate/start.sh
        rm -rf /etc/chocolate/.gitignore
        rm -rf /etc/chocolate/rpc.py
        rm -rf /etc/chocolate/.git
        rm -rf /etc/chocolate/requirements.txt
        bash /install.sh
        rm install.sh
    fi
fi
exit 0