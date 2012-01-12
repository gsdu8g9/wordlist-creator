#!/bin/bash --
#
# wordlist creator v1.0b
# usage wordlist.sh [url] [output]
# if output file exists, merge files
#

if [ "$1" -a "$2" ]
then
	echo ">> $(date +'%T') - Starting to downlad $1. This can take a long time..."

	#download websites recursively to ./temp/ directory, skip non-text files
	wget -r -l 2 --random-wait --user-agent='Mozilla/5.0' --quiet -R .jpg,.jpeg,.png,.gif,.bmp,.flv,.js,.avi,.wmv,.mp3,.zip,.css,.pdf,.iso,.tar.gz,.rar,.swf,.PNG,.GIF,.JPG,.JPEG,.BMP -P "./temp/" $1

	echo ">> $(date +'%T') - Finished downloading, creating wordlist..."

	#rescursively search for words that match out criteria in all files, 8+ chars, alpha
	page=`grep '' -R "./temp/" | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | tr " " "\n" | tr '[:upper:]' '[:lower:]' | sed -e '/[^a-zA-Z]/d' -e '/^.\{9,25\}$/!d' | sort -u`;

	echo "`date +"%T"` - Wordlist created!"
	echo ">> Fetched lines: $(echo "$page" | wc -l)"

	if [ -f "$2" ]; then
		echo ">> File $2 already exists, merging files!"
		echo "$page" >> "$2";
		cat "$2" | sort -u -o "$2";
		echo ">> Wordlist merged with $2 and now has $(cat "$2" | wc -l) lines!";
	else
		echo "$page" > "$2"
		echo ">> Wordlist saved to $2!"
	fi

	#remove temporaray website directory
	rm -rf "./temp/"
else
	echo ">> Error: Parameter URL required!"
	echo ">> Example: $0 https://www.iana.org/domains/example/ ./wordlist.txt"
fi
