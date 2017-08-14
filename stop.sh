#!/bin/bash
isExistApp=`pgrep -f '(registration-server)'`
if [[ -n  $isExistApp ]]; then
	echo "Stopping the service"
    kill -9 $isExistApp       
fi
exit 0