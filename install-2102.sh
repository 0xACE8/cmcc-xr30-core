
# package/boot/uboot-envtools/files/mediatek_filogic
sed -i '/cmcc,rax3000m)/i\cmcc,xr30 \|\\' package/boot/uboot-envtools/files/mediatek
sed -i '/cmcc,rax3000m-emmc)/i\cmcc,xr30-emmc \|\\' package/boot/uboot-envtools/files/mediatek

# defconfig/mt7981-ax3000.config
sed -i '/rax3000m-emmc=y/i\CONFIG_TARGET_DEVICE_mediatek_mt7981_DEVICE_cmcc_xr30-emmc=y\nCONFIG_TARGET_DEVICE_PACKAGES_mediatek_mt7981_DEVICE_cmcc_xr30-emmc=""'  defconfig/mt7981-ax3000.config
sed -i '/rax3000m=y/i\CONFIG_TARGET_DEVICE_mediatek_mt7981_DEVICE_cmcc_xr30=y\nCONFIG_TARGET_DEVICE_PACKAGES_mediatek_mt7981_DEVICE_cmcc_xr30=""'  defconfig/mt7981-ax3000.config

# target/linux/mediatek/mt7981/base-files/lib/upgrade/platform.sh
sed -i '/cmcc,rax3000m\*/a\\tcmcc,xr30* \|\\' target/linux/mediatek/mt7981/base-files/lib/upgrade/platform.sh
sed -i '/cmcc,rax3000m-emmc/a\\tcmcc,xr30-emmc \|\\' target/linux/mediatek/mt7981/base-files/lib/upgrade/platform.sh
sed -i '/cmcc,rax3000m /a\\tcmcc,xr30 \|\\' target/linux/mediatek/mt7981/base-files/lib/upgrade/platform.sh

# package/mtk/applications/mtk-smp/files/smp.sh
sed -i '/rax3000m/i\\t\*cmcc,xr30\* \|\\' package/mtk/applications/mtk-smp/files/smp.sh

# target/linux/mediatek/mt7981/base-files/lib/preinit/90_extract_caldata
sed -i '/cmcc,rax3000m-em)/i\\tcmcc,xr30-emmc \|\\' target/linux/mediatek/mt7981/base-files/lib/preinit/90_extract_caldata

# target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-cmcc-rax3000m.dtsi
sed -i 's/mt7981.dtsi/mt7981-cmcc-rax3000m-xr30.dtsi/g' target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-cmcc-rax3000m.dtsi

# target/linux/mediatek/mt7981/base-files/etc/board.d/02_network
sed -i '/abt,asr3000 /a\\t\*cmcc,xr30\* \|\\' target/linux/mediatek/mt7981/base-files/etc/board.d/02_network
sed -i '/cmcc,rax3000m-emmc)/i\\tcmcc,xr30-emmc \|\\' target/linux/mediatek/mt7981/base-files/etc/board.d/02_network
sed -i '/cmcc,rax3000m)/i\\tcmcc,xr30 \|\\' target/linux/mediatek/mt7981/base-files/etc/board.d/02_network

# target/linux/mediatek/image/mt7981.mk
sed -i '/TARGET_DEVICES += cmcc_rax3000m-emmc/a \
\
define Device/cmcc_xr30\
  DEVICE_VENDOR := CMCC\
  DEVICE_MODEL := XR30 NAND\
  DEVICE_DTS := mt7981-cmcc-xr30\
  DEVICE_DTS_DIR := $(DTS_DIR)/mediatek\
  DEVICE_PACKAGES := $(MT7981_USB_PKGS) luci-app-samba4\
  SUPPORTED_DEVICES := cmcc,xr30\
  UBINIZE_OPTS := -E 5\
  BLOCKSIZE := 128k\
  PAGESIZE := 2048\
  IMAGE_SIZE := 116736k\
  KERNEL_IN_UBI := 1\
  IMAGES += factory.bin\
  IMAGE/factory.bin := append-ubi | check-size $$$$(IMAGE_SIZE)\
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata\
endef\
TARGET_DEVICES += cmcc_xr30\
\
define Device/cmcc_xr30-emmc\
  DEVICE_VENDOR := CMCC\
  DEVICE_MODEL := XR30 eMMC\
  DEVICE_DTS := mt7981-cmcc-xr30-emmc\
  DEVICE_DTS_DIR := $(DTS_DIR)/mediatek\
  SUPPORTED_DEVICES := cmcc,xr30-emmc\
  DEVICE_PACKAGES := $(MT7981_USB_PKGS) f2fsck losetup mkf2fs kmod-fs-f2fs kmod-mmc luci-app-samba4\
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata\
endef\
TARGET_DEVICES += cmcc_xr30-emmc' target/linux/mediatek/image/mt7981.mk


# 生成文件
cat > target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-cmcc-rax3000m-xr30.dtsi <<-"EOF"
/dts-v1/;
#include "mt7981.dtsi"

/ {
	memory {
		reg = <0 0x40000000 0 0x20000000>;
	};

	gpio-keys {
		compatible = "gpio-keys";
		reset {
			label = "reset";
			linux,code = <KEY_RESTART>;
			gpios = <&pio 1 GPIO_ACTIVE_LOW>;
		};

		mesh {
			label = "mesh";
			gpios = <&pio 0 GPIO_ACTIVE_LOW>;
			linux,code = <BTN_9>;
			linux,input-type = <EV_SW>;
		};
	};

	gsw: gsw@0 {
		compatible = "mediatek,mt753x";
		mediatek,ethsys = <&ethsys>;
		#address-cells = <1>;
		#size-cells = <0>;
	};
};

&uart0 {
	status = "okay";
};

&watchdog {
	status = "okay";
};

&eth {
	status = "okay";

	gmac0: mac@0 {
		compatible = "mediatek,eth-mac";
		reg = <0>;
		phy-mode = "2500base-x";

		fixed-link {
			speed = <2500>;
			full-duplex;
			pause;
		};
	};

	gmac1: mac@1 {
		compatible = "mediatek,eth-mac";
		reg = <1>;
		phy-mode = "gmii";
		phy-handle = <&phy0>;
	};

	mdio: mdio-bus {
		#address-cells = <1>;
		#size-cells = <0>;

		phy0: ethernet-phy@0 {
			compatible = "ethernet-phy-id03a2.9461";
			reg = <0>;
			phy-mode = "gmii";
			nvmem-cells = <&phy_calibration>;
			nvmem-cell-names = "phy-cal-data";
		};
	};
};

&gsw {
	mediatek,mdio = <&mdio>;
	mediatek,mdio_master_pinmux = <0>;
	reset-gpios = <&pio 39 0>;
	interrupt-parent = <&pio>;
	interrupts = <38 IRQ_TYPE_LEVEL_HIGH>;
	status = "okay";

	port6: port@6 {
		compatible = "mediatek,mt753x-port";
		mediatek,ssc-on;
		reg = <6>;
		phy-mode = "sgmii";

		fixed-link {
			speed = <2500>;
			full-duplex;
		};
	};
};

&hnat {
	mtketh-wan = "eth1";
	mtketh-lan = "eth0";
	mtketh-max-gmac = <2>;
	ext-devices-prefix = "usb", "wwan";
	status = "okay";
};

&xhci {
	mediatek,u3p-dis-msk = <0x0>;
	phys = <&u2port0 PHY_TYPE_USB2>,
		   <&u3port0 PHY_TYPE_USB3>;
	status = "okay";
};
EOF


cat > target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-cmcc-xr30-emmc.dts <<-"EOF"
/dts-v1/;
#include "mt7981-cmcc-xr30.dtsi"

/ {
	model = "CMCC XR30 eMMC version (RAX3000Z Enhanced version)";
	compatible = "cmcc,xr30-emmc", "mediatek,mt7981";

	chosen {
		bootargs = "console=ttyS0,115200n1 loglevel=8 \
			    earlycon=uart8250,mmio32,0x11002000 \
			    root=PARTLABEL=rootfs rootwait rootfstype=squashfs,f2fs";
	};
};

&mmc0 {
	bus-width = <8>;
	cap-mmc-highspeed;
	max-frequency = <52000000>;
	no-sd;
	no-sdio;
	non-removable;
	pinctrl-names = "default", "state_uhs";
	pinctrl-0 = <&mmc0_pins_default>;
	pinctrl-1 = <&mmc0_pins_uhs>;
	vmmc-supply = <&reg_3p3v>;
	non-removable;
	status = "okay";
};

&pio {
	mmc0_pins_default: mmc0-pins-default {
		mux {
			function = "flash";
			groups = "emmc_45";
		};
	};

	mmc0_pins_uhs: mmc0-pins-uhs {
		mux {
			function = "flash";
			groups = "emmc_45";
		};
	};
};
EOF

cat > target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-cmcc-xr30.dts <<-"EOF"
/dts-v1/;
#include "mt7981-cmcc-xr30.dtsi"

/ {
	model = "CMCC XR30";
	compatible = "cmcc,xr30", "mediatek,mt7981";

	chosen {
		bootargs = "console=ttyS0,115200n1 loglevel=8 \
			    earlycon=uart8250,mmio32,0x11002000";
	};

	nmbm_spim_nand {
		compatible = "generic,nmbm";
		#address-cells = <1>;
		#size-cells = <1>;

		lower-mtd-device = <&spi_nand>;
		forced-create;

		partitions {
			compatible = "fixed-partitions";
			#address-cells = <1>;
			#size-cells = <1>;

			partition@0 {
				label = "BL2";
				reg = <0x0 0x100000>;
			};

			partition@100000 {
				label = "u-boot-env";
				reg = <0x100000 0x80000>;
			};

			partition@180000 {
				label = "Factory";
				reg = <0x180000 0x200000>;
			};

			partition@380000 {
				label = "FIP";
				reg = <0x380000 0x200000>;
			};

			partition@580000 {
				label = "ubi";
				reg = <0x580000 0x7200000>;
			};
		};
	};
};

&spi0 {
	pinctrl-names = "default";
	pinctrl-0 = <&spi0_flash_pins>;
	status = "okay";

	spi_nand: spi_nand@0 {
		#address-cells = <1>;
		#size-cells = <1>;
		compatible = "spi-nand";
		reg = <0>;
		spi-max-frequency = <52000000>;
		spi-tx-bus-width = <4>;
		spi-rx-bus-width = <4>;
		spi-cal-enable;
		spi-cal-mode = "read-data";
		spi-cal-datalen = <7>;
		spi-cal-data = /bits/ 8 <0x53 0x50 0x49 0x4E 0x41 0x4E 0x44>; /* 'SPINAND' */
		spi-cal-addrlen = <5>;
		spi-cal-addr = /bits/ 32 <0x0 0x0 0x0 0x0 0x0>;
	};
};

&pio {
	spi0_flash_pins: spi0-pins {
		mux {
			function = "spi";
			groups = "spi0", "spi0_wp_hold";
		};

		conf-pu {
			pins = "SPI0_CS", "SPI0_HOLD", "SPI0_WP";
			drive-strength = <MTK_DRIVE_8mA>;
			bias-pull-up = <MTK_PUPD_SET_R1R0_11>;
		};

		conf-pd {
			pins = "SPI0_CLK", "SPI0_MOSI", "SPI0_MISO";
			drive-strength = <MTK_DRIVE_8mA>;
			bias-pull-down = <MTK_PUPD_SET_R1R0_11>;
		};
	};
};
EOF

cat > target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-cmcc-xr30.dtsi <<-"EOF"
/dts-v1/;
#include "mt7981-cmcc-rax3000m-xr30.dtsi"

/ {
	aliases {
		led-boot = &red_led;
		led-failsafe = &red_led;
		led-running = &white_led;
		led-upgrade = &red_led;
	};

	leds {
		compatible = "gpio-leds";

		red_led: red {
			label = "xr30:red";
			gpios = <&pio 35 GPIO_ACTIVE_LOW>;
		};

		white_led: white {
			label = "xr30:white";
			gpios = <&pio 34 GPIO_ACTIVE_LOW>;
		};
	};
};
EOF
