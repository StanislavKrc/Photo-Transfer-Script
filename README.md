# Photo-Transfer-Script
Bash script supposed to transfer photos and videos from android phone,works for any directory with subdirectories named facebook,whatsapp and photo
Each transfer either creates or writes into subdirectory named after current date

TODO:In case of new manually loaded directories asks user if he wishes to add directories to new or existing list of directories,fix issue with more than 1 line with same keyword, -a transfers entire gallery

Script excpects one of following formats:
1) phonedwnl.sh source target 'transfer type arguments array'
  where source is phone directory and target is destination
2) phonedwnl.sh preset presetlist 'transfer type arguments array'
  where preset is keyword with data,presetlist file in format preset,source,target
3) phonedwnl.sh -h
  prints help

