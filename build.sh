#!/bin/bash
NON_INTERACTIVE="0"

while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -n|--non-interactive)
        NON_INTERACTIVE="1"
        shift # past argument
        ;;
    --default)
        shift
        ;;
    esac
done

echo -e "\e[37m[$(date '+%Y-%m-%d %H:%M:%S')]\e[39m \e[90m==>\e[39m \e[32mStart Building Messages.\e[39m"

CONFIGURED_VERSION=$(cat version)
echo ""
if [ "$NON_INTERACTIVE" = "0" ]; then
    echo -en "\e[37m[$(date '+%Y-%m-%d %H:%M:%S')]\e[39m \e[90m==>\e[39m Version ($CONFIGURED_VERSION): "
    read GIVEN_VERSION
fi

if [ -z $GIVEN_VERSION ]; then
    PACKAGE_VERSION=$CONFIGURED_VERSION
else
    PACKAGE_VERSION=$GIVEN_VERSION
    echo -e "\e[37m[$(date '+%Y-%m-%d %H:%M:%S')]\e[39m \e[90m==>\e[39m \e[33mSaved given version to version-file\e[39m"
    echo $GIVEN_VERSION > version
fi

echo -e "\e[37m[$(date '+%Y-%m-%d %H:%M:%S')]\e[39m \e[90m==>\e[39m \e[33mBuilding with version: $PACKAGE_VERSION\e[39m"
echo ""

export NON_INTERACTIVE=$NON_INTERACTIVE
export PACKAGE_VERSION=$PACKAGE_VERSION

find build-scripts/ -name build.sh | while read script
do
    exec bash $script;
done
