#!/bin/bash

set -e
shopt -s globstar

if grep -Pn '( |\t|;|{)tag( ?)=' maps/**/*.dmm;	then
	echo "Tags are not allowed in .dmm files."
	exit 1
fi;
if grep 'step_[x]' maps/**/*.dmm; then
	echo "Step_x and step_y are not allowed in .dmm files, as pixel movement is not implemented."
	exit 1
fi;
if grep -E '^\".+\" = \(.+\)' maps/**/*.dmm;	then
	echo "Non-TGM formatted map detected. Please convert it using Map Merger!"
	exit 1
fi;
