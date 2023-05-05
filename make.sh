#!/bin/bash

#This must be manually set to quartus path
QUARTUS_PATH="/c/intelFPGA_lite/22.1std/quartus/bin64"

TARGET="./src/resizer.sv"

$QUARTUS_PATH/quartus_map --read_settings_files=on --write_settings_files=off $TARGET -c $TARGET
RET=$?
if [[ $RET -ne 0 ]] ; then
	exit $RET
fi