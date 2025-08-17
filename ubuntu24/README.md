# Autoinstall Files for Ubuntu

The autoinstall scripts are to be used for one-touch install of Ubuntu 24.


# Customize user-data to suit your needs:
* Line 80: Uncomment the proxy line and set appropriate values if required
* Line 91: Change disk to /dev/sdX as appropriate for your system. It is recommended to install on the smaller disk of your system.
* Line 53:  Set to internal NTP server or use the default
* Line 106: Change password with command <pre>printf 'r00tme@' | openssl passwd -6 -salt 'SaltB@e' -stdin</pre>

# Prepare the autoinstall path
## Option 1: HTTP Server
Host the ubuntu24/ folder on a HTTP server that is accessible from the Gaudi node

## Option 2: Custom ISO/USB
You can embed the autoinstall files onto a USB by creating a custom ISO and then writing it.
Instructions can be found here:
https://www.pugetsystems.com/labs/hpc/ubuntu-22-04-server-autoinstall-iso/


# Deploy using autoinstall
1. Write ubuntu-24.04 ISO to a bootable USB (use rufus or dd)
2. Insert USB to Node and boot off USB
3. At the Boot Menu, type e to edit "Try or Install Ubuntu"
4. On the next screen, append the install line to look like this:
```
## If installing from HTTP Server
linux initrd --- autoinstall 'ds=nocloud-net;s=http://http_server_hostname_or_ip/ubuntu24'

## If Installing from USB
linux initrd --- autoinstall 'ds=nocloud;s=/cdrom/ubuntu24'
```
5. After adding the above line, hit Ctrl+x to boot to the installer
6. It may take a few minutes for installation to start. 
7. If you see lines starting with <pre>'subiquity/component/.....'</pre> then autoinstall is in progress
8. If you see an interactive installer, then something went wrong in step 4

After installation completes, remove the USB and boot to SSD. Your OS is now ready to use.
Default password can be found in the user-data file
