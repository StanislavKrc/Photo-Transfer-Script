#!/bin/bash
PDIR="$1"
TDIR="$2"
TMP="$1,$2"
#prints help
help () {
    echo -e "\nFormat is:\n
    phonedwnl.sh source target 'transfer type arguments array'
    phonedwnl.sh source target 'transfer type arguments array' -new keyword filename
    phonedwnl.sh preset presetlist 'transfer type arguments array'
    phonedwnl.sh -h"
    echo -e "\nFlags: \n"
    echo "-h                                   : help, writes help once then ends script"
    echo "-p                                   : copies photo folder"
    echo "-f                                   : copies facebook folder"
    echo "-w                                   : copies whatsapp folder"
    echo "-a                                   : copies all listed above"
    echo "-add [keyword] [filename]            : adds keyword to existing one,if one exists,transfer happens but list doesnt change"
    echo "-new [keyword] [filename] [filetype] : creates new keyword in list of keywords,or adds keyword to existing one,if one exists,transfer happens but list doesnt change"
    exit 0
}
#checks if first argument is given,and if both given directories exists
#in case they do,move to transfer type arguments'
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
                GetPath "$@"
            fi
            #directories exists
        else
            #new list?
            shift 2
            argParser "$@"
        fi
    fi
    
}

#if -new argument is given,scripts creates new file of given type and adds new keyword to it
newKeyword () {
    newFile="$3.$4"
    touch "$newFile"
    echo "$2,$PDIR,$TDIR" >> $newFile
}

#if -add argument is given,script checks that file exists and given keyword is unique
addKeyword () {
    #file exists
    if [ -f "$3" ];
    then
        filter="$2"
        in=$(cat "$3")
        count=$(echo "$in" | awk -F ',' -v preset=$filter 'BEGIN {count=0;}  { if ($1 == preset) count+=1} END {print count}')
        if [ "$count" == "0" ];
        then
            echo "$2,$PDIR,$TDIR" >> $3
        else
            echo -e "\n\tWarning: Keyword already exists,please type a new one\n"
        fi
    else
        echo -e "\n\t\tWarning: File doesnt exist,keyword wasnt saved\n"
    fi
}

#check got non existent directory,looks for name in Directories.log file
GetPath () {
    #open file in variable
    in=$(cat "$TDIR")
    #auxiliary variable for filtering
    filter="$PDIR"
    #variable used for catching multiple keyword usage
    count=$(echo "$in" | awk -F ',' -v preset=$filter 'BEGIN {count=0;}  { if ($1 == preset) count+=1} END {print count}')
    if [ "$count" != "1" ]
    then
        echo -e "\n\t\tError: Keyword is not present,or used multiple times\n"
        exit 1
    fi
    #directory path rewriting
    PDIR=$(echo "$in" | awk -F ',' -v preset=$filter '{if($1 == preset){print $2}}')
    TDIR=$(echo "$in" | awk -F ',' -v preset=$filter '{if($1 == preset){print $3}}')
    #do they exist?
    if [ ! -d "$PDIR" ] || [ ! -d "$TDIR" ];
    then
        #they dont and keyword wasnt found
        if [ "$PDIR" == "" ] || [ "$TDIR" == " " ];
        then
            echo -e "\n\t\tError: Given faulty parameter"
            exit 1
        #they dont but directory is faulty
        else
            echo -e "\n\t\tError: Directory wasnt found"
            echo -e "\n\t\tGiven directories:\n\t\t$PDIR\n\t\t$TDIR"
            exit 1
        fi
    #they do
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

        -add)
            addKeyword "$@"
            shift 2
        ;;

        -new)
            newKeyword "$@"
            shift 3
        ;;
        *)
            echo "$1"
            echo -e "\n\t\t Error:Unknown command\n"
            exit 1
        ;;
        
    esac
    shift
    if [ "$1" != "" ]
    then
        argParser "$@"
    else
        echo -e "\n\tAll done,Transfer executed succesfully.\n"
        exit 0
    fi
}
check "$@"