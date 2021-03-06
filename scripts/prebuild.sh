#!/bin/sh

# Build static assets before compiling software.
# This script is intended to be run from an UNIX system.
# If you don't have nodejs, yarn or curl, please install it manually.
# Automatic installation will use apt independently from your OS.

if !(hash curl 2>/dev/null); then
        echo "Curl is needed to run prebuild."
        exit 1;
fi;

if !(hash yarn 2>/dev/null) || !(hash node 2>/dev/null); then
        curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
        apt-get update
        apt-get install yarn nodejs -y
fi;

echo ">> Building web client"
(cd client && yarn && yarn build)

echo ">> Injecting static assets"
go get -u github.com/gobuffalo/packr/v2/packr2
$GOPATH/bin/packr2

echo "> Done."
