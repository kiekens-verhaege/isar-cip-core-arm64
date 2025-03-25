# Isar Cip Core ARM64

## Build
``` bash
./kas-container --isar build qemu-aarch64.yml
```


## Boot
``` bash
./qemu-copy-files.sh
./qemu-start.sh
```

### 1) U-Boot
U-boot provides UEFI environment and hands over control to efibootguard. In this case it is just used as the "bios" for qemu, see `start-qemu.sh`
```
-bios ${U_BOOT_BIN} \
```
 * [qemu_arm64_defconfig](https://docs.u-boot.org/en/stable/board/emulation/qemu-arm.html)

```
=> printenv
arch=arm
baudrate=115200
board=qemu-arm
board_name=qemu-arm
boot_targets=qfw usb scsi virtio nvme dhcp
bootcmd=bootflow scan -lb
bootdelay=2
cpu=armv8
ethaddr=52:54:00:12:34:56
fdt_addr=0x40000000
fdt_high=0xffffffff
fdtcontroladdr=7e590d90
initrd_high=0xffffffff
kernel_addr_r=0x40400000
loadaddr=0x40200000
preboot=usb start
pxefile_addr_r=0x40300000
ramdisk_addr_r=0x44000000
scriptaddr=0x40200000
stderr=serial,vidconsole
stdin=serial,usbkbd
stdout=serial,vidconsole
vendor=emulation

Environment size: 489/262140 bytes
```

```
=> bootflow scan -l
Scanning for bootflows in all bootdevs
Seq  Method       State   Uclass    Part  Name                      Filename
---  -----------  ------  --------  ----  ------------------------  ----------------
Scanning global bootmeth 'efi_mgr':
Missing TPMv2 device for EFI_TCG_PROTOCOL
Missing RNG device for EFI_RNG_PROTOCOL
Scanning bootdev 'fw-cfg@9020000.bootdev':
fatal: no kernel available
No working controllers found
scanning bus for devices...
Scanning bootdev 'virtio-blk#30.bootdev':
  0  efi          ready   virtio       1  virtio-blk#30.bootdev.par efi/boot/bootaa64.efi
BOOTP broadcast 1
DHCP client bound to address 10.0.2.15 (2 ms)
Scanning bootdev 'virtio-net#29.bootdev':
BOOTP broadcast 1
DHCP client bound to address 10.0.2.15 (0 ms)
*** Warning: no boot file name; using '0A00020F.img'
Using virtio-net#29 device
TFTP from server 10.0.2.2; our IP address is 10.0.2.15
Filename '0A00020F.img'.
Load address: 0x40400000
Loading: *
TFTP error: 'Access violation' (2)
Not retrying...
No more bootdevs
---  -----------  ------  --------  ----  ------------------------  ----------------
(1 bootflow, 1 valid)
```

### 2) efibootguard
Manages the UEFI variables and picks wich kernel/rootfs to boot. [efibootguard](https://github.com/siemens/efibootguard)  
It is installed on the system boot medium:
 * cip-core/wic/qemu-arm64-efibootguard.wks.in
 * cip-core/wic/ebg-sysparts.inc
```
EFI Boot Guard v0.19
Boot medium: VenHw(E61D73B9-A384-4ACC-AEAB-82E828F3628B)/VenHw(E61D73B9-A384-4ACC-AEAB-82E828F3628B)/VenHw(E61D73B9-A384-4ACC-AEAB-82E828F3628B)
Found 5 handles for file IO

Volume 0: (On boot medium) VenHw(E61D73B9-A384-4ACC-AEAB-82E828F3628B)/VenHw(E61D73B9-A384-4ACC-AEAB-82E828F3628B)/VenHw(E61D73B9-A384-4ACC-AEAB-82E828F3628B)/HD(1,GPT,C19E7E9F-BACF-49A6-B43D-2FC18D2A8D03), LABEL=, CLABEL=(null)
Volume 1: (On boot medium) VenHw(E61D73B9-A384-4ACC-AEAB-82E828F3628B)/VenHw(E61D73B9-A384-4ACC-AEAB-82E828F3628B)/VenHw(E61D73B9-A384-4ACC-AEAB-82E828F3628B)/HD(2,GPT,E8567692-2DFA-459A-BE15-F6E5DDCC8F49), LABEL=, CLABEL=BOOT0
Volume 2: (On boot medium) VenHw(E61D73B9-A384-4ACC-AEAB-82E828F3628B)/VenHw(E61D73B9-A384-4ACC-AEAB-82E828F3628B)/VenHw(E61D73B9-A384-4ACC-AEAB-82E828F3628B)/HD(3,GPT,94B2174D-C792-4E8E-8A34-B506E2927937), LABEL=, CLABEL=BOOT1
Volume 3: (On boot medium) VenHw(E61D73B9-A384-4ACC-AEAB-82E828F3628B)/VenHw(E61D73B9-A384-4ACC-AEAB-82E828F3628B)/VenHw(E61D73B9-A384-4ACC-AEAB-82E828F3628B)/HD(6,GPT,C07D5E8F-3448-46DC-9C0F-58904F369524), LABEL=, CLABEL=(null)
Volume 4: (On boot medium) VenHw(E61D73B9-A384-4ACC-AEAB-82E828F3628B)/VenHw(E61D73B9-A384-4ACC-AEAB-82E828F3628B)/VenHw(E61D73B9-A384-4ACC-AEAB-82E828F3628B)/HD(7,GPT,423F0A2E-B9B3-4615-85BE-2A4261FA32D9), LABEL=, CLABEL=(null)
Loading configuration...
Config file found on volume 1.
Config file found on volume 2.
Booting with environments from boot medium only.
2 config partitions detected.
Config Revision: 2:
 ustate: 0
 kernel: C:BOOT0:linux.efi
 args:
 timeout: 0 seconds
Full path for kernel is: VenHw(E61D73B9-A384-4ACC-AEAB-82E828F3628B)/VenHw(E61D73B9-A384-4ACC-AEAB-82E828F3628B)/VenHw(E61D73B9-A384-4ACC-AEAB-82E828F3628B)/HD(2,GPT,E8567692-2DFA-459A-BE15-F6E5DDCC8F49)/linux.efi
LoaderDevicePartUUID=C19E7E9F-BACF-49A6-B43D-2FC18D2A8D03
Starting C:BOOT0:linux.efi with watchdog set to 0 seconds ...
Unified kernel stub (EFI Boot Guard v0.19)
Unified kernel stub: Using firmware-provided device tree
EFI stub: Booting Linux Kernel...
EFI stub: Loaded initrd from LINUX_EFI_INITRD_MEDIA_GUID device path
EFI stub: Using DTB from configuration table
EFI stub: Exiting boot services...
[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x411fd070]
```
