# Disc Scripts

A set of scripts to automatically rip and transcode DVD's and CD's.

## Features

###### DVD's

Rip DVD to raw format suitable for transcoding.

###### CD's

Rip to uncompressed .WAV in  highest possible quality. 

## Usage

1. Make a new folder. 
2. Clone this repository within this new folder ( /.../yourfolder/disc-scripts/ )
3. Edit the "cd-drive" and "dvd-drive" files with the path to your cd and dvd drives. (Usually the same at /dev/sr0)
4. Run one of the scripts (dvd.sh or cd.sh) at a time, unless you have two separate drives.
5. The drive will eject if it has completed ripping, or if it has already been ripped. Status messages will appear on the screen.
6. You've ripped a DVD/CD!

## Troubleshooting

###### Errorcodes

0001DVD: The script could not check if there was a DVD inserted. Add a "set -x" flag below the shebang and post the output in an issue.
