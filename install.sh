wget --no-check-certificate -O target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-cmcc-rax3000m-xr30.dtsi "https://raw.githubusercontent.com/0xACE8/Cmcc-XR30-Core/main/target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-cmcc-rax3000m-xr30.dtsi"
wget --no-check-certificate -O target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-cmcc-xr30-emmc.dts "https://raw.githubusercontent.com/0xACE8/Cmcc-XR30-Core/main/target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-cmcc-xr30-emmc.dts"
wget --no-check-certificate -O target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-cmcc-xr30.dts "https://raw.githubusercontent.com/0xACE8/Cmcc-XR30-Core/main/target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-cmcc-xr30.dts"
wget --no-check-certificate -O target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-cmcc-xr30.dtsi "https://raw.githubusercontent.com/0xACE8/Cmcc-XR30-Core/main/target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-cmcc-xr30.dtsi"


sed -i '18 icmcc,xr30-emmc \|\\' package/boot/uboot-envtools/files/mediatek_filogic
sed -i '19 icmcc,xr30 \|\\' package/boot/uboot-envtools/files/mediatek_filogic

sed -i '14 iCONFIG_TARGET_DEVICE_mediatek_mt7981_DEVICE_cmcc_xr30-emmc=y' defconfig/mt7981-ax3000.config
sed -i '15 iCONFIG_TARGET_DEVICE_PACKAGES_mediatek_mt7981_DEVICE_cmcc_xr30-emmc=""' defconfig/mt7981-ax3000.config
sed -i '16 iCONFIG_TARGET_DEVICE_mediatek_mt7981_DEVICE_cmcc_xr30=y' defconfig/mt7981-ax3000.config
sed -i '17 iCONFIG_TARGET_DEVICE_PACKAGES_mediatek_mt7981_DEVICE_cmcc_xr30=""' defconfig/mt7981-ax3000.config

sed -i '253 i\\tcmcc,xr30* \|\\' target/linux/mediatek/mt7981/base-files/lib/upgrade/platform.sh
sed -i '213 i\\tcmcc,xr30-emmc \|\\' target/linux/mediatek/mt7981/base-files/lib/upgrade/platform.sh
sed -i '206 i\\tcmcc,xr30 \|\\' target/linux/mediatek/mt7981/base-files/lib/upgrade/platform.sh

sed -i '758 i\\t*cmcc,xr30* \|\\' package/mtk/applications/mtk-smp/files/smp.sh

sed -i '19 i\\tcmcc,xr30-emmc \|\\' target/linux/mediatek/mt7981/base-files/lib/preinit/90_extract_caldata

sed -i 's/mt7981.dtsi/mt7981-cmcc-rax3000m-xr30.dtsi/g' target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-cmcc-rax3000m.dtsi

sed -i '227 i\\tcmcc,xr30-emmc \|\\' target/linux/mediatek/mt7981/base-files/etc/board.d/02_network
sed -i '48 i\\t*cmcc,xr30* \|\\' target/linux/mediatek/mt7981/base-files/etc/board.d/02_network


cat >> ./target/linux/mediatek/image/mt7981.mk <<-"EOF"

define Device/cmcc_xr30
  DEVICE_VENDOR := CMCC
  DEVICE_MODEL := XR30 NAND
  DEVICE_DTS := mt7981-cmcc-xr30
  DEVICE_DTS_DIR := $(DTS_DIR)/mediatek
  DEVICE_PACKAGES := $(MT7981_USB_PKGS) luci-app-samba4
  SUPPORTED_DEVICES := cmcc,xr30
  UBINIZE_OPTS := -E 5
  BLOCKSIZE := 128k
  PAGESIZE := 2048
  IMAGE_SIZE := 116736k
  KERNEL_IN_UBI := 1
  IMAGES += factory.bin
  IMAGE/factory.bin := append-ubi | check-size $$$$(IMAGE_SIZE)
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
endef
TARGET_DEVICES += cmcc_xr30

define Device/cmcc_xr30-emmc
  DEVICE_VENDOR := CMCC
  DEVICE_MODEL := XR30 eMMC
  DEVICE_DTS := mt7981-cmcc-xr30-emmc
  DEVICE_DTS_DIR := $(DTS_DIR)/mediatek
  SUPPORTED_DEVICES := cmcc,xr30-emmc
  DEVICE_PACKAGES := $(MT7981_USB_PKGS) f2fsck losetup mkf2fs kmod-fs-f2fs kmod-mmc \
	luci-app-samba4
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
endef
TARGET_DEVICES += cmcc_xr30-emmc
EOF

