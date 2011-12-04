#! /bin/bash
# organize
# Sorts your home directory

HOMEDIR=~

declare -a target_folders=( $HOMEDIR "$HOMEDIR/Downloads" )
declare -a sorted_folders=( "$HOMEDIR/Pictures" "$HOMEDIR/Videos" "$HOMEDIR/Music" "$HOMEDIR/Documents" )

declare -a sort_type=( 'gif;jpg;jpeg;png;tiff;bmp;svg;psd;xcf' 'mp4;avi' 'mp3;ogg;wav;aac;flac;m4a' 'doc;docx;xls;xlsx;ppt;pptx;odt;ods;odp' )

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

			# Symlink file in original directory
			echo "Making symlink for $i..."
			ln -s "${sorted_folders[$3]}"/$(basename $i) $2
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
	fi

done

# change to the current user's home directory
cd $HOMEDIR

echo "Sorting started..."
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

echo "Sorting completed!"

exit 0
