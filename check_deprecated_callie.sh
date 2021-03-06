#!/usr/bin/env bash
#
# FreeSwitch
# TTS Voice Prompt Generator
# - Compare english flat files with existing callie voice files -
#
# Copyright (c) 2013, Julian Pawlowski <jp@jps-networks.eu>
# See LICENSE file for details.
#

if [ ! -d import/en/us/callie ]; then
	echo "Voice prompt files from callie not found in import/en/us/callie/*8000. Aborting ..."
	exit 1
fi

LIST="`find ./input/en -type f -name "*.txt"`"

echo -e "\n\nThe following files were not found in Callie voice files and might be deprecated in './import/en':\n"

for FILE in $LIST; do
	BASENAME="${FILE#.*/}"
	FILENAME="${BASENAME%%.*}"
	FILENAME_FLAT="${FILENAME#*/}"
	FILENAME_FLAT="${FILENAME_FLAT#*/}"
	FILENAME_CALLIE="`echo $FILENAME_FLAT | sed -e "s/\//\/8000\//g"`"

	if [ -e input/en/locale_specific_texts.txt ]; then
		WHITELIST="`cat input/en/locale_specific_texts.txt | grep ${FILENAME_FLAT}`"
	else
		WHITELIST=""
	fi

	if [[ ! -e import/en/us/callie/${FILENAME_CALLIE}.wav && x"${WHITELIST}" == x"" && x"${FILENAME_FLAT}" != x"locale_specific_texts" ]]; then
		echo "$FILENAME_FLAT"
	fi
done

echo -e "\nTo suppress files from this list (e.g. for language specific files) you may add them to input/en/locale_specific_texts.txt\n"
