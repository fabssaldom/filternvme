#!/bin/bash
# *************************************************
# (C) Google 2022, fsalaman@google.com
# *************************************************

# Specify fstab path (original and new one)
FSTAB=fstab
FSTABOUT=fstaboutput
cp ${FSTAB} ${FSTABOUT}

if [ ! -f ${BLKID} ]; then
	echo "ERROR: Required tool: blkid not found"
	exit 1
fi
devs=$(awk '/\/dev\/[nvmeNVME]/ {print $1}' ${FSTAB})
details=( $(awk '/\/dev\/[nvmeNVME]/ {printf "%s,%s,%s,%s,%s\n",$2,$3,$4,$5,$6}' ${FSTAB}) )
cp ${FSTAB} ${FSTAB}.bkp-$(date +%Y_%M_%d-%H_%m_%S)
sed -i '/\/dev\/[nvmeNVME]/d' ${FSTABOUT}
a=0
for dev in ${devs}
do
  echo "NVMe device found in fstab: ${dev}"
  UUID=$(sudo /usr/sbin/blkid ${dev} | awk '{print $2}')
  if [ "${UUID}" == "" ]; then
	echo "ERROR: No NVMe devices found"
	exit 1
  fi
  echo "${UUID}    ${details[${a}]}" | sed -e 's/\,/\ \ \ /g' >> ${FSTABOUT}
  let a+=1
done

printf "==============================\n\n"
printf "Comparing original and new fstab files:\n\n"

diff ${FSTAB} ${FSTABOUT}
