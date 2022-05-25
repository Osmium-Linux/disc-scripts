#!/bin/env bash

    # Set exit on error
    set -e

    # Functions are here

    # Have user input dvd device, returns whatever is input.
    # Uses the global variable dvddevice.
    deviceid ()
    {
        echo "Input the DVD Device (usually /dev/sr0)"
        read -r dvddevice
        echo "$dvddevice"
    }

    # Ask user if they want to slow drive to prevent noise
    # Does not return a value, just slows the drive if they say y.
    # Inputs are y / n.
    slow () {
        echo "Do you wish to slow the DVD drive to reduce noise? (Y/N)"
        read -r slowvalue
        if [[ $slowvalue == y||$slowvalue == Y ]]; then
            eject -x 12 "${dvddevice}"
            hdparm -E12 "${dvddevice}"
            printf "To reset this, run either\neject -x 0 %s ${dvddevice}\nor\nhdparm -E0 %s ${dvddevice}\n"
        elif [[ $slowvalue == n||$slowvalue == N ]]; then
            printf "Not slowing drive."
        else
            printf "Please input Y or N."
            slow
        fi
            
    }

    # Checks if a DVD is inserted, then returns a value. Possible values are true, false, or error.
    inserted () {
    if blkid "${dvddevice}"; then
        echo true
    elif [[ $(blkid "${dvddevice}" > /dev/null; echo $?) == 2 ]]; then
        echo false
    else
        echo error
    fi
    } 

    # Asks the user to input the directory they wish the backups to be stored in.
    # Uses the global variable backupdir.
    store () {
        printf "Input the directory you wish the backups to be stored in.\nThis can be relative or absolute."
        read -r backupdir
        if [ -d backupdir ]; then
            printf "Backup directory exists."
        else 
            printf "Backup directory does not exist, creating..."
            mkdir -p backupdir
        fi
        echo backupdir
    }

    # Check if DVD is already ripped. Possible returns are true or false. May return false positives.
    ripped () {
        local currentdvd
        currentdvd=$(pre="LABEL=";tmp=$(blkid "${dvddevice}" -o export | grep LABEL=) ; echo "${tmp#"$pre"}" | tr -cd '[:alnum:]' | tr '[:upper:]' '[:lower:]')
        local dvdrips
        dvdrips=$(dir backupdir | tr -cd '[:alnum:]' | tr '[:upper:]' '[:lower:]')
        if [[ "$dvdrips" == *"$currentdvd"* ]]; then
            echo true
        else
            echo false
        fi
    }

    # Eject DVD Device
    eject () {
        command eject "${dvddevice}"
    }

    # Rip the DVD
    rip () {
        dvdbackup -pMi "${dvddevice}" -o "$backupdir"
    }

    main () {
        deviceid
        slow
        while :;do
        if [[ $(inserted) != true ]]; then
            echo "Please insert a DVD into $dvddevice."
            echo "Waiting 5 seconds before checking again..."
            eject
            sleep 5
            clear
        else
            if [[ $(ripped) == true ]]; then
                printf "Already ripped, please insert a new dvd\nEjecting drive..."
                clear
            else 
                rip
                echo "Rip completed, ejecting drive..."
            fi
            eject
        fi
        done
    }

main