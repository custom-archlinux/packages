#!/bin/bash

# Name: buildPkg.sh
# Description: Build package
# Author: Tuxi Metal <tuximetal[at]lgdweb[dot]fr>
# Url: https://github.com/custom-archlinux/iso-sources
# Version: 1.0
# Revision: 2021.06.28
# License: MIT License

packageNames=$(ls -d -- */ | cut -f1 -d '/')
PS3="Choose a number to select the package to build or 'q' to cancel: "
mainRepositoryPath="/opt/alice"
packageToBuild=''

printMessage() {
  message=$1
  tput setaf 2
  echo "-------------------------------------------"
  echo "$message"
  echo "-------------------------------------------"
  tput sgr0
}

# Helper function to handle errors
handleError() {
  clear
  set -uo pipefail
  trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
}

buildPackage() {
  printMessage "Updating package sums"
  updpkgsums
  sleep .5

  printMessage "Build package ${packageToBuild}"
  makepkg --sign --clean --force

  printMessage "Current directory: $(pwd) in packageBuild function"
}

changeDirectory() {
  name="$(pwd)/${packageToBuild}"

  if [[ -d "${name}" ]]
  then
    printMessage "Enter in ${name} directory"
    cd ${name}

    printMessage "Current directory: $(pwd) in changeDirectory function"
  fi
}

selectPackageToBuild() {
  select package in ${packageNames}
  do
    if [[ "$REPLY" == 'q' ]]; then exit; fi

    if [[ "$package" == "" ]]
    then
      echo "'$REPLY' is not a valid number"
      continue
    fi

    packageToBuild+=$package
    printMessage "Package to build: $package"

    break
  done
}

movePkgToRepo() {
  printMessage "Move the built package ${packageToBuild} to ${mainRepositoryPath}/x86_64"
  
  pattern=$(ls ./${packageToBuild}*.pkg.* 2>/dev/null | wc -l)
  if [[ $pattern != 0 ]]
  then
    mv ${packageToBuild}-*.pkg.* ${mainRepositoryPath}/x86_64
  fi
}

removeSources() {
  printMessage "Remove sources from $(pwd)"
  pattern=$(ls ./*.tar.* 2>/dev/null | wc -l)
  if [[ $pattern != 0 ]]
  then
    rm -rf *.tar.* src
  fi
}

main() {
  handleError
  selectPackageToBuild
  changeDirectory
  buildPackage
  movePkgToRepo
  removeSources

  printMessage "All is done!"

  exit 0
}

time main



