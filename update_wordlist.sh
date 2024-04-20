#!/bin/bash
#this script updates old known wordlists to a fressher version adding the more recent years based on the existing words present in the wordlist

file=$1
cat $file | sed -E 's/20[0-9]{2}/2022/g' > 2022.txt
cat $file | sed -E 's/20[0-9]{2}/2023/g' > 2023.txt
cat $file | sed -E 's/20[0-9]{2}/2024/g' > 2024.txt
find ./ -name "20*.txt" | xargs cat >> $file
cat $file | sort -u | sponge $file
rm 2023.txt
rm 2022.txt
rm 2024.txt
