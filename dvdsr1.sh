#!/bin/env bash

    #Slow down the drive before anything else
    eject -x 12 /dev/sr1

    #Loop to constantly check if DVD is inserted or not
    while :; do

    inserted=$(blkid /dev/sr1 > /dev/null; echo $?)

    #Check if DVD inserted
    if [[ "$inserted" == 0 ]]; then
        sleep 0.25
        echo "Disk is inserted"
        echo "Checking if DVD is already ripped"
                    mkdir -p ../Backups/DVD/ ;:
                    currentdvd=$(pre="LABEL=";tmp=$(blkid /dev/sr1 -o export | grep LABEL=) ; echo "${tmp#"$pre"}" | tr -cd '[:alnum:]' | tr '[:upper:]' '[:lower:]')
                    dvdrips=$(dir ../Backups/DVD/ | tr -cd '[:alnum:]' | tr '[:upper:]' '[:lower:]')
                    
                        #See if current DVD has already been ripped
                        if [[ "$dvdrips" == *"$currentdvd"* ]]; then
                            echo "Already ripped."
                        else
                            echo "Not ripped, starting rip."

                            #Rip DVD
                            dvdbackup -pvMi /dev/sr1 -o ../Backups/DVD/
                        fi
                
        #Eject DVD after Rip
        eject /dev/sr1
        sleep 2

    #Check if DVD isn't inserted
    elif [[ "$inserted" == 2 ]]; then
        
        #Eject DVD so user can insert
        echo "Disk is not inserted"
        echo "Ejecting drive for insertion"
        echo "Waiting 5 seconds before checking again"
        eject /dev/sr1
        sleep 5
        echo

    #Exit if unexpected error
    else 

        echo "Unexpected error, exiting"
        echo "Please open a Github issue."
        echo "Errorcode 0001DVD"
        eject -n /dev/sr1
        sleep 5
        echo
        exit
    fi
    done
