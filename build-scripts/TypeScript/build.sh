#!/bin/bash
echo -e "\e[37m[$(date '+%Y-%m-%d %H:%M:%S')]\e[39m \e[90m==>\e[39m \e[94mBuilding TypeScript messages.\e[39m"
TYPESCRIPT_VERSION=${PACKAGE_VERSION:-0.1.0}
echo -e "\e[37m[$(date '+%Y-%m-%d %H:%M:%S')]\e[39m \e[90m==>\e[39m \e[92mI need a global dependency, so please let sudo pass.\e[39m"

if [ "$(id -un)" = "root" ]; then
    npm install -g typescript >/dev/null
else
    sudo npm install -g typescript >/dev/null
fi

rm -rf Compiled/TypeScript/*;

echo -e "\e[37m[$(date '+%Y-%m-%d %H:%M:%S')]\e[39m \e[90m==>\e[39m \e[33mInstalling package dependencies.\e[39m"
yarn install >/dev/null 2>&1
echo -e "\e[37m[$(date '+%Y-%m-%d %H:%M:%S')]\e[39m \e[90m==>\e[39m \e[33mTranslating TypeScript to JavaScript.\e[39m"
tsc build-scripts/TypeScript/index.ts >/dev/null 2>&1
echo -e "\e[37m[$(date '+%Y-%m-%d %H:%M:%S')]\e[39m \e[90m==>\e[39m \e[33mBuilding your messages.\e[39m"
node build-scripts/TypeScript/index.js >/dev/null 2>&1

STARTPATH=$(pwd);
VERSION=$(cat version);

find Compiled/TypeScript/* -type d |
while read dir;
do
    cd $dir;
    echo -e "\e[37m[$(date '+%Y-%m-%d %H:%M:%S')]\e[39m \e[90m==>\e[39m \e[33mInit package.\e[39m"
    yarn init --yes --non-interactive --silent >/dev/null 2>&1;
    yarn add --silent protobufjs >/dev/null 2>&1;
    sed -i "s#\"version\": \".*\"#\"version\": \"$TYPESCRIPT_VERSION\"#g" package.json

    if [ -f "$STARTPATH/configs/.npmrc" ]; then
        cp "$STARTPATH/configs/.npmrc" ".npmrc"

        echo -e "\e[37m[$(date '+%Y-%m-%d %H:%M:%S')]\e[39m \e[90m==>\e[39m \e[33m.npmrc provided. Publishing your package.\e[39m"
        yarn publish --non-interactive --verbose --new-version $TYPESCRIPT_VERSION >/dev/null 2>&1;
    fi
    cd $STARTPATH;
done
echo -e "\e[37m[$(date '+%Y-%m-%d %H:%M:%S')]\e[39m \e[90m==>\e[39m \e[94mFinished building TypeScript messages.\e[39m"
echo "";