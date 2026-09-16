FILESEXTRAPATHS:append := ":${THISDIR}/files"

inherit l4t_version

DEPENDS:append = " tegra-flash-dry"

HOSTAPP_HOOKS:append:jetson-agx-thor-devkit = " \
    99-resin-uboot \
    99-resin-bootfiles-agx-thor-devkit \
"

do_install:append() {
    sed -i -e 's:@L4T_VER@:${L4T_VERSION}:g;' \
            ${D}${sysconfdir}/hostapp-update-hooks.d/99-resin-bootfiles-agx-thor-devkit
}
