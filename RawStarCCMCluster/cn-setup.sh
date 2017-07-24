#!/bin/bash
echo ##################################################
echo ############# Compute Node Setup #################
echo ##################################################
IPPRE=$1
USER=`whoami`
yum install -y -q nfs-utils
mkdir -p /mnt/nfsshare
mkdir -p /mnt/resource/scratch
chmod 777 /mnt/nfsshare
systemctl enable rpcbind
systemctl enable nfs-server
systemctl enable nfs-lock
systemctl enable nfs-idmap
systemctl start rpcbind
systemctl start nfs-server
systemctl start nfs-lock
systemctl start nfs-idmap
localip=`hostname -i | cut --delimiter='.' -f -3`
echo "$IPPRE:/mnt/nfsshare    /mnt/nfsshare   nfs defaults 0 0" | tee -a /etc/fstab
echo "$IPPRE:/mnt/resource/scratch    /mnt/resource/scratch   nfs defaults 0 0" | tee -a /etc/fstab
showmount -e 10.0.0.4

mount -a

impi_version=`ls /opt/intel/impi`
source /opt/intel/impi/${impi_version}/bin64/mpivars.sh

ln -s /opt/intel/impi/${impi_version}/intel64/bin/ /opt/intel/impi/${impi_version}/bin
ln -s /opt/intel/impi/${impi_version}/lib64/ /opt/intel/impi/${impi_version}/lib




chown -R $USER:$USER /mnt/resource/

df
