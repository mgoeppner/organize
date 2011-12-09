#! /usr/bin/env bash
# organize
# Sorts your home directory

HOMEDIR=~

# Error messages
ERR_CONF='Config folder could not be found or created'
ERR_CONF_FILE='Config file could not be found or created'
ERR_CONF_LOAD='Config file could not be loaded'
ERR_XDG='XDG directories do not exist and could not be created, please create them and try again'
ERR_SORT_MOVE='File could not be moved, operation aborted'
ERR_SORT_LINK='File could not be symlinked, operation aborted'

# Check if command was successful
function check_sanity
{
	if [ ! "$?" = "0" ]; then
		echo $1
		exit 1		
	fi	
}

# Configuration
if [ ! -d "$XDG_CONFIG_HOME/organize" ]; then
	
	# Make directory
	mkdir "$XDG_CONFIG_HOME/organize"
	check_sanity $ERR_CONF

	if [ ! -e "$XDG_CONFIG_HOME/organize/organize.conf" ]; then
	
		# Create file
		touch "$XDG_CONFIG_HOME/organize/organize.conf"
		check_sanity $ERR_CONF_FILE

		# Write default contents
		echo -e 'PICTURE_DIR="$HOMEDIR/Pictures"\nVIDEO_DIR="$HOMEDIR/Videos"\nMUSIC_DIR="$HOMEDIR/Music"\nDOCUMENT_DIR="$HOMEDIR/Documents"\n\nPICTURE_TYPES="gif;jpg;jpeg;png;tiff;bmp;svg;psd;xcf"\nVIDEO_TYPES="mp4;avi;ovg;divx;3g2;3gp;mkv;mov"\nMUSIC_TYPES="mp3;ogg;wav;aac;flac;m4a"\nDOCUMENT_TYPES="doc;docx;xls;xlsx;ppt;pptx;odt;ods;odp"\n' > "$XDG_CONFIG_HOME/organize/organize.conf"
		check_sanity $ERR_CONF_FILE	
	fi				
fi

source "$HOMEDIR/.config/organize/organize.conf"
check_sanity $ERR_CONF_LOAD

# Folders to organize
declare -a target_folders=( $HOMEDIR "$HOMEDIR/Downloads" )

# Folders to sort to
declare -a sorted_folders=( $PICTURE_DIR $VIDEO_DIR $MUSIC_DIR $DOCUMENT_DIR )

# File types to sort
declare -a sort_type=( $PICTURE_TYPES $VIDEO_TYPES $MUSIC_TYPES $DOCUMENT_TYPES )

# Sorting function
function sort_folder
{
	# what is being sorted this pass

	declare -a exts=($(echo $1 | tr ";" "\n"))

	for c in "${exts[@]}"
	do
		# Handle whitespace
		OLDIFS=$IFS
		IFS=$(echo -en "\n\b")

		# Get matched files
		files=($(find $2 -maxdepth 1 -name "*.$c" -type f))

		IFS=$OLDIFS
		
		for i in "${files[@]}"
		do
			# Move file
			if [ $DO_MOVE = true ]; then
				echo "Moving $i to ${sorted_folders[$3]}..."
				mv "$i" "${sorted_folders[$3]}"
				check_sanity $ERR_SORT_MOVE
			else
				echo "$i will be moved to ${sorted_folders[$3]}..."	
			fi

			# Symlink file in original directory
			if [ $DO_SYMLINK = true ]; then
				echo "Making symlink for $i..."
				ln -s "${sorted_folders[$3]}/`basename "$i"`" "$2"
				check_sanity $ERR_SORT_LINK
			fi
		done
	done
}

# Make sure directories exist

if [ ! -d "$HOMEDIR/Downloads" ]; then
	mkdir "$HOMEDIR/Downloads"
fi

for e in "${sorted_folders[@]}"
do
	
	if [ ! -d "$e" ]; then
		mkdir "$e"
		check_sanity $ERR_XDG					
	fi

done

# change to the current user's home directory
cd $HOMEDIR

# Parse command line arguments
DO_SYMLINK=true
DO_MOVE=true

while getopts ":nd" opt; do
	case $opt in
		n)
			DO_SYMLINK=false >&2
			echo "Symlinking is off..."
		;;
		d)
			DO_SYMLINK=false >&2
			DO_MOVE=false >&2
			echo -e "\n!!!!!DRY RUN ONLY!!!!!"
			echo "No files will be moved or symlinked!"
			echo -e "!!!!!DRY RUN ONLY!!!!!\n"
		;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			exit 1
		;;
	esac
done

echo "Orginization started..."

for f in "${target_folders[@]}"
do
	echo $f
	F_ITERATOR=0
	for t in "${sort_type[@]}"
	do
		sort_folder $t $f $F_ITERATOR
		F_ITERATOR=$[F_ITERATOR+1]
	done
done

echo "Orginization completed!"

exit 0
