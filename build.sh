#!/bin/sh

# Main build command
xcodebuild clean build \
    -configuration Release \
    CONFIGURATION_BUILD_DIR=./build \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO

if ! [ $? = 0 ]; then
    echo "Failed to compile the app. Are you sure you've injected the original files first?"
    exit 1
fi;

# Compress the app into .ipa file if the "ipa" argument is passed
if [ "$1" == "ipa" ]; then
    cd ./build
    if [ -f "./iloveusomuch.ipa" ]; then
        rm ./iloveusomuch.ipa
    fi
    mkdir -p ./Payload/iloveusomuch.app
    mv ./iloveusomuch.app/* ./Payload/iloveusomuch.app
    rm -R ./iloveusomuch.app
    zip -r iloveusomuch ./Payload
    mv ./iloveusomuch.zip ./iloveusomuch.ipa
    rm -R ./Payload
    echo "\nIPA successfully created"
fi
