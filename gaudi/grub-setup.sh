## Enable old style net interface names
sed -ie "s/^GRUB_DEFAULT=.*/GRUB_DEFAULT=\"0\"/g" /etc/default/grub
sed -ie "s/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=\"net.ifnames=0 biosdevname=0 intel_idle.max_cstate=0 iommu=pt\"/g" /etc/default/grub
update-grub
update-initramfs -c -u -k all
