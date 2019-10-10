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
#   link file based on $DLL_FILE and $PATCH_FILE
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
        mv $2 $2-wasta

        echo
        echo "*** Making symlink $2 pointing to $1"
        echo
        ln -sf $1 $2
    elif [ -L "$2" ];
    then
        echo
        echo "*** Symlink already exists: $2"
        echo
    fi
}

# ------------------------------------------------------------------------------
# Main Processing
# ------------------------------------------------------------------------------
echo
echo "*** Beginning wasta-logos-setup-postinst.sh"
echo

# Setup Diretory for later reference
DIR=/usr/share/wasta-logos-setup

WINE_VERSION=$(wine --version)

if [ -d /opt/wine-devel/lib/ ];
then
    case "$WINE_VERSION" in
        wine-4.16)
            # Patch wine-devel 4.16 kernelbase.dll
            DLL_FILE=/opt/wine-devel/lib/wine/kernelbase.dll
            PATCH_FILE=$DIR/resources/kernelbase-4-16.dll
            linkFile $PATCH_FILE $DLL_FILE
        ;;

        wine-4.17)
            # Patch wine-devel 32-bit kernelbase.dll
            DLL_FILE=/opt/wine-devel/lib/wine/kernelbase.dll
            PATCH_FILE=$DIR/resources/kernelbase-4-17.dll
            linkFile $PATCH_FILE $DLL_FILE
        ;;

        *)
            echo
            echo "*** unsupported wine-devel version: not patched"
            echo
        ;;
    esac
fi

if [ -d /opt/wine-staging/lib/ ];
then
    case "$WINE_VERSION" in
        wine-4.16)
            # Patch wine-devel 4.16 kernelbase.dll
            DLL_FILE=/opt/wine-staging/lib/wine/kernelbase.dll
            PATCH_FILE=$DIR/resources/kernelbase-4-16.dll
            linkFile $PATCH_FILE $DLL_FILE
        ;;

        wine-4.17)
            # Patch wine-devel 32-bit kernelbase.dll
            DLL_FILE=/opt/wine-staging/lib/wine/kernelbase.dll
            PATCH_FILE=$DIR/resources/kernelbase-4-17.dll
            linkFile $PATCH_FILE $DLL_FILE
        ;;

        *)
            echo
            echo "*** unsupported wine-staging version: not patched"
            echo
        ;;
    esac
fi

LN_FILE="/usr/local/bin/winetricks"
if ! [ -L "$LN_FILE" ];
then
    echo
    echo "*** Creating winetricks symlink: $LN_FILE"
    echo
    ln -s $DIR/resources/winetricks $LN_FILE
fi

# ------------------------------------------------------------------------------
# Finished
# ------------------------------------------------------------------------------
echo
echo "*** Finished with wasta-logos-setup-postinst.sh"
echo

exit 0
