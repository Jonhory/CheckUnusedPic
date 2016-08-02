
if [ ! -f UnusedPic.txt ]; then
    echo UnusedPic.txt not found
    exit 0
fi

for i in `cat UnusedPic.txt`
do
   if [ '' != '$i' ]; then
	echo rm $i
        rm -f $i
   fi 
done
