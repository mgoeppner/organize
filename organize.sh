#! /bin/bash
# organize
# Sorts your home directory

HOMEDIR=~

ERR_XDG="XDG directories do not exist and could not be created, please create them and try again"
ERR_SORT_MOVE="File could not be moved, operation aborted"
ERR_SORT_LINK="File could not be symlinked, operation aborted"

# Folders to organize
declare -a target_folders=( $HOMEDIR "$HOMEDIR/Downloads" )

# Folders to sort to
declare -a sorted_folders=( "$HOMEDIR/Pictures" "$HOMEDIR/Videos" "$HOMEDIR/Music" "$HOMEDIR/Documents" )

# File types to sort
declare -a sort_type=( 'gif;jpg;jpeg;png;tiff;bmp;svg;psd;xcf' 'mp4;avi;ovg;divx;3g2;3gp;mkv;mov' 'mp3;ogg;wav;aac;flac;m4a' 'doc;docx;xls;xlsx;ppt;pptx;odt;ods;odp' )

# Check if command was successful
function check_sanity
{
	if [ ! "$?" = "0" ]; then
		echo $1		
		exit 1		
	fi	
}

function sort_folder
{
	# what is being sorted this pass

	declare -a exts=($(echo $1 | tr ";" "\n"))

	for c in "${exts[@]}"
	do
		# Get matched files
		files=($(find $2 -maxdepth 1 -name "*.$c" -type f))

		for i in "${files[@]}"
		do
			# Move file
			echo "Moving $i..."
			mv $i "${sorted_folders[$3]}"
			check_sanity $ERR_SORT_MOVE

			# Symlink file in original directory
			if [ $DO_SYMLINK = true ]; then
				echo "Making symlink for $i..."
				ln -s "${sorted_folders[$3]}"/$(basename $i) $2
				check_sanity $ERR_SORT_LINK
			fi
		done
	done
}


# Make sure directories exist

if [ ! -d "$HOMEDIR/Downloads" ]; then
	mkdir $HOMEDIR/Downloads
fi

for e in "${sorted_folders[@]}"
do
	
	if [ ! -d "$e" ]; then
		mkdir $e
		if [ ! "$?" = "0" ]; then
			check_sanity $ERR_XDG					
		fi
	fi

done

# change to the current user's home directory
cd $HOMEDIR

# Parse command line arguments
DO_SYMLINK=true

while getopts ":n" opt; do
	case $opt in
		n)
			DO_SYMLINK=false >&2
			echo "Symlinking is off..."
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
	ITERATOR=0
	for t in "${sort_type[@]}"
	do
		sort_folder $t $f $ITERATOR
		ITERATOR=$[ITERATOR+1]
	done
	echo $f
done

echo "Orginization completed!"

exit 0
