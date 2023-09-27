#! /bin/bash

flutter precache --no-web --no-linux --no-windows --no-fuchsia --no-android --no-macos
flutter clean
flutter build ipa --profile --export-method ad-hoc  --obfuscate --split-debug-info=build/symbols

#上传到蒲公英
api_key=""
cur_dir=$(pwd)
apk_dir="build/ios/ipa/*.ipa"
echo -e "当前项目路径 apk_dir=$(echo $apk_dir)"
echo -e 'apk 开始上传到蒲公英=='
/bin/bash ./pgyer_upload.sh  -k "$api_key" $(echo "$apk_dir")
echo -e 'apk 上传到蒲公英 完成==https://www.pgyer.com'
