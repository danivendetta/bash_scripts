#!/bin/bash
# Autor: danivendetta
# Date: 22-08-2017
# Description: Look for wrong mount points and if the error is received: Stale file handle traces these points to minimize the impact on the client's business
# since they can not work normally.
# Version: 1.0


# We try, if there are error, to solve at the beggining executing the command: mount -a

mount -a

list=`cat /etc/fstab  |grep "^1" |awk '{print $2}'`
for i in $list
do

#       echo $i
        ls $i > /dev/null 2>&1
        out_stat=$?
        if [ $out_stat -eq 0 ]
        then
                echo "All is working OK!!"
        else
                echo "The mount point $i has failed, we have to apply a remount"
                logger -t check_nfs_mountpoints -i "The mount point $i has failed, we have to apply a remount"
                umount $i
        fi
done

#If there have been failures in the mount points in the for, they have been disassembled and we re-apply a mount -a so that they are assembled
mount -a

echo "End of script!"
