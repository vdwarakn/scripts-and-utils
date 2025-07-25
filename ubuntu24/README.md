# Autoinstall Files for Ubuntu

The autoinstall scripts are to be used for one-touch install of Ubuntu 24.

# Customize user-data to suit your needs:
* Line 80: Uncomment the proxy line and set appropriate values if required
* Line 91: Change disk to /dev/sdX as appropriate for your system. It is recommended to install on the smaller disk of your system.
* Line 53:  Set to internal NTP server or use the default
* Line 106: Change password with command <pre>printf 'r00tme@' | openssl passwd -6 -salt 'SaltB@e' -stdin</pre>


Copy these files to a http server or a USB drive.

1. Create a bootable USB 
``` dd conv=sync status=progress bs=4M if=ubuntu-24.04.1-live-server-amd64.iso of=/dev/sdXX```
2. Insert USB to Node and boot of USB
3. Add the Boot Menu, type e to edit "Try or Install Ubuntu"
4. Append the install line to look like this:
```
## If installing from HTTP Server
linux initrd --- autoinstall 'ds=nocloud-net;s=http://http_server_hostname_or_ip/ubuntu24'

## If Installing from USB
linux initrd --- autoinstall 'ds=nocloud;s=/cdrom/ubuntu24'
```
5. After adding the above line, hit Ctrl+x to boot to the installer
6. It may take a few minutes for installation to start. 
7. If you see lines starting with <pre>'subiquity/component/.....'</pre> thyen the autoinstall is in progress
8. If you see an interactive installer, then something went wrong in step 4

After installation, completes, remove the USB and boot to HDD.

