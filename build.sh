#!/bin/sh

###
### Build an Xcode project.
### This script exprects that you've already injected the original files.
###

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
if [ "$1" == "ipa" ] || [ "$1" == "ipa-no-assets" ]; then
    cd ./build
    if [ -f "./iloveusomuch.ipa" ]; then
        rm ./iloveusomuch.ipa
    fi
    mkdir -p ./Payload/iloveusomuch.app
    mv ./iloveusomuch.app/* ./Payload/iloveusomuch.app
    rm -R ./iloveusomuch.app

    # Remove copyrighted assets if the first argument is "ipa-no-assets"
    # This is used for publishing on GitHub
    if [ "$1" == "ipa-no-assets" ]; then
        rm ./Payload/iloveusomuch.app/AppIcon.png \
        ./Payload/iloveusomuch.app/loader.png \
        ./Payload/iloveusomuch.app/background.png \
        ./Payload/iloveusomuch.app/Loader.m4v \
        ./Payload/iloveusomuch.app/Videos.m4v
    fi

    zip -r iloveusomuch ./Payload
    mv ./iloveusomuch.zip ./iloveusomuch.ipa
    rm -R ./Payload
    echo "\nIPA successfully created"
fi
