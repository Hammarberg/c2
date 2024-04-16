#!/bin/env bash

cd $(dirname "$0")/../

c2root="$PWD"

#for line in $(find examples | grep .c2.json)
#do
#	pushd $(dirname "$line")
#	$c2root/c2 --hash >.hash
#	popd
#done

for line in $(find examples | grep .hash)
do
	pushd $(dirname $line)
	hash=$(<.hash)

	c2exe="$c2root/c2"
	
	"$c2exe" --clean

	result=$("$c2exe" -X --hash)
	
	if [ $? != 0 ]; then
		echo "build error"
		exit 1
	fi

	echo $hash
	echo $result

	if [ "$hash" != "$result" ]; then
		echo "hash failure"
		exit 1
	fi

	popd
done

echo "success"
