#!/bin/bash
#################################################################################################
##Shellscript que sigui un menú per crear usuaris, grups i afegir usuaris ja existents a grups.## 
#################################################################################################

# L'escript primer mira si li han pasat cap argument. Si és el cas, para l'escript i s'ho comunica a l'usuari. 

if (( $# > 0)) ; then
    echo -e "Aquest script no accepta parámetres."
    exit 2
fi

# Obre un bucle infiniti. que per cada volta preguntará un número per escollir una de les 4 opcións presentades y del cual tansols es podrá sortir escollint la opció 4.
while true
do
    echo -e "1)Crear usuari\n2)Crear Grup\n3)Afegir usuari al grup\n4)Sortir"
    read -p "Selecciona una opció: " OPCIO

    if [[ $OPCIO -eq 1 ]] ; then
        read -p "Nom de l'usuari? " USUARI
        # Si l'usuari conté una majuscula, adduser dona error, per tant miro si conté una majuscula i ja faig que no afegeixi l'usuari descrit i s'ho comuniqui a l'usuari/client i torni al menú
        ## Si l'usuari no existeix el crea, i si si que existeix avisa al usuari i torna al menú
        if [[ "$USUARI" =~ [A-Z] ]]; then
            echo -e "Un usuari UNIX no pot utilitzar majúscules, escriu el nom de l'usuari a crear sense aquestes.\n"
        elif ! id -u $USUARI > /dev/null 2>&1; then
            sudo adduser $USUARI
        else
            echo -e "\nL'usuari especificat ja existeix, siusplau, seleccioneu un altre.\n"
        fi
    
    elif [[ $OPCIO -eq 2 ]] ; then
        read -p "Nom del grup? " GRUP
        # Si el grup conté una majuscula, addgroup dona error, per tant miro si conté una majuscula i ja faig que no afegeixi el grup descrit i s'ho comuniqui a l'usuari i torni al menú
        ## Si el grup no existeix el crea, i si si que existeix avisa al usuari i torna al menú
        if [ $(getent group $GRUP) ]; then
            echo -e "El grup $GRUP ja existeix, siusplau, especifiqueu un altre grup.\n"
        elif [[ "$USUARI" =~ [A-Z] ]]; then
            echo -e "Un grup UNIX no pot utilitzar majúscules, escriu el nom del grup a crear sense aquestes.\n"
        else
            sudo addgroup $GRUP
        fi
    
    elif [[ $OPCIO -eq 3 ]] ; then
        read -p "Nom del usuari a agregar al grup? " USUARI_GRUP
        read -p "Nom del grup al que agregar l'usuari? " GRUP_USUARI
        # Mira si el usuari i grup especificat existeixen, i si és que si agrega el usuari al grup. Si algun dels dos no existeix ho comunica i torna al menú
        if ! id -u $USUARI_GRUP > /dev/null 2>&1; then 
            echo -e "\nEl usuari especificat no existeix, crea-lo avans o especifica un que ja existeixi. \n"
        elif ! grep -q -E "^$GRUP_USUARI:" /etc/group ; then
            echo -e "El grup especificat no existeix, crea-lo avans o especifica un que ja  existeixi. \n"
        else
            sudo usermod -aG $GRUP_USUARI $USUARI_GRUP
            echo -e "usuari $USUARI_GRUP agregat al grup $GRUP_USUARI"
        fi
    
    elif [[ $OPCIO -eq 4 ]] ; then
        # Surt del escript donant les gracies per el seu ús
        echo -e "¡Grácies per utilitzar el meu script, adeu!\n"
        exit 0
    else  
        # Control de errors per si no és selecciona cap opcio, una lletra o un número que no correpongi a cap de les opcions
        echo -e "Ninguna opció seleccionada!\nHas d'introduïr el número identificant de alguna de les opcións..."        
    fi
done