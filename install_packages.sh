#!/usr/bin/env bash

# Define a helper function which installs dependencies listed in a file from
# Octave Forge and makes sure they are loaded whenever octave is launched.

while read PN; do
    PN="$(echo $PN | sed 's/^\([^=<>~ ]*\).*/\1/')";
    echo "";
    echo "==================================================================";
    echo "Installing $PN from Octave Forge";
    echo "------------------------------------------------------------------";
    echo "tap out" || octave -q --eval "pkg install -auto -forge $PN";
    if [[ $? -ne 0 ]];
    then
        echo "Failed to install $PN from forge";
        exit 1;
    fi;
done < $1;
