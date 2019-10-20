#!/bin/bash

# ==============================================================================
# wasta-logos-setup: wasta-logos-setup-postinst.sh
#
# This script is automatically run by the postinst configure step on
#   installation of wasta-logos-setup.  It can be manually re-run, but is
#   only intended to be run at package installation.
#
# 2019-09-28 rik: initial script
# 2019-10-10 rik: adding winetricks symlink
# 2019-10-20 rik: re-working to determine patch file based on wine version
#
# ==============================================================================

# ------------------------------------------------------------------------------
# Check to ensure running as root
# ------------------------------------------------------------------------------
#   No fancy "double click" here because normal user should never need to run
if [ $(id -u) -ne 0 ]
then
    echo
    echo "Exiting...."
    sleep 5s
    exit 1
fi

# ------------------------------------------------------------------------------
# Function: linkFile
#
#   link file based on passed parameters
#       $1: Source file (that will be symlinked)
#       $2: Target file wanting to be replaced with symlink
# ------------------------------------------------------------------------------
linkFile () {
    if [ -f "$2" ];
    then
        # real file at location, needs to be replaced with symlink
        echo
        echo "*** Backing up original file: $2"
        echo
        mv "$2" "$2-wasta"
    fi

    echo
    echo "*** Making symlink $2 pointing to $1"
    echo
    ln -sf "$1" "$2"
}

# ------------------------------------------------------------------------------
# Main Processing
# ------------------------------------------------------------------------------
echo
echo "*** Beginning wasta-logos-setup-postinst.sh"
echo

# Setup Directory for later reference
DIR=/usr/share/wasta-logos-setup

WINE_VERSION=$(wine --version)
TEMP=${WINE_VERSION/wine-/}
WINE_VERSION_FORMAT=${TEMP/./-}

PATCH_FILE="$DIR/resources/kernelbase-$WINE_VERSION_FORMAT.dll"

if [ -e "$PATCH_FILE" ];
then
    KERNELBASE=/opt/wine-devel/lib/wine/kernelbase.dll
    KERNELBASE_SOURCE=$(readlink -f "$KERNELBASE")

    if ! [ "$KERNELBASE_SOURCE" == "$PATCH_FILE" ];
    then
        linkFile "$PATCH_FILE" "$KERNELBASE"
    else
        echo
        echo "*** wine already patched for Logos compatibility"
        echo
    fi
else
    echo
    echo "*** unsupported wine version: $WINE_VERSION - wine not patched!"
    echo
fi

WASTA_WINETRICKS="$DIR/resources/winetricks"
LOCAL_BIN_WINETRICKS="/usr/local/bin/winetricks"
WINETRICKS_SOURCE=$(readlink -f $LOCAL_BIN_WINETRICKS)

if ! [ "$WINETRICKS_SOURCE" == "$WASTA_WINETRICKS" ];
then
    linkFile "$WASTA_WINETRICKS" "$LOCAL_BIN_WINETRICKS"
else
    echo
    echo "*** winetricks already setup for Logos compatibility"
    echo
fi

# ------------------------------------------------------------------------------
# Finished
# ------------------------------------------------------------------------------
echo
echo "*** Finished with wasta-logos-setup-postinst.sh"
echo

exit 0
