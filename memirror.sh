#!/bin/sh

MOUNT_POINT=~/work/memory
SRC=~/work/b2bcenter
DST=~/work/memory
DST_FULL=~/work/memory/b2bcenter/
SIZE_IN_MB=4000
PROG=$0
PROG_DIR=$(dirname $0)

usage()
{
	cat <<USAGE
This program replicate dir to memory partition

Usage
	$PROG <cmd>
  cmd:
	enable, disable, start_auto_sync, stop_auto_sync, manual_sync
USAGE
}

enable()
{
	# init disk &&
	# sync from SRC to DST
	$PROG_DIR/memindisk/mount-ram.sh $MOUNT_POINT $SIZE_IN_MB && \
	rsync -ah --exclude ".fseventsd" --delete $SRC $DST
	if [ $? -ne 0 ]; then
		echo "disk not created and files does not synced"
		exit $?
	fi
	echo "disk created"
	echo "mount point $MOUNT_POINT"
	echo "folders synced $SRC<->$DST"
}

disable()
{
	# unmount
	$PROG_DIR/memindisk/umount-ram.sh $MOUNT_POINT
	if [ $? -ne 0 ]; then
		echo "disk does not unmount"
		exit $?
	fi
	echo "disk unmounted"
}

manual_sync()
{
	rsync -ah --exclude ".fseventsd" --delete $DST_FULL $SRC
	if [ $? -ne 0 ]; then
		echo "folders not synced $DST_FULL<->$SRC"
		exit $?
	fi
	echo "folders synced $DST_FULL<->$SRC"
}

start_auto_sync()
{
	# todo
	echo "start_auto_sync"
}

stop_auto_sync()
{
	# todo
	echo "stop_auto_sync"
}

if [ $# -eq 0 ]; then
	usage
fi

for i in "$@"; do
case $i in
    enable)
	enable
    shift
    ;;
    disable)
	disable
    shift
    ;;
    start_auto_sync)
	start_auto_sync
    shift
    ;;
    stop_auto_sync)
	stop_auto_sync
    shift
    ;;
    manual_sync)
	manual_sync
    shift
    ;;
    *)
	usage
	exit 1
    ;;
esac
done

