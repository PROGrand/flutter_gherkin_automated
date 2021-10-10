#!/bin/sh

SRC=$(cd $(dirname "$0"); pwd)
source "${SRC}/__env.sh"

firebase emulators:start --project flutter-gherkin-automated --config "base/local.firebase.json"


sleep 12d