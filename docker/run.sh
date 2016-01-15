#!/bin/bash
PIMAGE=$1
PTAG=$2
RUNDIR=$(pwd)/run
CUSTSCRIPT=$RUNDIR/$PIMAGE/${PTAG}-run.sh
echo run $CUSTSCRIPT
if [ -f "$CUSTSCRIPT" ] ; then
	$CUSTSCRIPT
else
	docker run -it --rm $PIMAGE:$PTAG bash
fi
