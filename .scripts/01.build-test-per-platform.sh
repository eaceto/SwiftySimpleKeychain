#! /bin/sh

# Install:
#  - Place this file next to the Package.swift in your project
#  - Open a terminal and cd to the project directory
#  - Run: brew install lcov
#  - Run: chmod +x ./.scripts/01.build-test-per-platform.sh
#
# Usage:
#  Run: ./.scripts/01.build-test-per-platform.sh
#

# Check that script is run from 
SWIFT_PACKAGE="Package.swift"
if [ ! -f "$SWIFT_PACKAGE" ]; then
    echo "Script should be run from the directory where $SWIFT_PACKAGE exists."
    echo "run as: ./.script/01.build-test-per-platform.sh"
    exit -1
fi

schemas="SwiftySimpleKeychain SwiftySimpleKeychain_RSAHelper"
machine = "$(uname -s)"

if [[ "$machine" == "Darwin"]]; then
    sdks="iphonesimulator macosx appletvsimulator watchsimulator"
elif [[ "$machine" == "Linux"]]; then
    sdks="linux"
else
    echo "Platform '($machine)' is unknown."
    exit -2
fi

for sdk in $sdks
do
    for scheme in $schemas
    do

    done
done

xcodebuild -list

xcodebuild -scheme <scheme> -destination 'generic/platform=iOS'

xcodebuild -scheme <scheme> -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 11'

xcodebuild -scheme <scheme> test -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 11'

