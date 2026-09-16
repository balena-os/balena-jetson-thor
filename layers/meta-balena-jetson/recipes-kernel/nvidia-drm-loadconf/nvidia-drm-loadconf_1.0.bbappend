do_install:append() {
    # Create mount-point for bind-mounted file
    # required by nvpmodel. Without this nvpmodel will fail at startup
    # because /etc/ is read-only.
    touch ${B}/nvidia-drm.conf.tmp
    install -m 0644 ${B}/nvidia-drm.conf.tmp ${D}${sysconfdir}/modprobe.d/
}
