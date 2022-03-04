#!/bin/sh

SRC=$(cd $(dirname "$0"); pwd)
source "${SRC}/__env.sh"

RED='\033[0;31m'
GREEN='\033[0;32m'

NC='\033[0m' # No Color

(tail -c 0 -f chromedriver.log | sed -ue 's/.*INFO\:CONSOLE.*] \"\(.*\)\", source:.*/GHERKIN   \1/g' | grep -E GHERKIN) &

echo "Starting tests..."

2>/dev/null 1>&2 flutter drive --driver=test_driver/integration_test_driver.dart --target=integration_test/gherkin_suite_test.dart -d chrome

TEST_RESULT=$?

sleep 1s

if [ ${TEST_RESULT} -ne 0 ]
then
	echo -e "\n${RED}******* ERROR ****** ${NC}"
else
	echo -e "\n${GREEN}******* SUCCESS ****** ${NC}"
fi

2>/dev/null 1>&2 killall grep
2>/dev/null 1>&2 killall sed
2>/dev/null 1>&2 killall tail

sleep 1000d