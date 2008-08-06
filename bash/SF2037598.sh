#!/bin/bash

tempvar=$IFS
IFS="
"
for FILE in $(find .);
do
if [ ! -d $FILE ]
then
NEWFILE=`echo $FILE | sed -e 's/\ä/ae/g'`;
NEWFILE=`echo $NEWFILE | sed -e 's/\ö/oe/g'`;
NEWFILE=`echo $NEWFILE | sed -e 's/\ü/ue/g'`;
NEWFILE=`echo $NEWFILE | sed -e 's/\Ä/Ae/g'`;
NEWFILE=`echo $NEWFILE | sed -e 's/\Ö/Oe/g'`;
NEWFILE=`echo $NEWFILE | sed -e 's/\Ü/Ue/g'`;
if [ $FILE != $NEWFILE ]
then
mv $FILE $NEWFILE;
fi;
fi;
done;
IFS=$tempvar;
