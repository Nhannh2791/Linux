# Copyright (C) 2011 The Android Open-Source P:!roject
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# config.mk
#
# Product-specific compile-time definitions.
#

ifeq ($(TARGET_ARCH),)
TARGET_ARCH := arm
endif

BOARD_USES_GENERIC_AUDIO := true

-include $(QCPATH)/common/msm8937_32/BoardConfigVendor.mk

ifeq ($(TARGET_USES_FOSSIL_COMMON), true)
-include device/fossil/common/BoardConfigCommon.mk
endif

#TODO: Fix-me: Setting TARGET_HAVE_HDMI_OUT to false
# to get rid of compilation error.
TARGET_HAVE_HDMI_OUT := false
TARGET_USES_OVERLAY := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_NO_BOOTLOADER := true
#TARGET_NO_KERNEL := false
TARGET_NO_RADIOIMAGE := true
TARGET_NO_RPC := true
GET_FRAMEBUFFER_FORMAT_FROM_HWC := true
TARGET_USE_MDTP := false

DISABLE_BACKUP_AGENT := true
DISABLE_DRMPLUGIN := true

TARGET_KERNEL_ARCH := arm

# Enables CSVT
TARGET_USES_CSVT := true

#TARGET_GLOBAL_CFLAGS += -mfpu=neon -mfloat-abi=softfp
#TARGET_GLOBAL_CPPFLAGS += -mfpu=neon -mfloat-abi=softfp
TARGET_CPU_ABI  := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a53
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_SMP := true
ARCH_ARM_HAVE_TLS_REGISTER := true

BOARD_ROOT_EXTRA_SYMLINKS := /vendor/firmware_mnt:/firmware /mnt/vendor/persist:/persist

TARGET_HARDWARE_3D := false
TARGET_BOARD_PLATFORM := msm8937

BOARD_KERNEL_BASE        := 0x80000000
ifeq ($(TARGET_KERNEL_VERSION), 4.9)
    BOARD_KERNEL_PAGESIZE    := 2048
else # 4.14
    BOARD_KERNEL_PAGESIZE    := 4096
endif

BOARD_KERNEL_TAGS_OFFSET := 0x01E00000
BOARD_RAMDISK_OFFSET     := 0x02000000
# Support to build images for 2K NAND page
BOARD_KERNEL_2KPAGESIZE := 2048
BOARD_KERNEL_2KSPARESIZE := 64
TARGET_USES_UNCOMPRESSED_KERNEL := false
#USE_CLANG_PLATFORM_BUILD := true
# Enables Adreno RS driver
#OVERRIDE_RS_DRIVER := libRSDriver_adreno.so

# Shader cache config options
# Maximum size of the  GLES Shaders that can be cached for reuse.
# Increase the size if shaders of size greater than 12KB are used.
MAX_EGL_CACHE_KEY_SIZE := 12*1024

# Maximum GLES shader cache size for each app to store the compiled shader
# binaries. Decrease the size if RAM or Flash Storage size is a limitation
# of the device.
MAX_EGL_CACHE_SIZE := 2048*1024

# Use signed boot and recovery image
#TARGET_BOOTIMG_SIGNED := true

# Recovery File System Table
TARGET_RECOVERY_FSTAB := device/fossil/common/recovery.common.fstab

# Recovert Updater library
TARGET_RECOVERY_UPDATER_LIBS += librecovery_updater_msm

# Update version string at 'devinfo' partition
TARGET_RECOVERY_UPDATER_LIBS += librecovery_updater_sdm

# Recovery UI library
TARGET_RECOVERY_UI_LIB := librecovery_ui_wear
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 75
TARGET_RECOVERY_UI_MARGIN_WIDTH := 35
TARGET_PRIVATE_RES_DIRS += device/fossil/common-sdm429w/recovery/overlay/res

# Enable System As Root even for non-A/B from P onwards
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true

BOARD_USES_METADATA_PARTITION := true

KASLRSEED_SUPPORT := true

#TARGET_USES_AOSP := true
BOARD_VENDOR_KERNEL_MODULES := $(wildcard device/fossil/$(TARGET_DEVICE)-kernel/*.ko)

#BOARD_KERNEL_CMDLINE := androidboot.hardware=$(TARGET_DEVICE) user_debug=30 msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 vmalloc=300M firmware_class.path=/vendor/firmware_mnt/image androidboot.usbconfigfs=true loop.max_part=7
BOARD_KERNEL_CMDLINE := androidboot.hardware=$(TARGET_DEVICE) user_debug=30 msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci androidboot.bootdevice=7864900.sdhci lpm_levels.sleep_disabled=1 vmalloc=300M firmware_class.path=/vendor/firmware_mnt/image androidboot.usbconfigfs=true loop.max_part=7 androidboot.selinux=permissive enforcing=0 androidboot.dm_verity=disabled
BOARD_KERNEL_CMDLINE += enforcing=0 androidboot.selinux=permissive androidboot.dm_verity=disabled 

ifeq ($(TARGET_BUILD_VARIANT), user)
    BOARD_KERNEL_CMDLINE += console=/dev/null androidboot.console=/dev/null
else
    BOARD_KERNEL_CMDLINE += console=ttyMSM0,115200,n8 androidboot.console=ttyMSM0
    ifeq ($(TARGET_KERNEL_VERSION),4.9)
        BOARD_KERNEL_CMDLINE += earlycon=msm_hsl_uart,0x78B0000
    else # Kernel 4.14
        BOARD_KERNEL_CMDLINE += earlycon=msm_serial_dm,0x78b0000
    endif
endif

BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive

BOARD_SECCOMP_POLICY := device/fossil/common-sdm429w/seccomp

BOARD_EGL_CFG := device/fossil/common-sdm429w/egl.cfg


# Enable suspend during charger mode
BOARD_CHARGER_ENABLE_SUSPEND := true
BOARD_CHARGER_DISABLE_INIT_BLANK := true

# Add NON-HLOS files for ota upgrade
ADD_RADIO_FILES ?= true

# Added to indicate that protobuf-c is supported in this build
PROTOBUF_SUPPORTED := false

TARGET_USES_ION := true
TARGET_USES_NEW_ION_API :=true
TARGET_USES_QCOM_DISPLAY_BSP := true
TARGET_USES_HWC2 := true
TARGET_USES_GRALLOC1 := true
TARGET_USES_COLOR_METADATA := true

TARGET_INIT_VENDOR_LIB := libinit_msm
TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/

#Add support for firmare upgrade on msm8937
HAVE_SYNAPTICS_I2C_RMI4_FW_UPGRADE := true

#add suffix variable to uniquely identify the board
TARGET_BOARD_SUFFIX := _32

#Use dlmalloc instead of jemalloc for mallocs
#MALLOC_IMPL := dlmalloc
MALLOC_SVELTE := true

#Enable HW based full disk encryption
TARGET_HW_DISK_ENCRYPTION := true

TARGET_CRYPTFS_HW_PATH := $(BOARD_COMMON_DIR)/cryptfs_hw

#Enable SSC Feature
TARGET_USES_SSC := true

# Enable sensor multi HAL
USE_SENSOR_MULTI_HAL := true

#Enable peripheral manager
TARGET_PER_MGR_ENABLED := true

TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true

DEX_PREOPT_DEFAULT := nostripping

#Enable Smart ART Mode
WITH_ART_SMALL_MODE := true

# Enable dex pre-opt to speed up initial boot
ifneq ($(TARGET_USES_AOSP),true)
  ifeq ($(HOST_OS),linux)
    ifeq ($(WITH_DEXPREOPT),)
      WITH_DEXPREOPT := true
      WITH_DEXPREOPT_PIC := true
      ifneq ($(TARGET_BUILD_VARIANT),user)
       # Retain classes.dex in APK's for non-user builds
        DEX_PREOPT_DEFAULT := nostripping
      endif
    endif
  endif
endif


BOARD_HAL_STATIC_LIBRARIES := libhealthd.msm

BOARD_HAVE_BLUETOOTH := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := \
  device/google/clockwork/include/bluetooth \
  $(BOARD_COMMON_DIR)

PMIC_QG_SUPPORT := true

#Generate DTBO image
BOARD_KERNEL_SEPARATED_DTBO := true

BOARD_VNDK_VERSION := current
TARGET_USES_64_BIT_BINDER := true

# Set Header version for bootimage
BOARD_BOOTIMG_HEADER_VERSION := 1
BOARD_MKBOOTIMG_ARGS := --header_version $(BOARD_BOOTIMG_HEADER_VERSION)

ifeq ($(BOARD_KERNEL_SEPARATED_DTBO),true)
    # Enable DTBO for recovery image
    BOARD_INCLUDE_RECOVERY_DTBO := true
endif

TARGET_USES_LM := true

# This package must contain a classes.dex to function properly
dex2oat_blacklist := ClockworkPlayAutoInstallConfig \
                     ClockworkBugReportSender \
                     PrebuiltBugleWearable \
                     PrebuiltDeskClockMicroApp \
                     TalkbackWearPrebuilt \
                     TranslatePrebuiltWearable \
                     VZMessages


$(call add-product-dex-preopt-module-config,$(dex2oat_blacklist),disable)
