#!/usr/bin/env bash
#arguments: <tag> <tagline>
if [ "$#" -ne 2 ] || [[ "$1" == "--help" || "$1" == "-h" ]]; then
	echo "Usage: $0 <tag> <tagline>"
	exit 1
fi

cd $(dirname "$0")/../
echo "#define C2_TAG \"$1\"" > version.h
echo "#define C2_TAGLINE \"$2\"" >>version.h
git add version.h
git commit -m "$1 $2"
git tag -a $1 -m "$2"
