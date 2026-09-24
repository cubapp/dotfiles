#!/bin/bash
# Script for displaying information about Mac OS X 
# ################################################

echo "===================================================="
echo "Information about the Mac OS HW and OS"
echo "===================================================="

system_profiler SPHardwareDataType
system_profiler SPSoftwareDataType
echo "Disk: "
diskutil info disk0 | grep -i disk 


echo 
echo "===================================================="
echo "INFO: Third-party kernel extensions:"
echo "===================================================="

kmutil showloaded 2>/dev/null | grep -v com.apple

echo
echo "===================================================="
echo "INFO: System extensions (VPNs, security tools, virtual devices)."
echo "===================================================="

systemextensionsctl list
echo 
echo "===================================================="
echo "INFO: backup, and where it goes."

tmutil destinationinfo
tmutil latestbackup
