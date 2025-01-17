#!/bin/bash

# The website is built using MkDocs with the Material theme.
# https://squidfunk.github.io/mkdocs-material/
# It requires Python to run.
# Install the packages with the following command:
# pip install mkdocs mkdocs-material

set -ex

REPO="git@github.com:cashapp/backfila.git"
DIR=temp-clone

# Delete any existing temporary website clone
rm -rf $DIR

# Clone the current repo into temp folder
git clone $REPO $DIR

# Move working directory into temp folder
cd $DIR

# Generate the API docs
GRADLE_TASKS=$(ls -d misk*/ | cut -f1 -d'/' | awk '{ printf ":%s:dokkaGfm ", $1 }')
./gradlew dokkaGfm

# Copy in special files that GitHub wants in the project root.
cat README.md | grep -v 'project website' > docs/index.md
cp CHANGELOG.md docs/changelog.md
cp RELEASING.md docs/releasing.md

# Build the site and push the new files up to GitHub
mkdocs gh-deploy

# Delete our temp folder
cd ..
rm -rf $DIR