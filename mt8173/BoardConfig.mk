# mt8173 platform boardconfig

# Use the non-open-source part, if present
-include vendor/mediatek/mt8173/BoardConfigVendor.mk

# Use the common part
include device/mediatek/common/BoardConfig.mk

ifneq ($(MTK_K64_SUPPORT), yes)
TARGET_ARCH := arm

ifneq ($(MTK_BASIC_PACKAGE), yes)
TARGET_CPU_VARIANT := cortex-a53
TARGET_2ND_CPU_VARIANT := cortex-a53
else
TARGET_CPU_VARIANT := cortex-a7
TARGET_2ND_CPU_VARIANT := cortex-a7
endif

TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_SMP := true
TARGET_ARCH_VARIANT := armv7-a-neon

# Don't use cit 4.8 compiler for M to avoid build break
#TARGET_TOOLCHAIN_ROOT := prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/cit-arm-linux-androideabi-4.8
#TARGET_TOOLS_PREFIX := $(TARGET_TOOLCHAIN_ROOT)/bin/arm-linux-androideabi-

else
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_VARIANT := generic
TARGET_CPU_ABI := arm64-v8a


TARGET_CPU_SMP := true

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_VARIANT := cortex-a15
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi

TARGET_USES_64_BIT_BINDER := true

TARGET_CPU_SMP := true
ARCH_ARM_HAVE_TLS_REGISTER := true
###################################

TARGET_TOOLCHAIN_ROOT := prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-linux-android-4.9
TARGET_TOOLS_PREFIX := $(TARGET_TOOLCHAIN_ROOT)/bin/aarch64-linux-android-

KERNEL_CROSS_COMPILE:= $(abspath $(TOP))/$(TARGET_TOOLS_PREFIX)

endif

ARCH_ARM_HAVE_TLS_REGISTER := true
TARGET_BOARD_PLATFORM := mt8173
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_NO_FACTORYIMAGE := true
KERNELRELEASE := 3.4

# MTK, Nick Ko, 20140305, Add Display {
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := true

PRESENT_TIME_OFFSET_FROM_VSYNC_NS := 0
ifneq ($(FPGA_EARLY_PORTING), yes)
MTK_HWC_SUPPORT := yes
else
MTK_HWC_SUPPORT := no
endif

MTK_HWC_VERSION := 1.4.0
# MTK, Nick Ko, 20140305, Add Display }


BOARD_CONNECTIVITY_VENDOR := MediaTek
BOARD_USES_MTK_AUDIO := true

ifeq ($(MTK_AGPS_APP), yes)
   BOARD_AGPS_SUPL_LIBRARIES := true
else
   BOARD_AGPS_SUPL_LIBRARIES := false
endif

ifeq ($(MTK_GPS_SUPPORT), yes)
  BOARD_GPS_LIBRARIES := true
else
  BOARD_GPS_LIBRARIES := false
endif

ifeq ($(strip $(BOARD_CONNECTIVITY_VENDOR)), MediaTek)
ifeq ($(MTK_COMBO_CHIP), MT6630)
BOARD_CONNECTIVITY_MODULE := MT6630 
BOARD_MEDIATEK_USES_GPS := true
endif

ifeq ($(MTK_COMBO_CHIP), MT7662)
BOARD_CONNECTIVITY_MODULE := combo_mt76xx 
combo_config := hardware/mediatek/config/$(strip $(BOARD_CONNECTIVITY_MODULE))/board_config.mk
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/generic/common/bluetooth
BOARD_BLUETOOTH_BDROID_HCILP_INCLUDED := 0
include $(combo_config)
endif
endif

ifeq ($(MTK_COMBO_CHIP), MT6630)
ifeq ($(MTK_BT_SUPPORT), yes)
 BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/generic/common/bluetooth
 BOARD_BLUETOOTH_BDROID_HCILP_INCLUDED := 0
endif
endif
ifeq ($(MTK_WLAN_SUPPORT), yes)
BOARD_WLAN_DEVICE := MediaTek
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_mt66xx
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_mt66xx
WIFI_DRIVER_FW_PATH_PARAM := /dev/wmtWifi
WIFI_DRIVER_FW_PATH_STA:=STA
WIFI_DRIVER_FW_PATH_AP:=AP
WIFI_DRIVER_FW_PATH_P2P:=P2P
WIFI_DRIVER_STATE_CTRL_PARAM := /dev/wmtWifi
WIFI_DRIVER_STATE_ON := 1
WIFI_DRIVER_STATE_OFF := 0
ifneq ($(strip $(MTK_BSP_PACKAGE)),yes)
MTK_WIFI_CHINESE_SSID := yes
endif
ifeq ($(strip $(MTK_BSP_PACKAGE)),yes)
MTK_WIFI_GET_IMSI_FROM_PROPERTY := yes
endif
endif

# Enable suspend for healthd/charger
BOARD_CHARGER_ENABLE_SUSPEND := true
BOARD_CHARGER_DISABLE_INIT_BLANK := true

# mkbootimg header, which is used in LK
BOARD_KERNEL_BASE = 0x40000000
ifneq ($(MTK_K64_SUPPORT), yes)
BOARD_KERNEL_OFFSET = 0x00008000
else
BOARD_KERNEL_OFFSET = 0x00080000
endif
BOARD_RAMDISK_OFFSET = 0x04000000
BOARD_TAGS_OFFSET = 0xE000000
ifneq ($(MTK_K64_SUPPORT), yes)
BOARD_KERNEL_CMDLINE = bootopt=64S3,32S1,32S1
else
TARGET_USES_64_BIT_BINDER := true
TARGET_IS_64_BIT := true
BOARD_KERNEL_CMDLINE = bootopt=64S3,32N2,64N2
endif
BOARD_MKBOOTIMG_ARGS := --kernel_offset $(BOARD_KERNEL_OFFSET) --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --tags_offset $(BOARD_TAGS_OFFSET)

define get-partition-size
$(shell device/mediatek/build/build/tools/partition/get-partition-size.py device/mediatek/mt8173/partition/partition.xml $(1) $(2))
endef

BOARD_SYSTEMIMAGE_PARTITION_SIZE := $(call get-partition-size,system)
BOARD_CACHEIMAGE_PARTITION_SIZE := $(call get-partition-size,cache)
BOARD_USERDATAIMAGE_PARTITION_SIZE := $(call get-partition-size,userdata)

#SELinux Policy File Configuration
ifeq ($(strip $(MTK_BASIC_PACKAGE)), yes)
BOARD_SEPOLICY_DIRS += \
        device/mediatek/mt8173/sepolicy/basic
endif
ifeq ($(strip $(MTK_BSP_PACKAGE)), yes)
BOARD_SEPOLICY_DIRS += \
        device/mediatek/mt8173/sepolicy/basic \
        device/mediatek/mt8173/sepolicy/bsp
endif
ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
ifneq ($(strip $(MTK_BSP_PACKAGE)), yes)
BOARD_SEPOLICY_DIRS += \
        device/mediatek/mt8173/sepolicy/basic \
        device/mediatek/mt8173/sepolicy/bsp \
        device/mediatek/mt8173/sepolicy/full
endif
endif

BOARD_HAL_STATIC_LIBRARIES := libhealthd.mt8173

BOARD_SEPOLICY_UNION += mtee.te \

pathmap_INCL += trustzone:$(MTK_PATH_SOURCE)/trustzone/mtee/source/common/include
pathmap_INCL += trustzone-uree:$(MTK_PATH_SOURCE)/external/trustzone/mtee/include

mtk_recovery_fstab_name := recovery.fstab
mtk_recovery_fstab := $(wildcard $(MTK_PLATFORM_DEVICE_DIR)/$(mtk_recovery_fstab_name))
TARGET_RECOVERY_FSTAB := $(mtk_recovery_fstab)

#SECCOMP Policy File Configuration
BOARD_SECCOMP_POLICY = device/mediatek/mt8173/seccomp/basic
