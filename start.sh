#read the version in the config.ini file
version=crudini --get /etc/chocolate/config.ini ChocolateSettings version
#download the example config.ini file
wget -O /etc/chocolate/configTemp.ini https://raw.githubusercontent.com/ChocolateApp/Chocolate/main/config.ini
latestVersion=crudini --get /etc/chocolate/configTemp.ini ChocolateSettings version
#check if the version is the same
if ! [ "$version" < "$latestVersion" ]; then
    rm /etc/chocolate/configTemp.ini
    echo "You are running an old version of Chocolate"
    #ask if the user wants to update
    read -p "Do you want to update? [y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        #update
        echo "Updating..."
        #download install.sh
        wget -O /install.sh https://raw.githubusercontent.com/ChocolateApp/ChocolateInstallLinux/main/install.sh
        #run install.sh
        sudo bash /install.sh
fi
python3 /etc/chocolate/start.py