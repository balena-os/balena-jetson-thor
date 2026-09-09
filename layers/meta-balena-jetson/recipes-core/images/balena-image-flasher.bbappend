include balena-image.inc

do_image:balenaos-img[depends] += " tegra-flash-dry:do_deploy l4t-launcher-extlinux:do_install "

IMAGE_INSTALL:append = "efitools-utils efibootmgr"

BALENA_BOOT_PARTITION_FILES:append = " \
    bootfiles/EFI/BOOT/BOOTAA64.efi:/EFI/BOOT/BOOTAA64.efi \
    extra_uEnv.txt:/extra_uEnv.txt \
"

IMAGE_INSTALL:append = " \
    kernel-image-initramfs \
    tegra-redundant-boot \
    tegra-nv-boot-control-config \
    tegra-eeprom-tool \
    tegra-nvfancontrol \
    tegra-nvpower \
    gptfdisk \
    tegra-nvpmodel \
    tegra-configs-udev \
    nvidia-kernel-oot-display \
    nvidia-kernel-oot-bluetooth nvidia-kernel-oot-wifi \
    nvidia-kernel-oot-base nvidia-drm-loadconf \
    kernel-module-r8126 kernel-module-rtl8852ce linux-noble-nvidia-tegra-extlinux \
    tegra-firmware-tegra264 kernel-module-pcie-tegra264 kernel-module-tegra264-mc-hwpm \
"
