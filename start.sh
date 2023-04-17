#!/bin/bash

# Fonction pour arrêter les processus et nettoyer les ressources
function clean_up {
    echo "Arrêt des processus Node et Python"
    node_pid=$(pidof node)
    echo $node_pid
    python_pid=$(pidof python)
    echo $python_pid
    #print the command
    echo "kill -9 $node_pid $python_pid"
    kill -9 $node_pid $python_pid
    exit 0
}

# Enregistrement de la fonction clean_up comme gestionnaire de signal pour SIGINT

# Démarrage des processus Node et Python
cd /etc/chocolate/front
sudo npm start &

cd /etc/chocolate/back
sudo python app.py &
# Lorsque l'utilisateur appuie sur Ctrl + C, le script appelle la fonction clean_up
trap clean_up SIGINT

# Attente indéfinie, le programme est en cours d'exécution jusqu'à ce que le l'utilisateur appuie sur Ctrl + C
while true; do
    sleep 1
done
