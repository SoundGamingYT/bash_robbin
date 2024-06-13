#!/usr/bin/bash

PS3='Hallo! Wat wil je doen: '
options=("Een gebruiker aanmaken" "Een som uitrekenen" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Een gebruiker aanmaken")
            # Check als de gebruiker sudo rechten heeft
            # anders vraag om het sudo wachtwoord
            if [ $(id -u) = "0" ]; then
                # De input van de gebruikersnaam
                # voor de nieuwe gebruiker
                echo -n "Gebruikersnaam voor nieuwe gebruiker: "
                read username
                # Check als de gebruikersnaam als bestaat
                # in het bestand /etc/passwd
                getent passwd $username >> /dev/null

                # Check als de gebruikersnaam speciale tekens bevat
                # Als het bevat, dan niet toestaan
                while ! [[ "$username" =~ ^[a-z]+$ ]]; do
                    echo -e "Deze gebruikersnaam is niet toegestaan!"
                    echo -e "Voer een andere naam in: "
                    read username
                    # Check als de gebruikersnaam als bestaat
                    # in het bestand /etc/passwd
                    getent passwd $username >> /dev/null
                done

                # Als de gebruikersnaam al bestaat, blijf dan
                # vragen om een andere naam die niet bestaat
                while [[ $? -eq 0 ]]; do
                    echo -e "Gebruikersnaam bestaat al!"
                    echo -e "Voer een andere gebruikersnaam in: "
                    read username
                    getent passwd $username >> /dev/null
                done

                # Voeg de gebruiker toe met een home folder en maak
                # tegelijk een groep aan met dezelfde naam
                useradd -m -U "$username"

                # Invoeren van groepnaam
                echo -n "Voer een groepnaam in: "
                read group

                # Check als groepnaam van de input al
                # bestaat in het bestand /etc/group
                getent group $group >> /dev/null

                # Check als de groepnaam speciale tekens bevat
                # Als het bevat, dan niet toestaan
                while [[ $? -eq 0 ]]; do
                    echo -e "Groep bestaat al!"
                    echo -e "Voer een andere groep in: "
                    read group
                    getent group $group >> /dev/null
                done

                # Als de groepnaam al bestaat, blijf dan
                # vragen om een andere naam die niet bestaat
                while ! [[ "$group" =~ ^[a-z]+$ ]]; do
                    echo -e "Deze groepnaam is niet toegestaan!"
                    echo -e "Voer een andere groepnaam in: "
                    read group
                    getent passwd $group >> /dev/null
                done

                groupadd "$group"
            else
                # Vraag om sudo wachtwoord als gebruiker
                # geen root is. Vervolgens de stappen volgen van hierboven
                echo "Je bent geen root"
                sudo echo "Je bent nu root"
                echo -n "Gebruikersnaam voor nieuwe gebruiker: "
                read username
                getent passwd $username >> /dev/null

                while ! [[ "$username" =~ ^[a-z]+$ ]]; do
                    echo -e "Deze gebruikersnaam is niet toegestaan!"
                    echo -e "Voer een andere naam in: "
                    read username
                    getent passwd $username >> /dev/null
                done

                while [[ $? -eq 0 ]]; do
                    echo -e "Gebruikersnaam bestaat al!"
                    echo -e "Voer een andere gebruikersnaam in: "
                    read username
                    getent passwd $username >> /dev/null
                done

                sudo useradd -m -U "$username"

                # Groep input
                echo -n "Voer een groepnaam in: "
                read group

                getent group $group >> /dev/null

                while [[ $? -eq 0 ]]; do
                    echo -e "Groep bestaat al!"
                    echo -e "Voer een andere groep in: "
                    read group
                    getent group $group >> /dev/null
                done

                while ! [[ "$group" =~ ^[a-z]+$ ]]; do
                    echo -e "Deze groepnaam is niet toegestaan!"
                    echo -e "Voer een andere groepnaam in: "
                    read group
                    getent passwd $group >> /dev/null
                done

                sudo groupadd "$group"
            fi
            ;;
        "Een som uitrekenen")
            echo "Voer het eerste nummer in: "
            read a
            # Check if input A is a number
            while ! [[ "$a" =~ ^[0-9]+$ ]]
            do
            echo "Dat is geen nummer! Voer het eerste nummer in: "
            read a
            done            
            echo "Voer het tweede nummer in: "
            read b
            # Check if input B is a number
            while ! [[ "$b" =~ ^[0-9]+$ ]]
            do
            echo "Dat is geen nummer! Voer het tweede nummer in: "
            read b
            done
                # Give user a choice
                echo "Kies een keuze: "
                echo "1. Toevoegen"
                echo "2. Aftrekken"
                echo "3. Vermenigvuldigen"
                echo "4. Delen"
                read ch
                # Check if choice is a number between 1-4 otherwise
                # repeat question till valid choice is made
                while ! [[ "$ch" =~ ^[0-4] ]]
                do
                echo "Dit is geen keuze! Kies een keuze: "
                echo "1. Toevoegen"
                echo "2. Aftrekken"
                echo "3. Vermenigvuldigen"
                echo "4. Delen"
                read ch
                done
                # Switch Case to perform
                # calculator operations
                case $ch in
                    1)res=`echo $a + $b | bc`
                    ;;
                    2)res=`echo $a - $b | bc`
                    ;;
                    3)res=`echo $a \* $b | bc`
                    ;;
                    4)res=`echo "scale=2; $a / $b" | bc`
                    ;;
                    esac
                    echo "Resultaat: $res"
            ;;
        "Quit")
            break
            ;;
        *) echo "Optie $REPLY is geen geldige optie";;
    esac
    echo "1) ${options[0]}"
    echo "2) ${options[1]}"
    echo "3) ${options[2]}"
done