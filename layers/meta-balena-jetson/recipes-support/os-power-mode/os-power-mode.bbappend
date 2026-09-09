FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

inherit systemd
SYSTEMD_PACKAGES = "${PN}"

S = "${UNPACKDIR}"

SRC_URI:append = " \
    file://os-power-mode \
    file://os-power-mode-jetson.conf \
    file://etc-nvpmodel-config.mount \
    file://etc-modprobe.d-nvidia-drm.conf.mount \
    file://opt-nvidia-l4t-gpusetup-gpu_pg_mask.mount \
    file://opt-nvidia-l4t-gpusetup-gpu_pg_mask.tmp.mount \
    file://etc-modprobe.d-nvidia-drm.conf.tmp.mount \
    file://nv-state-files-init \
    file://nv-state-files-init.service \
    "


SYSTEMD_SERVICE:${PN} += " \
    nv-state-files-init.service \
    etc-nvpmodel\x2dconfig.mount \
    etc-modprobe.d-nvidia\x2ddrm.conf.mount \
    etc-modprobe.d-nvidia\x2ddrm.conf.tmp.mount \
    opt-nvidia-l4t\x2dgpusetup-gpu_pg_mask.mount \
    opt-nvidia-l4t\x2dgpusetup-gpu_pg_mask.tmp.mount \
"

# We create bind-mounts for all file paths
# that the power management tools require
# to be writable
do_install:append() {
	install -d -m 0755 ${D}${libdir}/systemd/system/os-power-mode.service.d
	install -m 0644 ${UNPACKDIR}/os-power-mode-jetson.conf \
		${D}${libdir}/systemd/system/os-power-mode.service.d

	install -m 0644 ${UNPACKDIR}/nv-state-files-init.service ${D}${systemd_unitdir}/system/
	install -m 0755 ${UNPACKDIR}/nv-state-files-init ${D}${bindir}/

	install -m 0644 ${UNPACKDIR}/etc-nvpmodel-config.mount ${D}${systemd_unitdir}/system/etc-nvpmodel\\x2dconfig.mount
        install -m 0644 ${UNPACKDIR}/etc-modprobe.d-nvidia-drm.conf.mount ${D}${systemd_unitdir}/system/etc-modprobe.d-nvidia\\x2ddrm.conf.mount
        install -m 0644 ${UNPACKDIR}/opt-nvidia-l4t-gpusetup-gpu_pg_mask.mount ${D}${systemd_unitdir}/system/opt-nvidia-l4t\\x2dgpusetup-gpu_pg_mask.mount

	install -m 0644 ${UNPACKDIR}/etc-modprobe.d-nvidia-drm.conf.tmp.mount ${D}${systemd_unitdir}/system/etc-modprobe.d-nvidia\\x2ddrm.conf.tmp.mount
        install -m 0644 ${UNPACKDIR}/opt-nvidia-l4t-gpusetup-gpu_pg_mask.tmp.mount ${D}${systemd_unitdir}/system/opt-nvidia-l4t\\x2dgpusetup-gpu_pg_mask.tmp.mount

	install -d -m 0755 ${D}/etc/nvpmodel-config
        install -d -m 0755 ${D}/etc/modprobe.d

        sed -i -e 's,@BASE_BINDIR@,${base_bindir},g' \
            -e 's,@BINDIR@,${bindir},g' \
            ${D}${systemd_unitdir}/system/*.service

}

FILES:${PN} += " /usr/lib/systemd/system/os-power-mode.service.d/os-power-mode-jetson.conf "
