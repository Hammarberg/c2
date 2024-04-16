#!/bin/env bash

# Smoke test for wine environment
cd $(dirname "$0")/../

c2root="$PWD"

c2exe="wine $c2root/c2"
echo $c2exe

for line in $(find examples | grep .hash)
do
	pushd $(dirname $line)
	hash=$(<.hash)

	WINEPATH=$c2root/mingw64/bin $c2exe --clean
	result=$(WINEPATH=$c2root/mingw64/bin $c2exe -X --hash)
	
	if [ $? != 0 ]; then
		echo "build error"
		exit 1
	fi

	echo "$hash"
	echo "$result"

	if [[ "${hash%$'\r'}" != "${result%$'\r'}" ]]; then
		echo "hash failure"
		exit 1
	fi

	popd
done

echo "success"
