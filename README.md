# TFTP server in a Docker container

This container runs a TFTP server with a prepopulated `/tftpboot` directory with necessary files and configuration for PXE booting.

Also compatible with U-Boot and Raspberry Pi 4.

## Building

```
docker build -t tftpd .
```

## Deployment

```
docker-compose up -d
```

See the example `docker-compose.yml` in the source repository.

## Configuration

The user should populate `/tftpboot/boot` with bootable images, and place the `/tftpboot/pxelinux.cfg` directory with one having the appropriate configuration.

Here's an overview of the directory structure with an example boot image for LibreELEC and another for RaspBian (Raspberry Pi).
```
/tftpboot
 ├── pxelinux.cfg           <- Configuration directory (for pxelinux). Mount your own directory over this to customize.
 │   └── default            <- Default configuration.
 ├── boot                   <- Place your boot files here.
 │   ├── libreelec
 │   │   └── KERNEL
 │   └── root                  <- Special directory (optional). Contents are copied to TFTP root (to /tftpboot). Useful with Raspberry Pi since it expects a certain structure. 
 │       ├── bootcode.bin      <- This file is always required to be on the root level with RPi. Rest of the boot files can be placed in subdirs but it's not mandatory.
 │       └── your-rpi4-serial  <- All boot files can also be placed directly under `root` if desired. See: https://www.raspberrypi.org/documentation/hardware/raspberrypi/bootmodes/net.md
 │           ├── start.elf     
 │           └── ...
 │
 └── syslinux               <- No need to touch this. Contains prepopulated files and configuration necessary for booting with Syslinux.
     ├── pxelinux.0         <- The BIOS bootloader (legacy) that is commonly loaded by the PXE clients. DHCP server should point clients to path "syslinux/pxelinux.0".
     ├── efi64
     │   └── syslinux.efi   <- The UEFI bootloader (64-bit) (Note: UEFI + Syslinux may have more issues like slow transfer speeds). Clients should be pointed to "syslinux/efi64/syslinux.efi".
     ├── boot -> ../boot
     ├── pxelinux.cfg -> ../pxelinux.cfg   
     └── ...
 
```

And this could be the contents for custom `pxelinux.cfg/default`:

```
DEFAULT menu.c32
PROMPT 0
TIMEOUT 100
ONTIMEOUT local

MENU TITLE Main Menu
LABEL libreelec
    MENU LABEL LibreELEC
    kernel boot/libreelec/KERNEL
    append <INSERT_YOUR_BOOT_PARAMETERS_HERE>

LABEL local
    MENU LABEL Boot from local disk
    LOCALBOOT 0
```

## License

Copyright (c) 2018 kalaksi@users.noreply.github.com. See [LICENSE](https://github.com/kalaksi/docker-airsonic/blob/master/LICENSE) for license information.

As with all Docker images, the built image likely also contains other software which may be under other licenses (such as software from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

