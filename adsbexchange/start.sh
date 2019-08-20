#!/bin/bash

socat -d -d -u TCP:dump1090fa:30005 TCP:feed.adsbexchange.com:${CUSTOM_PORT:-30005}

