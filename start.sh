#!/bin/bash

JAVA_HOME=/usr/lib/jvm/jre
APP_DIR=/opt/myapps/registration-server
APP_NAME=registration-server-0.0.1-SNAPSHOT.jar

exec $JAVA_HOME/bin/java -ms8M -mx2G -jar $APP_DIR/$APP_NAME > registration-server.log 2>&1 &

exit 0