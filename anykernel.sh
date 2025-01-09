# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=N0Kernel Fork by Re-Noroi & EmanuelCN
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=alioth
device.name2=aliothin
device.name3=
device.name4=
device.name5=
supported.versions=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=1;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 750 750 $ramdisk/*;

# kernel naming scene
ui_print " ";
ui_print "Kernel Naming : "$ZIPFILE" ";
ui_print " ";

case "$ZIPFILE" in
  *miui*|*MIUI*)
    ui_print "MIUI/HyperOS Detected,";
    mv *-miui-dtbo.img $home/dtbo.img;
    rm *-aosp-dtbo.img;
  ;;
  *aosp*|*AOSP*)
    ui_print "AOSP DTBO Detected,";
    ui_print "Using AOSP DTBO... ";
    mv *-aosp-dtbo.img $home/dtbo.img;
    rm *-miui-dtbo.img;
  ;;
  *)
    ui_print "Variant is not specified !!!";
    ui_print "Using AOSP DTBO... ";
    mv *-aosp-dtbo.img $home/dtbo.img;
    rm *-miui-dtbo.img;
  ;;
esac
ui_print " ";

## AnyKernel install
dump_boot;

# Begin Ramdisk Changes

# migrate from /overlay to /overlay.d to enable SAR Magisk
if [ -d $ramdisk/overlay ]; then
  rm -rf $ramdisk/overlay;
fi;

write_boot;
## end install

## vendor_boot shell variables
block=/dev/block/bootdevice/by-name/vendor_boot;
is_slot_device=1;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;

# reset for vendor_boot patching
reset_ak;

# vendor_boot install
dump_boot;

write_boot;
## end vendor_boot install
