#! /bin/bash

flutter clean
#flutter build apk --profile --obfuscate --split-debug-info=build/symbols
flutter build apk --release --obfuscate --split-debug-info=build/symbols

#上传到蒲公英
api_key=""
apk_dir="build/app/outputs/apk/*/*.apk"
# shellcheck disable=SC2116
echo -e "当前项目路径, apk_dir=$(echo "$apk_dir")"
echo -e 'apk 开始上传到蒲公英=='
# shellcheck disable=SC2116
# shellcheck disable=SC2046
/bin/bash ./pgyer_upload.sh  -k "$api_key" $(echo "$apk_dir")
echo -e 'apk 上传到蒲公英 完成==https://www.pgyer.com'
