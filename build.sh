#!/bin/bash

# TODO cancel build task if it exceeds timeout

# Stop script on errors
set -e
set -o pipefail
shopt -s extglob dotglob

# Run build process based on configuration files

# Jekyll with Gemfile plugins
if [ "$GENERATOR" = "jekyll" ]; then

  # Add Federalist configuration settings
  git log -1 --pretty=format:'%ncommit: {%n "commit": "%H",%n "author": "%an <%ae>",%n "date": "%ad",%n "message": "%s"%n}' >> _config.yml
  echo -e "\nbaseurl: ${BASEURL-"''"}\nbranch: ${BRANCH}\n${CONFIG}" >> _config.yml

  if [[ -f Gemfile ]]; then
    bundle install --quiet
    bundle exec jekyll build --source . --destination ./_site
  else
    jekyll build --source . --destination ./_site
  fi

# Hugo
elif [ "$GENERATOR" = "hugo" ]; then
  echo "Hugo not installed!"
  # hugo -b ${BASEURL-"''"} -s . -d ./_site

# Static files
else
  mkdir _site
  mv !(_site) _site
fi
