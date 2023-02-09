# Photo-Transfer-Script
Bash script supposed to transfer photos and videos from android phone,works for any directory with subdirectories named facebook,whatsapp and photo
Each transfer either creates or writes into subdirectory named after current date

TODO:Live testing on Windows and linux computers

Script excpects one of following formats:
1) phonedwnl.sh source target 'transfer type arguments array'
  where source is phone directory and target is destination

2) phonedwnl.sh preset presetlist 'transfer type arguments array'
  where preset is keyword with data,presetlist file in format preset,source,target

3) phonedwnl.sh source target 'transfer type arguments array'/"" -new keyword filename 'type of file'
  creates filename.'type of file' and stores directories path as new keyword,be cautious with type of file,dont start with .

4) phonedwnl.sh source target 'transfer type arguments array'/"" -add keyword filename
  adds paths to directories as new keyword into filename,doesnt do anything if keyword exist

5) phonedwnl.sh -h
  prints help