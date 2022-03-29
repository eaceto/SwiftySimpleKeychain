#! /bin/sh

# Install:
#  - Place this file next to the Package.swift in your project
#  - Open a terminal and cd to the project directory
#  - Run: [sudo] gem install jazzy
#  - Run: chmod +x ./.scripts/03.document-library.sh
#
# Usage:
#  Run: ./.scripts/03.document-library.sh
#

rm -rf docs/code/core docs/code/rsa_helper
mkdir -p docs/code/core docs/code/rsa_helper

VERSION=$(grep "^let libraryVersion" Package.swift | sed -E "s/let libraryVersion.*\"(.*)\"/\1/g")

echo "Generating documentation for SwiftSimpleKeychain v$VERSION..."
jazzy -o docs/code/core -m SwiftySimpleKeychain -a "Ezequiel (Kimi) Aceto" -u "https://eaceto.dev" --readme README.md --module-version "$VERSION"

echo "Generating documentation for SwiftSimpleKeychain_RSAHelper v$VERSION..."
jazzy -o docs/code/rsa_helper -m SwiftySimpleKeychain_RSAHelper -a "Ezequiel (Kimi) Aceto" -u "https://eaceto.dev" --readme README.md  --module-version "$VERSION"