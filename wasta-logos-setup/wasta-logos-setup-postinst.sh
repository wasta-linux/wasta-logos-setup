#!/bin/bash

# ==============================================================================
# wasta-logos-setup: wasta-logos-setup-postinst.sh
#
# This script is automatically run by the postinst configure step on
#   installation of wasta-logos-setup.  It can be manually re-run, but is
#   only intended to be run at package installation.
#
# 2019-09-28 rik: initial script
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
# Main Processing
# ------------------------------------------------------------------------------
echo
echo "*** Beginning wasta-logos-setup-postinst.sh"
echo

# Setup Diretory for later reference
DIR=/usr/share/wasta-logos-setup

# Patch 64-bit kernelbase.dll
DLL_FILE=/opt/wine-devel/lib64/wine/kernelbase.dll
if [ -e "$DLL_FILE" ];
then
    echo
    echo "*** Patching file: $DLL_FILE"
    echo

    # backup original dll file
    if ! [ -e "$DLL_FILE-orig" ];
    then
        echo
        echo "*** Backing up original file: $DLL_FILE"
        echo
        rsync -avt $DLL_FILE $DLL_FILE-orig
    fi

    rsync -avt $DIR/resources/kernelbase-64.dll $DLL_FILE
else
    echo
    echo "*** File Not Found (not patched): $DLL_FILE"
    echo
fi

# Patch 32-bit kernelbase.dll
DLL_FILE=/opt/wine-devel/lib/wine/kernelbase.dll
if [ -e "$DLL_FILE" ];
then
    echo
    echo "*** Patching file: $DLL_FILE"
    echo

    # backup original dll file
    if ! [ -e "$DLL_FILE-orig" ];
    then
        echo
        echo "*** Backing up original file: $DLL_FILE"
        echo
        rsync -avt $DLL_FILE $DLL_FILE-orig
    fi

    rsync -avt $DIR/resources/kernelbase-32.dll $DLL_FILE
else
    echo
    echo "*** File Not Found (not patched): $DLL_FILE"
    echo
fi

# ------------------------------------------------------------------------------
# Finished
# ------------------------------------------------------------------------------
echo
echo "*** Finished with wasta-logos-setup-postinst.sh"
echo

exit 0
