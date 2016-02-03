#!/usr/bin/env bash
#
# install_packages.sh
# Install MATLAB and Octave packages from Octave Forge, MATLAB
# FileExchange or explicit URIs.
#
# Inputs
#   - Path to file containing requirements
#   - Directory to house packages. Optional, default is 'external'.
#   - Directory to house cached files. Set to '-' to disable caching.
#     Optional, default is no caching.
# Exit codes
#   0 - success
#   1 - failure
#   2 - unrecognised line in file
#
# Scott C. Lowe <scott.code.lowe@gmail.com>

#==============================================================================
# Input handling
#==============================================================================

# Define default input values
DEFAULT_PACKAGE_FOLDER='external';
DEFAULT_CACHE_FOLDER='-';

# Check number of inputs matches expected range
if (( $# < 1 )) || (( $# > 3 )); then
    echo "Wrong number of inputs. Given $#, expected 1-3.";
    exit 1;
fi;

# Set variables based on the arguments, or their defaults
PACKAGE_FOLDER=${2:-$DEFAULT_PACKAGE_FOLDER};
CACHE_FOLDER=${3:-$DEFAULT_CACHE_FOLDER};

# If package folder input was '-', assuming this is an omitted input
# and use the default value
if [[ $PACKAGE_FOLDER == '-' ]];
then
    PACKAGE_FOLDER=$DEFAULT_PACKAGE_FOLDER;
fi

# Check whether we should cache the downloads
if [[ $CACHE_FOLDER == '-' ]];
then
    # We will use a temporary folder
    DOWNLOAD_FOLDER=$(mktemp -d);
    # Function to verbosely delete the temp directory
    function cleanup {
        rm -rf "$DOWNLOAD_FOLDER";
        echo "";
        echo "Deleted temporary download directory '$DOWNLOAD_FOLDER'";
    }
    # Register the cleanup function to be called on the EXIT signal
    trap cleanup EXIT;
else
    # Ensure the cache folder exits
    mkdir -p "$CACHE_FOLDER";
    DOWNLOAD_FOLDER=$CACHE_FOLDER;
fi;

# Should we fail if we don't have octave and requirements wants to
# install something from forge?
NO_OCTAVE_RETURN=0;

# Check whether octave command exists
# 0 if it does; 1 if it doesn't
OCTAVE_MISSING=$(command -v octave >/dev/null 2>&1)$?

# Verbose things
echo "Download folder is: $DOWNLOAD_FOLDER";

#==============================================================================
# Subfunctions
#==============================================================================
# -----------------------------------------------------------------------------
# curlFileName
# Get the filename which a server would like us to use when downloading
# their file.
# Inputs
#   Unique Resource Identifier (URI)
# Outputs
#   Filename determined from content disposition given in header
function curlFileName {
    curl -L -I --silent "$1" \
        | grep 'Content-Disposition:' \
        | tail -1 \
        | sed 's/.*filename="\(.*\)"/\1/';
}
# -----------------------------------------------------------------------------
# extract
# Extract or decompress a file with unknown compression method
# Inputs
#   Filename
function extract {
    if [ -z "$1" ] || [ "$1" == "-h" ]; then
        # display usage if no parameters given
        echo "Usage: extract file_name"
        return 0;
    fi;
    if [ ! -f "$1" ] ; then
        # Make sure file exists
        echo "'$1' - file does not exist"
        return 1;
    fi;
    # Try to decompress file based on extension
    case "$1" in
        *.tar.bz2)   tar -xvjf "$1";    return  ;;
        *.tar.gz)    tar -xvzf "$1";    return  ;;
        *.tar.xz)    tar -xvJf "$1";    return  ;;
        *.lzma)      unlzma "$1";       return  ;;
        *.bz2)       bunzip2 "$1";      return  ;;
        *.rar)       unrar x -ad "$1";  return  ;;
        *.gz)        gunzip "$1";       return  ;;
        *.tar)       tar -xvf "$1";     return  ;;
        *.tbz2)      tar -xvjf "$1";    return  ;;
        *.tgz)       tar -xvzf "$1";    return  ;;
        *.zip)       unzip "$1";        return  ;;
        *.Z)         uncompress "$1";   return  ;;
        *.7z)        7z x "$1";         return  ;;
        *.xz)        unxz "$1";         return  ;;
        *.exe)       cabextract "$1";   return  ;;
        *)           echo "extract: '$1' - unknown extension";;
    esac;
    # No extension given it seems, so we will try to work it out by MIME-type
    TYPE=$(file --mime-type -b "$1")
    echo "Trying to deduce compression method from MIME type";
    echo "$1 is a $TYPE";
    case $TYPE in
        application/x-gtar)
            tar -xvf "$1";;
        application/x-lzma)
            unlzma "$1";;
        application/x-bzip2)
            bunzip2 "$1";;
        application/x-rar)
            unrar x -ad "$1";;
        application/gzip)
            # gunzip won't work without an extension, so just use 7z
            false;;
        application/zip)
            unzip "$1";;
        application/x-compress)
            uncompress "$1";;
        application/x-7z-compressed)
            7z x "$1";
            return;; # Don't double up on 7z
        application/x-xz)
            unxz "$1";;
        *)
            echo "extract: '$1' - unknown mime-type '$TYPE'";
            false;;
    esac;
    # 7z is a Swiss-army knife for decompression, so try that
    RESULT=$?;
    if [[ $RESULT -ne 0 ]];
    then
        command -v 7z >/dev/null 2>&1 \
            && 7z x "$1";
        RESULT=$?;
    fi;
    if [[ $RESULT -ne 0 ]];
    then
        echo "extract: '$1' - extraction failed";
    fi;
    return $RESULT;
}
# -----------------------------------------------------------------------------
# install_forge
# Install a package from Octave Forge, and let it automatically load
# whenever octave is launched.
# Inputs
#   Name of package
# Outputs
#   Echos messages about progress, etc.
# Exit codes
#   0 on success
#   0 on missing octave command & silent 
#   1 on failure when octave is present
function install_forge {
    PACKAGE=$1;
    # Handle missing octave command
    if [[ $OCTAVE_MISSING -ne 0 ]];
    then
        echo "Octave command is missing."
        echo "Could not install '$PACKAGE' from octave forge."
        return $NO_OCTAVE_RETURN;
    fi;
    # Strip out 'forge://' protocol identifier, if present at start
    PACKAGE="$(echo $PACKAGE | sed 's~^forge://~~')";
    # Strip out version specifiers, if present
    PACKAGE="$(echo $PACKAGE | sed 's/^\([^=<>~! ]*\).*/\1/')";
    # Got the package name actual
    echo "Installing $PACKAGE from Octave Forge";
    # Install, retrying as necessary
    for i in {1..8};
    do
        octave -q --eval "pkg install -auto -forge '$PACKAGE'" \
            && return \
            || echo "Failed attempt $i. Pausing then retrying..." \
            && sleep 10;
    done
    # Did not manage to break the loop, so failed to install
    return 1;
}
# -----------------------------------------------------------------------------
# install_fex
# Install a package from MATLAB FileExchange
# Inputs
#   ID of package (numeric string)
function install_fex {
    PACKAGE=$1;
    # Strip out 'fex://' protocol identifier, if present at the start
    PACKAGE="$(echo $PACKAGE | sed 's~^fex://~~')";
    # Strip out package name, if present, to get just the numeric ID
    PACKAGE="$(echo $PACKAGE | sed 's/-.*//')";
    # Got the package name actual
    echo "Installing $PACKAGE from FileExchange";
    # Set the URL to download from
    BASE='http://www.mathworks.com/matlabcentral/fileexchange/';
    QUERY='?download=true';
    URI="$BASE$PACKAGE$QUERY";

    # Let install_uri do all the work for us
    install_uri $URI;
}
# -----------------------------------------------------------------------------
# install_uri
# Install from an arbitrary URI
# Inputs
#   Unique Resource Identifier (URI)
function install_uri {
    URI="$1";
    FILENAME=$(curlFileName "$URI");
    FILENAME=${FILENAME%%[[:space:]]*};
    FILENAME=${FILENAME##*[[:space:]]};
    if [ -z "$FILENAME" ];
    then
        # Couldn't automatically get the filename, so just use the URI
        echo "Couldn't get the filename from curl headers"
        FILENAME=${URI##*/};
        FILENAME=${FILENAME%%\?*};
    fi;
    PACKAGE=${FILENAME%%.*}
    echo "Installing package '$PACKAGE' from URI:"
    echo "  $URI";
    echo "  to receive file '$FILENAME'";

    # Work out where we will save the file
    DL_DESTINATION="$DOWNLOAD_FOLDER/$FILENAME";
    # Download the file to the destination, if absent
    if [[ ! -e "$DL_DESTINATION" ]];
    then
        echo "Downloading to file '$FILENAME' to $DL_DESTINATION";
        wget -O "$DL_DESTINATION" "$URI";
        RESULT=$?; if [[ $RESULT -ne 0 ]]; then return $RESULT; fi;
    else
        echo "Using cached copy of file from $DL_DESTINATION";
    fi;
    # Move the downloaded file to the package folder
    if [[ -d "$PACKAGE_FOLDER/$PACKAGE/" ]];
    then
        rm -r "$PACKAGE_FOLDER/$PACKAGE/" \
            && echo "Removed old copy of package '$PACKAGE'";
    fi;
    mkdir -p "$PACKAGE_FOLDER/$PACKAGE/";
    # Extract the file from there, so the contents are in the right dir
    cp "$DL_DESTINATION" "$PACKAGE_FOLDER/$PACKAGE/$FILENAME";
    pushd "$PACKAGE_FOLDER/$PACKAGE/" > /dev/null;
    echo "Attempting to extract contents from $FILENAME";
    extract "$FILENAME" && rm -f "$FILENAME";
    # If we can't extract it, let's assume it wasn't an archive after
    # all, and we're done if we just put the downloaded file in the
    # directory.
    if [[ $? -ne 0 ]];
    then
        echo "";
        echo "Couldn't decompress $FILENAME.";
        echo "I'm assuming that this file isn't actually an archive.";
    else
        echo "";
        echo "Decompression of $FILENAME appears to have been successful.";
    fi;
    popd > /dev/null;
}
# -----------------------------------------------------------------------------
# install_single
# Given a line of text, detect which type of package is required
# (forge, fex or uri), then install it.
# Inputs
#   string
# Outputs
#   Echos progress
# Returns
#   0 on success
#   1 on failure to download input
#   2 on failure to recognise input
function install_single {
    LINE="$1"
    # Skip inputs which are just whitespace or are commented out
    if echo "$LINE" | grep -qE '^ *(#|$)';
    then
        return 0;
    fi;
    # Remove in-line comments from input
    LINE="$(echo $LINE | sed 's/ #.*//')";
    # Remove trailing spaces from input
    LINE="$(echo $LINE | sed -e 's/[[:space:]]*$//')";
    # Done with prep
    echo "";
    echo "==================================================================";
    echo "$LINE"
    # Work out what kind of package this line is
    if grep -q "^forge://" <<< "$LINE"; then
        echo "... is Octave Forge";
        install_forge "$LINE";

    elif grep -q "^fex://" <<< "$LINE"; then
        echo "... is FileExchange";
        install_fex "$LINE";

    elif grep -q "://" <<< "$LINE"; then
        echo "... is URI";
        install_uri "$LINE";

    elif grep -qE "^[0-9]+(-|$)" <<< "$LINE"; then
        echo "... is FileExchange";
        install_fex "$LINE";

    elif grep -qE "^[a-ZA-Z0-9]+(=<>~! |$)" <<< "$LINE"; then
        echo "... is Octave Forge";
        install_forge "$LINE";

    else
        echo "... means nothing to me.";
        return 2;

    fi;
}
# -----------------------------------------------------------------------------

#==============================================================================
# Main
#==============================================================================

while read LINE; do
    # Do this line
    install_single $LINE;
    # Check whether it worked
    OUT=$?;
    if [[ $OUT -ne 0 ]];
    then
        # If this line failed, exit now
        echo "";
        echo "Failed to install the requirements from file '$1'";
        echo "Failed on line with contents '$LINE'";
        exit $OUT;
    fi;
done < $1;

echo "";
echo "==================================================================";
echo "Successfully installed requirements from file $1";
