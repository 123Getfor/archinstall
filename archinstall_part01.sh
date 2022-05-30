#
#
#
#
#
#
#
#
#
#
#31M  /dev/sda1 Bios boot 
#300M /dev/sda2 Efy system 
#4096M  /dev/sda3 swap
#free space /dev/sda4 root

dhcpcd

fdisk /dev/sda
g
w
mkfs.vfat /dev/sdx2  (раздел Efi system) 
mkfs.btrfs /dev/sdx4 (раздел root)
mkswap  /dev/sdx3 (раздел swap )
swapon /dev/sdx3  (включить swap)

#монтирование разделов
mount /dev/sdx3 /mnt
mkdir /mnt/boot

#если UEFI вводим еще одну команду
mkdir /mnt/boot/EFI

#монтируем Efi system бут раздел для обычного Bios
mount /dev/sdx2 /mnt/boot

#для UEFI биоса
mount /dev/sdx2 /mnt/boot/EFi

#установка базовой системы 

pacstrap -i /mnt base base-devel linux-zen linux-zen-headers linux-firmware dosfstools btrfs-progs intel-ucode iucode-tool nano

#Генерация конфига разделов 

genfstab -U /mnt >> /mnt/etc/fstab

#переход в chroot

arch-chroot /mnt

#Часовой пояс

ln -sf /usr/share/zoneinfo/Europe/Irkutsk /etc/localtime

hwclock --systohc

#Локализация

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen

#потом генерируем локали 

locale-gen
#далее редактируем nano /etc/locale.conf дописываем LANG=ru_RU.UTF-8
echo "LANG=ru_RU.UTF-8" >> /etc/locale.conf

#потом точно также редактируем vconsole дописываем LANG=ru_RU.UTF-8
echo "LANG=ru_RU.UTF-8" >> /etc/locale.conf

#Настройка сети имя компьютера "Arch" в /etc/hostname
echo "Arch" >> /etc/hostname

#файл доменных имен nano /etc/hosts
#127.0.0.1	localhost
#::1		localhost
#127.0.1.1	имясистемы.localdomain	имясистемы


echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1	Arch.localdomain	Arch" >> /etc/hosts

#Initramfs если планируется уствнока нескольких ядер заменить -P на -p

mkinitcpio -P linux-zen

#Пароль суперпользователя

passwd

#стандартное значение пароль рута будет linux
linux
linux

#Устанавливаем загрузчик и сетевые утилиты 

pacman -S grub efibootmgr dhcpcd dhclient networkamanager 

#устанавливаем загрузчик 

grub-install /dev/sda


#конфигурируем загрузчик
grub-mkconfig -o /boot/grub/grub.cfg 


#выходим 
exit 

#размонтируем /mnt
umount -R /mnt

#перезагрузка системы
reboot

#
#
#
#
#
#
#
#
#
#
root

linux

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

#логинимся в систему под рут, создаем учетную запись пользователя arch
useradd -m -G wheel -s /bin/bash arch 

#вводим имя пользователя
passwd arch

#вводим пароль пользователя
linux
linux

nano /etc/sudoers
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

#выходим из пользователя рут
exit

#вводим имя пользователя
arch

#вводим пароль пользователя
linux

sudo su


#добавляем NetworkManager в автозагрузку
systemctrl enable NetworkManager

#перезагрузка системы
#reboot

#
#
#
#
#
#
#
#
#
#
sudo nano /etc/pacman.conf
echo "[core]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
echo "[extra]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
echo "[community]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

#установка intel+nvidia
#sudo pacman -Syu nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader lib32-opencl-nvidia opencl-nvidia libxnvctrl 

#установка AMD

#sudo pacman -Syu lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader

sudo pacman -S network-manager-applet

#перезагрузка системы
#reboot

#
#
#
#
#
#
#
#
#
#

#раскоментируйте нужную вам оболочку
#KDE plasma 
#pacman -S xorg xorg-server plasma  plasma-wayland-session  egl-wayland sddm sddm-kcm packagekit-qt5 kde-applications
y
y
y
2
1
1
y

#systemctl enable sddm 

#Gnome 
#pacman -S  xorg xorg-server gnome gnome-extra gdm 
#systemctl enable gdm

#XFCE
#pacman -S xorg xorg-server xfce4 xfce4-goodies lightdm lightdm-gtk-greeter 
#systemctl enable lightdm 

#перезагрузка системы
reboot
