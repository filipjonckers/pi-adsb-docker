#!/bin/bash
echo Starting webserver
service lighttpd start
echo Starting dump1090-fa ....
# dump1090-fa --write-json /run/dump1090-fa --net --quiet --fix --lat $DUMP_LAT --lon $DUMP_LON 
dump1090-fa --net --quiet --fix --aggressive --lat $DUMP_LAT --lon $DUMP_LON 
