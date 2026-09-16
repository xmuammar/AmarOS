# AmarOS 0.1 / Fedora 44 / aarch64 UEFI
# No disk or account defaults: complete these in Anaconda before installation.
graphical
lang id_ID.UTF-8
keyboard --xlayouts=us
timezone Asia/Jakarta --utc
network --bootproto=dhcp --device=link --activate --hostname=amaros
url --url=https://download.fedoraproject.org/pub/fedora/linux/releases/44/Everything/aarch64/os/
repo --name=updates --baseurl=https://download.fedoraproject.org/pub/fedora/linux/updates/44/Everything/aarch64/
rootpw --lock
selinux --enforcing
firewall --enabled
services --enabled=NetworkManager,gdm,firewalld
xconfig --startxonboot
firstboot --enable

%packages
@^workstation-product-environment
firefox
gnome-backgrounds
glib2
zram-generator-defaults
%end
