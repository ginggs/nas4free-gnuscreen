#!/bin/sh
# filename:     gnuscreen.sh
# author:       Graham Inggs <graham@nerve.org.za>
# date:         2013-02-09 ; Initial release
# date:         2013-05-05 ; Updated for NAS4Free 9.1.0.1 revision 687 which includes /lib/libulog.so.0
# date:         2013-08-23 ; Fetch files from packages-9.1-release
# purpose:      Install GNU Screen on NAS4Free (embedded version).
# Note:         Check the end of the page.
#
#----------------------- Set variables ------------------------------------------------------------------
DIR=`dirname $0`;
PLATFORM=`uname -m`
RELEASE=`uname -r | cut -d- -f1`
URL="ftp://ftp.freebsd.org/pub/FreeBSD/ports/${PLATFORM}/packages-9.1-release/All"
GNUSCREENFILE="screen-4.0.3_14.tbz"
#----------------------- Set Errors ---------------------------------------------------------------------
_msg() { case $@ in
  0) echo "The script will exit now."; exit 0 ;;
  1) echo "No route to server, or file do not exist on server"; _msg 0 ;;
  2) echo "Can't find ${FILE} on ${DIR}"; _msg 0 ;;
  3) echo "GNU Screen       installed and ready! (ONLY USE DURING A SSH SESSION)"; exit 0 ;;
  4) echo "Always run this script using the full path: /mnt/.../directory/gnuscreen.sh"; _msg 0 ;;
esac ; exit 0; }
#----------------------- Check for full path ------------------------------------------------------------
if [ ! `echo $0 |cut -c1-5` = "/mnt/" ]; then _msg 4; fi
cd $DIR;
#----------------------- Download and decompress gnu screen files if don't exist ------------------------
FILE=${GNUSCREENFILE}
if [ ! -d ${DIR}/bin ]; then
  if [ ! -e ${DIR}/${FILE} ]; then fetch ${URL}/${FILE} || _msg 1; fi
  if [ -f ${DIR}/${FILE} ]; then tar xzf ${DIR}/${FILE} || _msg 2;
    rm ${DIR}/+*; rm -R ${DIR}/man; rm -R ${DIR}/info; fi
  if [ ! -d ${DIR}/bin ] ; then _msg 4; fi
fi
#----------------------- Create symlinks ----------------------------------------------------------------
if [ ! -e /usr/local/share/screen ]; then ln -s ${DIR}/share/screen /usr/local/share; fi
for i in `ls $DIR/bin/`
  do if [ ! -e /usr/local/bin/${i} ]; then ln -s ${DIR}/bin/$i /usr/local/bin; fi; done
_msg 3 ; exit 0;
#----------------------- End of Script ------------------------------------------------------------------
# 1. Keep this script in his own directory.
# 2. chmod the script u+x,
# 3. Always run this script using the full path: /mnt/share/directory/gnuscreen
# 4. You can add this script to WebGUI: Advanced: Commands as Post command (see 3).
# 5. To run GNU Screen from shell type 'screen'.
# 6. Create ~/.screenrc with the following contents to set your preferred shell:
#    shell "/bin/bash"
