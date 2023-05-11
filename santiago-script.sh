#!/bin/bash
################################################################
#Fes un shellscript que sigui un menú per crear usuaris, grups i afegir usuaris ja existents a grups. 
################################################################

if (( $# > 0)) ; then
    echo -e "Aquest script no accepta parámetres."
    exit 2
fi
while true
do
    echo -e "1)Crear usuari\n2)Crear Grup\n3)Afegir usuari al grup\n4)Sortir"
    read -p "Selecciona una opció: " OPCIO
    if [[ $OPCIO -eq 1 ]] ; then
        read -p "Nom de l'usuari? " USUARI
        sudo adduser $USUARI
    elif [[ $OPCIO -eq 2 ]] ; then
        read -p "Nom del grup? " GRUP
        sudo addgroup $GRUP
    elif [[ $OPCIO -eq 3 ]] ; then
        read -p "Nom del usuari a agregar al grup? " USUARI_GRUP
        read -p "Nom del grup al que agregar l'usuari? " GRUP_USUARI
        sudo usermod -aG $GRUP_USUARI $USUARI_GRUP
        echo -e "usuari $USUARI_GRUP agregat al grup $GRUP_USUARI"
    elif [[ $OPCIO -eq 4 ]] ; then
        echo -e "¡Grácies per utilitzar el meu script, adeu!\n"
        exit 0
    else  
        echo -e "Ninguna opció seleccionada!\nHas d'introduïr el número identificant de alguna de les opcións..."        
    fi
done