#!/usr/bin/env sh
set -o errexit
set -o nounset

DUMP1090_HOST=${DUMP1090_HOST:=dump1090fa}
DUMP1090_PORT=${DUMP1090_PORT:=30002}


echo "Waiting for dump1090 ..."
sleep 5
ping -c 3 "${DUMP1090_HOST}"

set +o errexit
socat -d -d -u "TCP:${DUMP1090_HOST}:${DUMP1090_PORT}" TCP:data.adsbhub.org:5001
STATUS=${?}
set -o errexit

echo "Frowarding of dump1090 data ended"

if [ "${SOCAT_STATUS}" -eq 0 ]; then
	echo "Forwarding of dump1090 data stopped"
else
	echo "Forwarding of dump1090 data stopped with error: (${STATUS})"
fi

exit ${STATUS}

