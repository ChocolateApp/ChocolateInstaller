#!/bin/bash

version=$(crudini --get /etc/chocolate/config.ini ChocolateSettings version)
curl -s -L https://raw.githubusercontent.com/ChocolateApp/Chocolate/main/config.ini > /etc/chocolate/configTemp.ini
latestVersion=$(crudini --get /etc/chocolate/configTemp.ini ChocolateSettings version)
version=$(echo $version | tr -d '.')
latestVersion=$(echo $latestVersion | tr -d '.')
version=$((version))
latestVersion=$((latestVersion))
if [ "$version" == "$latestVersion" ]; then
    python3 /etc/chocolate/app.py
    exit 0
elif [ "$version" < "$latestVersion" ]; then
    echo "You are running an old version of Chocolate"
    read -p "Do you want to update? [y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Updating..."
        wget -s -O install.sh 'https://raw.githubusercontent.com/ChocolateApp/ChocolateInstallLinux/main/install.sh'
        bash /install.sh
        rm install.sh
    fi
fi
exit 0