#!/bin/bash -
#===============================================================================
#
#          FILE: sfs.sh
#
#         USAGE: ./sfs.sh 
#
#   DESCRIPTION: Mounts a SSHFS filesystem in OSX
#
#       OPTIONS: 
#  REQUIREMENTS: Homebrew, cask/OSXFUSE, sshfs, gnu-sed
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Robert Sink (robert.sink@gmail.com)
#  ORGANIZATION: ---
#       CREATED: 12/12/2017 17:22
#      REVISION:  ---
#===============================================================================

MOUNTPOINT=$(mktemp -d /tmp/sshfs.XXXXXXXX)

/usr/local/bin/sshfs $1 $MOUNTPOINT
SSHFS_PID=$!

SSH_DIR=$(echo $1 | gsed 's/.*@\(.*\)/\1/; s/://; s/\//-/g;')

# Create our mount dir if it does not exist
if ! [ -d ~/sfs ]; then
  mkdir ~/sfs
fi

# Link our mount to our mount dir
ln -sf $MOUNTPOINT ~/sfs/$SSH_DIR > /dev/null 2>&1

echo -e "#!/bin/bash\nkill $SSHFS_PID\nsleep 1\nrmdir $MOUNTPOINT\nrm ~/sfs/$SSH_DIR\nrm \$0\n" > /tmp/kill.sshfs.$SSH_DIR.$SSHFS_PID

chmod 700 /tmp/kill.sshfs.$SSH_DIR.$SSHFS_PID

echo ~/sfs/$SSH_DIR

# vim: autoindent tabstop=2 shiftwidth=2 expandtab softtabstop=2 filetype=sh
