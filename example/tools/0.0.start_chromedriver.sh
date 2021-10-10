#!/bin/sh
SRC=$(cd $(dirname "$0"); pwd)
source "${SRC}/__env.sh"

chromedriver --port=4444 --allowed-ips --readable-timestamp --log-path=chromedriver.log --enable-chrome-logs &

sleep 1000d
