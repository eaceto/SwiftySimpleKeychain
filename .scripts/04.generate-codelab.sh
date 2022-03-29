#! /bin/sh

# Install:
#  - Place this file next to the Package.swift in your project
#  - Open a terminal and cd to the project directory
#  - Run: go get -u -v -x github.com/googlecodelabs/tools/claat
#  - Run: chmod +x ./.scripts/04.generate-codelab.sh
#
# Usage:
#  Run: ./.scripts/04.generate-codelab.sh
#

CODELABS_BUILD_DIR="docs/codelabs"
CODELABS_BUILD_INDEX="$CODELABS_BUILD_DIR/index.md"

rm -rf $CODELABS_BUILD_DIR
mkdir -p $CODELABS_BUILD_DIR

VERSION=$(grep "^let libraryVersion" Package.swift | sed -E "s/let libraryVersion.*\"(.*)\"/\1/g")

echo "# Codelabs" > $CODELABS_BUILD_INDEX
echo "SwiftySimpleKeychain - v$VERSION"
echo "" >> $CODELABS_BUILD_INDEX
echo "## Index" >> $CODELABS_BUILD_INDEX
for f in Development/codelabs/*.md; do
    exp="${f%.md}"
    dir="$exp/"
    name="${exp##*/}"
    rm -rf $dir

    ~/go/bin/claat export "$f"
    mv "$name" $CODELABS_BUILD_DIR

    echo "* [$name](./$name/index.html)" >> $CODELABS_BUILD_INDEX
done
