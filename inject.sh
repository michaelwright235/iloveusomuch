#!/bin/sh

###
### Injects assets from the original app into an .ipa or the project itself
###

ORIGINAL_IPA_NAME="original.ipa"
ORIGINAL_IPA_SHA256="187253d4aa1c951af95957a49b926cfb7be4e953af578b6963fb4c7c9c0b6cb0"
ORIGINAL_IPA_URL="https://archive.org/download/i-3-u-so-com.julienadam.cassius-1.04/I-3-U-SO-com.julienadam.cassius-1.04.ipa"
ORIGINAL_ICON_URL="https://web.archive.org/web/20240111215624if_/https://is4-ssl.mzstatic.com/image/thumb/Purple/2b/df/56/mzi.rptjtlhi.png/738x0w.png"
IPA_NAME="iloveusomuch.ipa"

ORIGINAL_ZIP_PATH="Payload/Cassius.app/"
ORIGINAL_ZIP_FILES=(
"${ORIGINAL_ZIP_PATH}background.png"
"${ORIGINAL_ZIP_PATH}loader@2x.png"
"${ORIGINAL_ZIP_PATH}Loader.m4v"
"${ORIGINAL_ZIP_PATH}Videos.m4v"
)

if [ "$1" == "project" ]; then
    OUT_DIR="./iloveusomuch/originalAssets"
else
    OUT_DIR="./Payload/iloveusomuch.app"
fi

# Suggest downloading the original ipa file if it doesn't exit
if ! [ -f "./$ORIGINAL_IPA_NAME" ]; then
    echo "The original.ipa file doesn't exist. This script can automatically download it from archive.org."
    echo "Note: this file contains copyrighted materials that will be injected into the resulting app."
    echo "\033[0;31m$(tput bold)You CANNOT distribute the resulting $IPA_NAME file in any way. For personal use only.$(tput sgr0)\033[0m"
    while [ "$choice" != "n" ] && [ "$choice" != "y" ]; do
        printf "Do you want to continue? [y/n]: "
        read choice
    done
    if [ "$choice" == "n" ]; then
        exit 0
    fi
    echo "Downloading the original app..."
    curl -SLo "./$ORIGINAL_IPA_NAME" "$ORIGINAL_IPA_URL"
    if ! [ $? = 0 ]; then
        echo "Failed to download the original app"
        exit 1
    fi
fi

if [ "`openssl dgst -sha256 "./$ORIGINAL_IPA_NAME" | sed -E 's/SHA(2-)?256(.*)= //'`" != "$ORIGINAL_IPA_SHA256" ]; then
    echo "$ORIGINAL_IPA_NAME has an unexpected checksum. Try downloading it again."
    exit 1
fi

# Check if the required files are in place
givenZipFileList=`unzip -Z1 $ORIGINAL_IPA_NAME`
for file in ${ORIGINAL_ZIP_FILES[@]}; do
    if ! echo "$givenZipFileList" | grep $file >> /dev/null; then
        echo "'$file' not found. Are you sure that you're using the correct .ipa file?"
        exit 1
    fi
done

if [ "$1" != "project" ]; then
    mkdir -p "$OUT_DIR"
fi

# Create an argument for unzip to extract only these files
zipFilesArg=""
for file in ${ORIGINAL_ZIP_FILES[@]}; do
    zipFilesArg="${zipFilesArg} ${file}"
done

echo "Extracting original files..."
unzip -j "$ORIGINAL_IPA_NAME" ${zipFilesArg} -d "$OUT_DIR" > /dev/null

if ! [ $? = 0 ]; then
    echo "Failed to uncompress the archive"
    exit 1
fi

mv "$OUT_DIR/loader@2x.png" "$OUT_DIR/loader.png"

# Download the original app icon from web.archive.org
echo "Downloading the original app icon..."
curl -LsSo "$OUT_DIR/AppIcon.png" "$ORIGINAL_ICON_URL"
if ! [ $? = 0 ]; then
    echo "Failed to download an app icon"
    exit 1
fi;

if [ "$1" == "project" ]; then
    exit 0;
fi

# Inject files into a compiled .ipa
echo "Injecting files into iloveusomuch.ipa..."
zip -ru "$IPA_NAME" Payload > /dev/null
rm -R ./Payload

echo "\nIPA is ready!"
