#!/bin/bash

i="0"
while [ $i -lt 15 ]
do
	result=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:1111/info)

	if [[ "$result" =~ "200" ]]; then
    		echo "Health ok!"
    		exit 0
	fi
	
	i=$[$i+1]
	echo "Next health check attempt after 10secs"
	sleep 10
done

exit 1
