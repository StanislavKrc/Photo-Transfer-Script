#!/bin/bash
PDIR="$1"
TDIR="$2"
help () {
    echo -e "\nFormat is: phonedwnl.sh source/help target flags"
    echo -e "\nFlags: \n"
    echo "-h : help, writes help once then ends script"
    echo "-p : copies photo folder"
    echo "-f : copies facebook folder"
    echo "-w : copies whatsapp folder"
    echo "-a : copies all listed above"
    exit 0 
}
check () {

    if [ "$PDIR" != "" ]
    then
        if [ ! -d "$PDIR" ] || [ ! -d "$TDIR" ];
        then
            if [ "$1" = "-h" ]
            then
                help
            else
                echo -e "\n\t\tError: Directory wasnt found"
                echo -e "\n\t\tGiven directories:\n\t\t$PDIR\n\t\t$TDIR"
                exit 1
            fi
        else
            shift
            shift
            argParser "$@"
        fi
    fi
    
}
newDir () {
    NDIR="$TDIR"/`date +%d.%m.%Y`
    if [ ! -d "$NDIR" ];
    then
        mkdir "$NDIR"
    fi
}
copyAll () {
    newDir
    cp -R "${PDIR}/facebook/"* "$NDIR"
    cp -R "${PDIR}/photo/"* "$NDIR"
    cp -R "${PDIR}/whatsapp/"* "$NDIR"
}

copyPhoto () {
    newDir
    cp -R "${PDIR}/photo/"* "$NDIR"
}

copyWA () {
    newDir
    cp -R "${PDIR}/whatsapp/"* "$NDIR"
}

copyFB () {
    newDir
    cp -R "${PDIR}/facebook/"* "$NDIR"
}

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