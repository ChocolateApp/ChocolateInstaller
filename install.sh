pythonRequirement="https://raw.githubusercontent.com/ChocolateApp/Chocolate/main/requirements.txt"
#check if pip3 is installed
if ! [ -x "$(command -v pip3)" ]; then
    sudo apt-get install python3-pip
    pip3 install -r $pythonRequirement
else
    pip3 install -r $pythonRequirement
fi
git clone https://github.com/Impre-visible/Chocolate.git
if [ ! -f /usr/bin/ffmpeg ]; then
    echo "ffmpeg is not installed. Do you want to install it? (y/n)"
    read install
    if [ "$install" = "y" ]; then
        sudo apt update
        sudo apt install ffmpeg
        sudo ln -s /usr/bin/ffmpeg /usr/local/bin/ffmpeg
    fi
fi

cd Chocolate/

cat > run.sh << "EOF"
OUTPUT="$(git diff)"
if [ "${OUTPUT}" != "" ]; then
    echo "The code is not the latest version. Do you want to update the code? (y/n)"
    read update
    if [ "$update" == "y" ]; then
        git pull
        ./run.sh
    fi
else
    python3 main.py
fi
EOF


chmod +x run.sh
