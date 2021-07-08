# Copyright (C) 2011 The Android Open-Source Project
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

TARGET_USES_FOSSIL_COMMON_8X09 := true

TARGET_ARCH := arm

BOARD_USES_GENERIC_AUDIO := true
USE_CAMERA_STUB := false

-include $(QCPATH)/common/msm8909/BoardConfigVendor.mk

#TODO: Fix-me: Setting TARGET_HAVE_HDMI_OUT to false
# to get rid of compilation error.
TARGET_HAVE_HDMI_OUT := false
TARGET_USES_OVERLAY := true
TARGET_USES_PCI_RCS := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_NO_RPC := true
GET_FRAMEBUFFER_FORMAT_FROM_HWC := true

TARGET_NO_BOOTLOADER := true
# TARGET_NO_KERNEL := true
TARGET_NO_RADIOIMAGE := true

DISABLE_BACKUP_AGENT := true
DISABLE_DRMPLUGIN := true
BOOTLOADER_GCC_VERSION := arm-linux-androideabi-4.9

TARGET_CPU_ABI  := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a7
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_SMP := true
ARCH_ARM_HAVE_TLS_REGISTER := true

TARGET_HARDWARE_3D := false

# duplicate def'n in device/fossil/common-8x09/device-common.mk
TARGET_BOARD_PLATFORM := msm8909

BOARD_ROOT_EXTRA_FOLDERS := persist
BOARD_ROOT_EXTRA_SYMLINKS := /vendor/firmware_mnt:/firmware

BOARD_SECCOMP_POLICY := device/fossil/common-8x09/seccomp

# TARGET_USES_UNCOMPRESSED_KERNEL := false

# Support to build images for 2K NAND page
# BOARD_KERNEL_2KPAGESIZE := 2048
# BOARD_KERNEL_2KSPARESIZE := 64

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

TARGET_USERIMAGES_USE_EXT4 := true
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PERSISTIMAGE_FILE_SYSTEM_TYPE := ext4

TARGET_USES_AOSP := false

TARGET_USE_QCOM_BIONIC_OPTIMIZATION := true
TARGET_USE_KINGFISHER_OPTIMIZATION := true

BOARD_KERNEL_CMDLINE := androidboot.hardware=$(TARGET_DEVICE) msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1

ifeq ($(TARGET_BUILD_VARIANT), user)
    BOARD_KERNEL_CMDLINE += console=/dev/null androidboot.console=/dev/null
else
    BOARD_KERNEL_CMDLINE += console=ttyMSM0,115200,n8 androidboot.console=ttyMSM0
    ifeq ($(TARGET_SUPPORTS_QCOM_3100), true)
        BOARD_KERNEL_CMDLINE += earlycon=msm_hsl_uart,0x78af000
    else
        BOARD_KERNEL_CMDLINE += earlycon=msm_hsl_uart,0x78b0000
    endif
endif

BOARD_EGL_CFG := device/fossil/common-8x09/egl.cfg

# device side HIDL
TARGET_USES_HWC2 := true
TARGET_USES_GRALLOC1 := true

TARGET_RECOVERY_FSTAB := device/fossil/$(TARGET_DEVICE)/recovery_$(TARGET_DEVICE).fstab

TARGET_RECOVERY_UPDATER_LIBS := librecovery_updater_fossil_common
TARGET_RELEASETOOLS_EXTENSIONS := device/fossil/common-8x09/common

# fix CTS: CtsNetTestCases: bug: 130690422
include device/google/clockwork/build/ClockworkBoardConfig.mk

ifeq ($(TARGET_USES_FOSSIL_COMMON_RECOVERY_UI_390P_LIB),true)
    TARGET_RECOVERY_UI_LIB := librecovery_ui_wear
    TARGET_RECOVERY_UI_MARGIN_HEIGHT := 65
    TARGET_RECOVERY_UI_MARGIN_WIDTH := 45
    TARGET_PRIVATE_RES_DIRS += device/fossil/common-8x09/recovery/390p/res
else ifeq ($(TARGET_USES_FOSSIL_COMMON_RECOVERY_UI_LIB),true)
    TARGET_RECOVERY_UI_LIB := librecovery_ui_wear
    TARGET_RECOVERY_UI_MARGIN_HEIGHT := 75
    TARGET_RECOVERY_UI_MARGIN_WIDTH := 35
    TARGET_PRIVATE_RES_DIRS += device/fossil/common-8x09/recovery/common/res
endif

BOARD_HAL_STATIC_LIBRARIES := libdumpstate.$(TARGET_DEVICE)

# Add NON-HLOS files for ota upgrade
ADD_RADIO_FILES ?= true

# Added to indicate that protobuf-c is supported in this build
PROTOBUF_SUPPORTED := true

TARGET_USES_ION := true
TARGET_USES_NEW_ION_API :=true
TARGET_USES_QCOM_BSP := false

TARGET_INIT_VENDOR_LIB := libinit_msm
TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/

TARGET_LDPRELOAD := libNimsWrap.so

#Enable peripheral manager
TARGET_PER_MGR_ENABLED := true

MALLOC_SVELTE := true

#Enable HW based full disk encryption
TARGET_HW_DISK_ENCRYPTION := false

ifeq (,$(wildcard vendor/google/))
# Limit dex-preopt when building from PDK.
WITH_DEXPREOPT_BOOT_IMG_AND_SYSTEM_SERVER_ONLY := true
DONT_DEXPREOPT_PREBUILTS := true
else
# Enable dex pre-opt to speed up initial boot
WITH_DEXPREOPT ?= true
ifeq (false, $(WITH_DEXPREOPT))
WITH_DEXPREOPT_BOOT_IMG_AND_SYSTEM_SERVER_ONLY := true
endif
endif

#Enable SSC Feature
TARGET_USES_SSC := true

# Enable sensor multi HAL
USE_SENSOR_MULTI_HAL := true

AUDIO_FEATURE_ENABLED_LISTEN := false

#FEATURE_QCRIL_UIM_SAP_SERVER_MODE := true

BOARD_HAVE_BLUETOOTH := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := \
  device/fossil/common-8x09/opensource/bluetooth \
  device/google/clockwork/include/bluetooth

#add suffix variable to uniquely identify the board
TARGET_BOARD_SUFFIX := w

#Enable Smart ART Mode
WITH_ART_SMALL_MODE := true

# Control flag between KM versions
TARGET_HW_KEYMASTER_V03 := false

#Flag to enable VNDK.
BOARD_VNDK_VERSION := current

# Vendor Interface Manifest
DEVICE_MANIFEST_FILE := device/fossil/common-8x09/manifest.xml
DEVICE_MATRIX_FILE := device/fossil/common-8x09/compatibility_matrix.xml

ifeq ($(TARGET_SUPPORTS_QCOM_3100),true)
DEVICE_MANIFEST_FILE += device/fossil/common-8x09/cas.xml
endif

DEVICE_MANIFEST_FILE += device/fossil/common-8x09/vibrator.xml

# 64-bit binder interface is mandatory from Android P
TARGET_USES_64_BIT_BINDER := true

# TODO(b/37572490): The Qualcomm makefiles are broken
ALLOW_MISSING_DEPENDENCIES := true

BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
