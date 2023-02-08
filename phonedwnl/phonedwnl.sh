#!/bin/bash
PDIR="$1"
TDIR="$2"
#prints help
help () {
    echo -e "\nFormat is: \n
        phonedwnl.sh source target 'transfer type arguments array'
        phonedwnl.sh preset presetlist 'transfer type arguments array'
    phonedwnl.sh -h"
    echo -e "\nFlags: \n"
    echo "-h : help, writes help once then ends script"
    echo "-p : copies photo folder"
    echo "-f : copies facebook folder"
    echo "-w : copies whatsapp folder"
    echo "-a : copies all listed above"
    exit 0
}
: ' checks if first argument is given,and if both given directories exists
in case they do,move to transfer type arguments'
check () {
    #argument is given
    if [ "$PDIR" != "" ]
    then
        #directories doesnt exists
        if [ ! -d "$PDIR" ] || [ ! -d "$TDIR" ];
        then
            #first argument is -h
            if [ "$1" = "-h" ]
            then
                help
                #first argument is something else
            else
                : 'echo -e "\n\t\tError: Directory wasnt found"
                echo -e "\n\t\tGiven directories:\n\t\t$PDIR\n\t\t$TDIR"
                exit 1'
                GetPath "$@"
            fi
            #directories exists
        else
            shift 2
            argParser "$@"
        fi
    fi
    
}

#check got non existent directory,looks for name in Directories.log file
GetPath () {
    in=$(cat "$TDIR")
    filter="$PDIR"
    PDIR=$(echo "$in" | awk -F ',' -v preset=$filter '{if($1 == preset){print $2}}')
    TDIR=$(echo "$in" | awk -F ',' -v preset=$filter '{if($1 == preset){print $3}}')
    if [ ! -d "$PDIR" ] || [ ! -d "$TDIR" ];
    then
        echo -e "\n\t\tError: Directory wasnt found"
        echo -e "\n\t\tGiven directories:\n\t\t$PDIR\n\t\t$TDIR"
        exit 1
    else
        shift 2
        argParser "$@"
    fi
}

#adds new subdirectory for TDIR based on current date
newDir () {
    NDIR="$TDIR"/`date +%d.%m.%Y`
    if [ ! -d "$NDIR" ];
    then
        mkdir "$NDIR"
    fi
}
#copies "all" phone subdirectories
copyAll () {
    newDir
    cp -R "${PDIR}/facebook/"* "$NDIR"
    cp -R "${PDIR}/photo/"* "$NDIR"
    cp -R "${PDIR}/whatsapp/"* "$NDIR"
}

#copies photo subdirecotry
copyPhoto () {
    newDir
    cp -R "${PDIR}/photo/"* "$NDIR"
}

#copies whatsapp subdirecotry
copyWA () {
    newDir
    cp -R "${PDIR}/whatsapp/"* "$NDIR"
}

#copies facebook subdirecotry
copyFB () {
    newDir
    cp -R "${PDIR}/facebook/"* "$NDIR"
}

#switch function used to process transfer type arguments
argParser () {
    case $1 in
        
        -a)
            copyAll
        ;;
        
        -p)
            copyPhoto
        ;;
        
        -f)
            copyFB
        ;;
        
        -w)
            copyWA
        ;;
        
        *)
            echo -e "\n\t\t Error:Unknown command\n"
        ;;
        
    esac
    shift
    if [ "$1" != "" ]
    then
        argParser "$@"
    else
        echo -e "\n\tAll done,Script executed succesfully.\n"
        exit 0
    fi
}
check "$@"