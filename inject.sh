#!/bin/sh

OUT_DIR="./iloveusomuch/originalAssets"

IPA_NAME="original.ipa"

zipPath="Payload/Cassius.app/"
zipFiles=(
"${zipPath}background.png"
"${zipPath}loader@2x.png"
"${zipPath}Loader.m4v"
"${zipPath}Videos.m4v"
)

if ! [ -f "./original.ipa" ]; then
    echo "Please put the original .ipa file under the 'original.ipa' name first"
    exit 1
fi

# Check if the required files are in place
givenZipFileList=`unzip -Z1 $IPA_NAME`
for file in ${zipFiles[@]}; do
    if ! echo "$givenZipFileList" | grep $file >> /dev/null; then
        echo "'$file' not found. Are you sure that you're using the correct .ipa file?"
        exit 1
    fi
done

# Create an argument for unzip to extract only these files
zipFilesArg=""
for file in ${zipFiles[@]}; do
    zipFilesArg="${zipFilesArg} ${file}"
done

unzip -j $IPA_NAME ${zipFilesArg} -d $OUT_DIR

if ! [ $? = 0 ]; then
    echo "Failed to uncompress the archive"
    exit 1
fi;

mv $OUT_DIR/loader@2x.png $OUT_DIR/loader.png

# Download the original app icon from web.archive.org
curl -o $OUT_DIR/AppIcon.png "https://web.archive.org/web/20240111215624if_/https://is4-ssl.mzstatic.com/image/thumb/Purple/2b/df/56/mzi.rptjtlhi.png/738x0w.png"
