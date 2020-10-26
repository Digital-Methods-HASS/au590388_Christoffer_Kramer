#Lav en sorteret liste, hvor gentagelser er fjernet
#Brug  bash species.sh your_file

for filename in $@
do

	cut -d, -f 2 "$filename" | sort | uniq

done

