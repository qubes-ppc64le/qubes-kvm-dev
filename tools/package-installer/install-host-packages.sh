#!/bin/bash
# vim: set ts=4 sw=4 sts=4 et :

SCRIPTDIR="$(dirname "$(readlink -m "${BASH_SOURCE[0]}")")"
source "${SCRIPTDIR}/package-installer.sh"
source "${SCRIPTDIR}/host-services-stop.sh"
source "${SCRIPTDIR}/host-services-restart.sh"

##RPMDIR="qubes-packages-mirror-repo/dom0-fc32/rpm"
RPMDIR="${RPMDIR:-"qubes-packages-mirror-repo/dom0-fc32/rpm"}"

#DEBUG=true
#DRYRUN=true
#DEBUGINFO=true

#-------------------------------------------------------------------------------
# COMPONENTS
#   List of components to install including optional version number.  If the
#   version number is omitted, it will automatically be determined.
#   Example:
#       core-vchan-libkvmchan
#       #core-vchan-libkvmchan==4.1.0-1
COMPONENTS=(
    core-libvirt
    vmm-xen
    core-vchan-libkvmchan
    core-vchan-kvm==4.1.0-1
    core-qubesdb
    core-qrexec
    linux-utils
    #python-cffi
    #python-xcffib
    python-quamash
    #python-objgraph=
    #python-hid=
    #python-u2flib-host=
    #python-qasync=
    core-admin
    core-admin-client
    core-admin-addon-whonix
    core-admin-linux
    #core-agent-linux
    ####intel-microcode
    ####linux-firmware
    #linux-kernel
    artwork
    #grub2
    #grub2-theme
    #gui-common
    gui-daemon
    #gui-agent-linux
    ####gui-agent-xen-hvm-stubdom
    ####seabios
    ####vmm-xen-stubdom-legacy
    ####vmm-xen-stubdom-linux
    app-linux-split-gpg
    #app-thunderbird
    #app-linux-pdf-converter
    app-linux-img-converter
    app-linux-input-proxy
    app-linux-usb-proxy
    #app-linux-snapd-helper
    #app-shutdown-idle
    #app-yubikey
    #app-u2f
    mgmt-salt
    mgmt-salt-base
    mgmt-salt-base-topd
    mgmt-salt-base-config
    mgmt-salt-dom0-qvm
    mgmt-salt-dom0-virtual-machines
    mgmt-salt-dom0-update
    ####infrastructure
    ####meta-packages
    manager
    desktop-linux-common
    #desktop-linux-kde
##  desktop-linux-xfce4
##  desktop-linux-xfce4-xfwm4
    #desktop-linux-i3
    #desktop-linux-i3-settings-qubes
    #desktop-linux-awesome
    desktop-linux-manager
    #grubby-dummy
    #linux-pvgrub2
    linux-gbulb
    linux-scrypt
    #linux-template-builder
    ####installer-qubes-os
    ####qubes-release
    ####pykickstart=
    ####blivet
    ####lorax
    ####lorax-templates
    ####pungi
    ####anaconda
    ####anaconda-addon
    ####linux-yum
    ####linux-deb
    ####tpm-extra
    ####trousers-changer
    ####antievilmaid
)


#-------------------------------------------------------------------------------
# COMPONENT PACKAGES
vmm_xen=(
    xen
    xen-hypervisor
    xen-libs
    xen-licenses
    xen-runtime
    python3-xen
)
# core_libvirt notes:
#   libvirt-admin added for degugging.  Not installed in Qubes
core_libvirt=(
    libvirt-admin
    libvirt-bash-completion
    libvirt-client
    libvirt-daemon
    libvirt-daemon-config-network
    libvirt-daemon-driver-interface
    libvirt-daemon-driver-libxl
    libvirt-daemon-driver-network
    libvirt-daemon-driver-nodedev
    libvirt-daemon-driver-nwfilter
    libvirt-daemon-driver-qemu
    libvirt-daemon-driver-secret
    libvirt-daemon-driver-storage
    libvirt-daemon-driver-storage-core
    libvirt-daemon-driver-storage-disk
    libvirt-daemon-driver-storage-gluster
    libvirt-daemon-driver-storage-iscsi
    libvirt-daemon-driver-storage-iscsi-direct
    libvirt-daemon-driver-storage-logical
    libvirt-daemon-driver-storage-mpath
    libvirt-daemon-driver-storage-rbd
    libvirt-daemon-driver-storage-scsi
    libvirt-daemon-driver-storage-sheepdog
    libvirt-daemon-driver-storage-zfs
    libvirt-daemon-kvm
    #libvirt-daemon-qemu
    libvirt-daemon-xen
    libvirt-libs
    python3-libvirt
    # UNUSED:
    #libvirt
    #libvirt-admin
    #libvirt-daemon-config-nwfilter
    #libvirt-devel
    #libvirt-docs
)
### Additional depends installed when installing libvirt packages.  Adding the
### 'qemu' config options within libvirt spec added both 'libvirt-daemon-qemu' and
### 'libvirt-daemon-driver-qemu' packages which is likely what triggered the deps.
###
### NOTE:  Just dont install 'libvirt-daemon-qemu' to prevent depends install.
##LIBVIRT_DEPENDS=(
##    SLOF
##    edk2-aarch64
##    openbios
##    qemu
##    qemu-system-aarch64
##    qemu-system-aarch64-core
##    qemu-system-alpha
##    qemu-system-alpha-core
##    qemu-system-arm
##    qemu-system-arm-core
##    qemu-system-cris
##    qemu-system-cris-core
##    qemu-system-lm32
##    qemu-system-lm32-core
##    qemu-system-m68k
##    qemu-system-m68k-core
##    qemu-system-microblaze
##    qemu-system-microblaze-core
##    qemu-system-mips
##    qemu-system-mips-core
##    qemu-system-moxie
##    qemu-system-moxie-core
##    qemu-system-nios2
##    qemu-system-nios2-core
##    qemu-system-or1k
##    qemu-system-or1k-core
##    qemu-system-ppc
##    qemu-system-ppc-core
##    qemu-system-riscv
##    qemu-system-riscv-core
##    qemu-system-s390x
##    qemu-system-s390x-core
##    qemu-system-sh4
##    qemu-system-sh4-core
##    qemu-system-sparc
##    qemu-system-sparc-core
##    qemu-system-tricore
##    qemu-system-tricore-core
##    qemu-system-unicore32
##    qemu-system-unicore32-core
##    qemu-system-xtensa
##    qemu-system-xtensa-core
##    qemu-user
##)
####vmm-xen=()
core_vchan_libkvmchan=(
    libkvmchan-host
    libkvmchan
    libkvmchan-libs
)
core_vchan_kvm=( qubes-libvchan-kvm )
core_qubesdb=(
    qubes-db-dom0
    qubes-db
    qubes-db-libs
    python3-qubesdb
)
core_qrexec=(
    qubes-core-qrexec-dom0
    qubes-core-qrexec
    qubes-core-qrexec-libs
)
linux_utils=(
    qubes-utils
    qubes-utils-libs
    python3-qubesimgconverter
)
#VM: python_cffi=()
#VM: python_xcffib=()
python_quamash=(
    python3-Quamash
)
#VM: python_objgraph=()
#VM: python_hid=()
#VM: python_u2flib_host=()
#VM: python_qasync=()
core_admin=(
    qubes-core-dom0
)
core_admin_client=(
    qubes-core-admin-client
    python3-qubesadmin
)
core_admin_addon_whonix=(
    qubes-core-admin-addon-whonix
)
core_admin_linux=(
    qubes-core-dom0-linux
    qubes-core-dom0-linux-kernel-install
)
#VM: core_agent_linux=()
####intel_microcode=()
####linux_firmware=()
#linux_kernel=()
artwork=(
    qubes-artwork
)
#grub2=()
#grub2_theme=()
#VM: gui_common=()
gui_daemon=(
    qubes-audio-daemon
    qubes-audio-dom0
    qubes-gui-daemon
    qubes-gui-dom0
)
#VM: gui_agent_linux=()
####gui_agent_xen_hvm_stubdom=()
####seabios=()
####vmm_xen_stubdom_legacy=()
####vmm_xen_stubdom_linux=()
app_linux_split_gpg=(
    qubes-gpg-split-dom0
)
#VM: app_thunderbird=()
#VM: app_linux_pdf_converter=()
app_linux_img_converter=(
    qubes-img-converter-dom0
)
app_linux_input_proxy=(
    qubes-input-proxy
)
app_linux_usb_proxy=(
    qubes-usb-proxy-dom0
)
#VM: app_linux_snapd_helper=()
#VM: app_shutdown_idle=()
#VM: app_yubikey=()
#VM: app_u2f=()
mgmt_salt=(
    qubes-mgmt-salt
    qubes-mgmt-salt-admin-tools
    qubes-mgmt-salt-config
    qubes-mgmt-salt-dom0
)
mgmt_salt_base=(
    qubes-mgmt-salt-base
)
mgmt_salt_base_topd=(
    qubes-mgmt-salt-base-topd
)
mgmt_salt_base_config=(
    qubes-mgmt-salt-base-config
)
mgmt_salt_dom0_qvm=(
    qubes-mgmt-salt-dom0-qvm
)
mgmt_salt_dom0_virtual_machines=(
    qubes-mgmt-salt-dom0-virtual-machines
)
mgmt_salt_dom0_update=(
    qubes-mgmt-salt-dom0-update
)
####infrastructure=()
####meta_packages=()
manager=(
    qubes-manager
)
desktop_linux_common=(
    qubes-desktop-linux-common
    qubes-menus
)
#desktop_linux_kde=()
desktop_linux_xfce4=(
    xfce4-settings-qubes
)
desktop_linux_xfce4_xfwm4=(
    xfwm4
)
#desktop_linux_i3=()
#desktop_linux_i3_settings_qubes=()
#desktop_linux_awesome=()
desktop_linux_manager=(
    qubes-desktop-linux-manager
)
#grubby_dummy=()
#linux_pvgrub2=()
linux_gbulb=(
    python3-gbulb
)
linux_scrypt=(
    scrypt
)
#linux_template_builder=()
####installer_qubes_os=()
####qubes_release=()
####pykickstart=()
####blivet=()
####lorax=()
####lorax_templates=()
####pungi=()
####anaconda=()
####anaconda_addon=()
####linux_yum=()
####linux_deb=()
####tpm_extra=()
####trousers_changer=()
####antievilmaid=()


# Call `install_packages` if this file was not 'sourced'
(return 0 2>/dev/null) && SOURCED=1 || SOURCED=0
if (( ! SOURCED )); then
    install_packages "$RPMDIR" COMPONENTS "${@}"
fi
