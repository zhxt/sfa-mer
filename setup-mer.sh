#!/bin/bash
TOOLDIR="$(dirname `which $0`)"
source "$TOOLDIR/utility-functions.inc"
# Download and untar appropriately the Mer SDK. Also try to avoid repetition.

source ~/.hadk.env

export PLATFORM_SDK_ROOT=$MER_ROOT
mkdir -p $MER_ROOT/sdks/sfossdk ;
mkdir -p $MER_ROOT/targets ;

mchapter "4.2"
cd "$MER_ROOT"
minfo "Fetching Mer"

PLATFORM_SDK_URL=http://releases.sailfishos.org/sdk/installers/latest/
TARBALL=Jolla-latest-SailfishOS_Platform_SDK_Chroot-i486.tar.bz2
[ -f $TARBALL  ] || curl -k -O $PLATFORM_SDK_URL/$TARBALL || die

minfo "Untaring Mer"
[ -f ${TARBALL}.untarred ] || sudo tar --numeric-owner -p -xjf "$MER_ROOT/$TARBALL" -C "$MER_ROOT/sdks/sfossdk" || die

#echo "export PLATFORM_SDK_ROOT=$PLATFORM_SDK_ROOT" >> ~/.bashrc
#echo 'alias sfossdk=$PLATFORM_SDK_ROOT/sdks/sfossdk/mer-sdk-chroot' >> ~/.bashrc ; exec bash ;
#echo 'PS1="PlatformSDK $PS1"' > ~/.mersdk.profile ;
#echo '[ -d /etc/bash_completion.d ] && for i in /etc/bash_completion.d/*;do . $i;done'  >> ~/.mersdk.profile ;

touch ${TARBALL}.untarred
minfo "Done with Mer"

# These commands are a tmp workaround of glitch when working with target:
#sudo zypper ar http://repo.merproject.org/obs/home:/sledge:/mer/latest_i486/ \
#curlfix
#sudo zypper ref curlfix
#sudo zypper dup --from curlfix
minfo "setup sb2 target"
echo "$VENDOR $DEVICE"
TOOLINGS_DIR=$MER_ROOT/toolings/$VENDOR-$DEVICE
mkdir -p $TOOLINGS_DIR

minfo "Fetching toolings"
curl -k -O http://releases.sailfishos.org/sdk/latest/Jolla-latest-Sailfish_SDK_Tooling-i486.tar.bz2

minfo "Untaring toolings"
tar --numeric-owner -p -xjf "$MER_ROOT/Jolla-latest-Sailfish_SDK_Tooling-i486.tar.bz2" -C $TOOLINGS_DIR
ls $TOOLINGS_DIR

echo 'c' | $PLATFORM_SDK_ROOT/sdks/sfossdk/mer-sdk-chroot sdk-manage target install $VENDOR-$DEVICE-armv7hl http://releases.sailfishos.org/sdk/latest/Jolla-latest-Sailfish_SDK_Target-armv7hl.tar.bz2 \
    --tooling SailfishOS-latest --tooling-url http://releases.sailfishos.org/sdk/latest/Jolla-latest-Sailfish_SDK_Tooling-i486.tar.bz2
