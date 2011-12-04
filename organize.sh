#! /bin/bash
# organize
# Sorts your home directory

HOMEDIR=~

declare -a target_folders=( $HOMEDIR $HOMEDIR"/Downloads" )
declare -a sorted_folders=( $HOMEDIR"/Pictures" $HOMEDIR"/Videos" $HOMEDIR"/Music" $HOMEDIR"/Documents" )

declare -a sort_type=( 'gif;jpg;jpeg;png;tiff;bmp;svg;psd;xcf' 'mp4;avi' 'mp3;ogg;wav;aac;flac' 'doc;docx;xls;xlsx;ppt;pptx;odt;ods;odp' )

function sort_folder
{
	echo "Sorting " $2
	# what is being sorted this pass

	declare -a exts=($(echo $1 | tr ";" "\n"))

	for c in "${exts[@]}"
	do
		# Move all the matched files
		echo "Moving files..."
		files=($(find $2 -maxdepth 1 -name "*.$c" -type f))
		echo "${files[@]}"
		#symlink the files in the orginal directory
		for i in "${files[@]}"
		do
			echo "Moving $i..."
			mv $i "${sorted_folders[$3]}"
			echo "Making symlink for $i..."
			ln -s "${sorted_folders[$3]}"/$(basename $i) $2
		done
	done
}

# change to the current user's home directory
cd ~

# Lazy, fix this
ITERATOR=0

# start sorting!
echo "Sorting now..."
for t in "${sort_type[@]}"
do
	echo "these types: $t"

	for f in "${target_folders[@]}"
	do
		echo $f
		sort_folder $t $f $ITERATOR
		echo $ITERATOR
	done
	ITERATOR=$[ITERATOR+1]
done

echo "All done!"

exit 0
