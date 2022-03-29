#! /bin/sh

# Install:
#  - Place this file next to the Package.swift in your project
#  - Open a terminal and cd to the project directory
#  - Run: brew install lcov
#  - Run: chmod +x ./.scripts/00.build-and-test.sh
#
# Usage:
#  Run: ./.scripts/00.build-and-test.sh
#

# Check that script is run from 
SWIFT_PACKAGE="Package.swift"
if [ ! -f "$SWIFT_PACKAGE" ]; then
    echo "Script should be run from the directory where $SWIFT_PACKAGE exists."
    echo "run as: ./.script/02.report-code-coverage.sh"
    exit -1
fi

COVERAGE_BUILD_PATH=".build/coverage-build"

# Clean
rm -rf .build
swift package clean

# Build
swift build --enable-code-coverage --build-path $COVERAGE_BUILD_PATH

# Test
swift test --enable-code-coverage --build-path $COVERAGE_BUILD_PATH

