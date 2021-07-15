#
# Copyright (C) 2020 The Android Open-Source Project
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

# common namespace
PRODUCT_SOONG_NAMESPACES := \
    hardware/qcom/sdm429w/display \
    vendor/qcom/sdm429w-common/proprietary \
    vendor/fossil/common/proprietary \
    vendor/qcom/sdm429w/codeaurora/thermal-engine \
    vendor/qcom/sdm429w/codeaurora/vibrator

########## WEARABLES Specific Flags  #####################

# Flag to be used when applicable for both LW and LAW
TARGET_SUPPORTS_WEARABLES := true

# Flag to be used when applicable only for LW
TARGET_SUPPORTS_ANDROID_WEAR := true

#For targets which donot support vulkan
TARGET_NOT_SUPPORT_VULKAN := false

#For targets which support vulkan version 1.1
TARGET_SUPPORT_VULKAN_VERSION_1_1 := true

BOARD_COMMON_SDM429W_DIR := device/fossil/common-sdm429w/common
BOARD_COMMON_DIR := device/fossil/common/common
BOARD_SEPOLICY_DIR := device/fossil/common/sepolicy
BOARD_OPENSOURCE_DIR := device/fossil/common/opensource

BOARD_BT_DIR := hardware/qcom/sdm429w/bt
BOARD_DLKM_DIR := $(BOARD_COMMON_DIR)/dlkm

DEVICE_PACKAGE_OVERLAYS := \
    device/fossil/common/overlay \
    device/fossil/common-sdm429/overlay \
    device/fossil/$(TARGET_DEVICE)/overlay

BOARD_DISPLAY_HAL := hardware/qcom/sdm429w/display

AUDIO_FEATURE_ENABLED_DLKM := false
TARGET_EXCLUDES_DISPLAY_PP := true

CLOCKWORK_DISABLE_GOOGLE_TTS := true
INCLUDE_GOOGLE_SANS_FONT := false
CLOCKWORK_ENABLE_HERO_ANGELSWORD_WATCHFACES :=
CLOCKWORK_DISABLE_HANDWRITING := true
CLOCKWORK_INCLUDE_OEM_SETUP :=
#CLOCKWORK_ENABLE_DEFAULT_CHARGING_SCREEN := true

CLOCKWORK_DISABLE_RETAIL_ATTRACT_LOOP := false

#Adding twm charging WF

PRODUCT_COPY_FILES += \
    $(BOARD_COMMON_DIR)/twm/twm_usb_charging.png:vendor/skghal/twm/images/twm_usb_charging.png \
    $(BOARD_COMMON_DIR)/twm/twm_usb_charging_gray.png:vendor/skghal/twm/images/twm_usb_charging_gray.png \
    $(BOARD_COMMON_DIR)/twm/twm_low_battery.png:vendor/skghal/twm/images/twm_low_battery.png \
    $(BOARD_COMMON_DIR)/twm/twm_low_battery_gray.png:vendor/skghal/twm/images/twm_low_battery_gray.png \
    $(BOARD_COMMON_DIR)/ssohal/metric_sensors_list.txt:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/metric_sensors_list.txt

# Enable Traditional Watch Mode (TWM)
CLOCKWORK_ENABLE_TRADITIONAL_WATCH_MODE := true

#Disable split mode for wearables
PRODUCT_PROPERTY_OVERRIDES += \
  vendor.vidc.disable.split.mode=1

PRODUCT_PROPERTY_OVERRIDES += \
  dalvik.vm.dex2oat-threads=4 \
  dalvik.vm.boot-dex2oat-threads=4

ifeq ($(TARGET_SUPPORTS_ANDROID_WEAR_KERNEL_4_14),true)
    PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
        ro.vendor.skghal.version=v1_2
endif

# Enable Haptics in TWM by default
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.vendor.enable_haptics_twm=true

# Set BT chip type to cherokee for kernel 4.14
ifeq ($(TARGET_SUPPORTS_ANDROID_WEAR_KERNEL_4_14),true)
  #system prop for bluetooth SOC type
  PRODUCT_PROPERTY_OVERRIDES += \
    vendor.qcom.bluetooth.soc=cherokee
endif

# Enable A2DP offload
PRODUCT_PROPERTY_OVERRIDES += \
    ro.bluetooth.a2dp_offload.supported=true

# Vendor property for enable A2DP offload
PRODUCT_PROPERTY_OVERRIDES += \
    persist.bluetooth.a2dp_offload.disabled =false \

# A2DP offload DSP supported encoder list
PRODUCT_PROPERTY_OVERRIDES += \
    persist.bluetooth.a2dp_offload.cap=sbc \
    ro.vendor.qti.config.ulmk_memcg=false

#SidekickGraphics HAL
PRODUCT_PACKAGES += \
    vendor.google_clockwork.sidekickgraphics@1.0 \
    vendor.google_clockwork.sidekickgraphics@1.1 \
    vendor.qti.hardware.sidekickmetrics@1.0

# System tools
PRODUCT_PACKAGES += \
    applypatch \
    e2fsck \
    libdl \
    libgabi++ \
    local_time.default \
    make_ext4fs \
    power.default \
    run-as \
    setup_fs

PRODUCT_PACKAGES += \
    ClockworkExampleWatchFace \
    ExtServices \
    ExtShared

PRODUCT_CHARACTERISTICS := nosdcard,watch

# Support for new wear boot animation
PRODUCT_COPY_FILES += \
    device/google/clockwork/bootanimations/square_360/bootanimation.zip:system/media/bootanimation.zip

#PDK related changes
$(call inherit-product-if-exists, vendor/qcom/gpu/msm8937/msm8937-gpu-vendor.mk)

$(call inherit-product-if-exists, hardware/qcom/msm8x37/msm8x37.mk)

# Set logcat buffer size to 1Mb for userdebug and eng build
ifneq (,$(filter eng userdebug, $(TARGET_BUILD_VARIANT)))
PRODUCT_PROPERTY_OVERRIDES += \
    ro.logd.size=1048576
endif

# enable FIFO UI scheduling by default
PRODUCT_PROPERTY_OVERRIDES += \
  sys.use_fifo_ui=1

############### End Wearables Specfic Flags ################

ALLOW_MISSING_DEPENDENCIES=true
# Enable AVB 2.0
BOARD_AVB_ENABLE := true
# Enable chain partition for system, to facilitate system-only OTA in Treble.
BOARD_AVB_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_SYSTEM_ROLLBACK_INDEX := 0
BOARD_AVB_SYSTEM_ROLLBACK_INDEX_LOCATION := 2

TARGET_USES_AOSP := true
TARGET_USES_AOSP_FOR_AUDIO := true
TARGET_USES_QCOM_BSP := false

ifeq ($(TARGET_USES_AOSP),true)
TARGET_DISABLE_DASH := true
endif

# Default vendor configuration.
ifeq ($(ENABLE_VENDOR_IMAGE),)
ENABLE_VENDOR_IMAGE := true
endif

TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

-include $(QCPATH)/common/config/qtic-config.mk

# media_profiles and media_codecs xmls for msm8937
ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS), true)
PRODUCT_COPY_FILES += \
    $(BOARD_COMMON_SDM429W_DIR)/media/media_profiles_8937.xml:system/etc/media_profiles.xml \
    $(BOARD_COMMON_SDM429W_DIR)/media/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_vendor.xml \
    $(BOARD_COMMON_SDM429W_DIR)/media/media_profiles_8956.xml:system/etc/media_profiles_8956.xml \
    $(BOARD_COMMON_SDM429W_DIR)/media/media_profiles_8956.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_8956.xml \
    $(BOARD_COMMON_SDM429W_DIR)/media/media_codecs_8937.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    $(BOARD_COMMON_SDM429W_DIR)/media/media_codecs_vendor.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_vendor.xml \
    $(BOARD_COMMON_SDM429W_DIR)/media/media_codecs_8937_v1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_8937_v1.xml \
    $(BOARD_COMMON_SDM429W_DIR)/media/media_codecs_8956.xml::$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_8956.xml \
    $(BOARD_COMMON_SDM429W_DIR)/media/media_codecs_performance_8937.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    $(BOARD_COMMON_SDM429W_DIR)/media/media_codecs_vendor_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_vendor_audio.xml
endif

# BG-RSB Rotating Switch configuration
ifeq ($(TARGET_USES_RSB),true)
# IDC file for rotating BG switch
# Init res_x script of RSB
PRODUCT_COPY_FILES += \
    device/fossil/common/input-devices/init.rsb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.rsb.rc \
    device/fossil/common/input-devices/bg-spi.idc:system/usr/idc/bg-spi.idc \
    device/fossil/common/input-devices/init.rsb.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.rsb.sh
endif

#AOSP NFC PACKAGES
ifeq ($(TARGET_USES_AOSP_NFC),true)
PRODUCT_PACKAGES += \
    NfcNci \
    libnfc-nci \
    libnfc_nci_jni \
    nfc_nci_nxp \
    SecureElement \
    android.hardware.nfc@1.1-service \
    libpn553_fw.so \
    nqnfcinfo \
    com.android.nfc_extras

# NFC config file
PRODUCT_COPY_FILES += \
    vendor/fossil/$(TARGET_DEVICE)/proprietary/nqnfc-firmware/libnfc-nci.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nci.conf \
    vendor/fossil/$(TARGET_DEVICE)/proprietary/nqnfc-firmware/libnfc-nxp.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nxp.conf \
    vendor/fossil/$(TARGET_DEVICE)/proprietary/nqnfc-firmware/libpn557_fw.so:$(TARGET_COPY_OUT_VENDOR)/lib/libpn557_fw.so

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/com.nxp.mifare.xml:system/etc/permissions/com.nxp.mifare.xml \
    frameworks/native/data/etc/com.android.nfc_extras.xml:system/etc/permissions/com.android.nfc_extras.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:system/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:system/etc/permissions/android.hardware.nfc.hcef.xml

endif # TARGET_USES_AOSP_NFC

# video seccomp policy files
PRODUCT_COPY_FILES += \
    device/fossil/common-sdm429w/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/fossil/common-sdm429w/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

PRODUCT_PROPERTY_OVERRIDES += \
    vendor.vidc.disable.split.mode=1 \
    vendor.mediacodec.binder.size=4

$(call inherit-product, $(BOARD_COMMON_DIR)/common.mk)

DEVICE_MATRIX_FILE   := $(BOARD_COMMON_DIR)/compatibility_matrix.xml
DEVICE_FRAMEWORK_MANIFEST_FILE := device/fossil/common/manifest/framework_manifest.xml

DEVICE_MANIFEST_FILE := \
    device/fossil/common/manifest/manifest.xml \
    device/fossil/$(TARGET_DEVICE)/manifest.xml


ifeq ($(TARGET_SUPPORTS_SIDEKICK_GRAPHICS_V1_2), true)
    DEVICE_MANIFEST_FILE += \
        device/fossil/common/manifest/sidekick_1_2.xml
    DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := \
        $(BOARD_COMMON_DIR)/vendor_framework_compatibility_matrix_1_1.xml
else ifeq ($(TARGET_SUPPORTS_SIDEKICK_GRAPHICS_V1_1), true)
    DEVICE_MANIFEST_FILE += \
        device/fossil/common/manifest/sidekick_1_1.xml
    DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := \
        $(BOARD_COMMON_DIR)/vendor_framework_compatibility_matrix_1_0.xml
endif



PRODUCT_BOOT_JARS += oem-services
-include $(QCPATH)/prebuilt_HY11/target/product/sdm429w/prebuilt.mk

# Audio configuration file
-include $(TOPDIR)hardware/qcom/sdm429w/audio/configs/msm8937/msm8937.mk

#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android

PRODUCT_PACKAGES += android.hardware.media.omx@1.0-impl

# Supported languages for Android Wear
PRODUCT_LOCALES := en_US en_GB en_XA de_DE es_ES es_US fr_FR fr_CA it_IT ja_JP ko_KR pt_BR ru_RU

$(call inherit-product, device/google/clockwork/build/clockwork_google.mk)
# List available watch ringtones in Settings->Sound->Watch ringtone option
$(call inherit-product, device/google/clockwork/build/clockwork_ringtones.mk)
# Add all supported software sudio codecs to PRODUCT_PACKAGES
$(call inherit-product, device/google/clockwork/build/clockwork_audio.mk)
# include clockwork-services, if present (for full-source PDK builds)
$(call inherit-product-if-exists,vendor/google_clockwork/products/clockwork_services.mk)

# ANT+ stack
PRODUCT_PACKAGES += \
    AntHalService \
    libantradio \
    antradio_app

# Display/Graphics
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service \
    android.hardware.configstore@1.0-service


# Feature definition files for msm8937
PRODUCT_PROPERTY_OVERRIDES += \
 persist.vendor.sensor.hw.binder.size=8
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.software.connectionservice.xml:system/etc/permissions/android.software.connectionservice.xml \
    device/google/clockwork/data/etc/com.google.clockwork.hardware.sensor.llob.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.google.clockwork.hardware.sensor.llob.xml

#FEATURE_OPENGLES_EXTENSION_PACK support string config file
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml

# Wearcore feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/wearable_core_hardware.xml:system/etc/permissions/wearable_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.audio.output.xml:system/etc/permissions/android.hardware.audio.output.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video_le.xml \
    frameworks/native/data/etc/android.hardware.screen.portrait.xml:system/etc/permissions/android.hardware.screen.portrait.xml \
    frameworks/native/data/etc/android.hardware.sensor.heartrate.xml:system/etc/permissions/android.hardware.sensor.heartrate.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml

# fstab
PRODUCT_PACKAGES += fstab.$(TARGET_DEVICE)

#OEM Services library
PRODUCT_PACKAGES += oem-services
PRODUCT_PACKAGES += libsubsystem_control
PRODUCT_PACKAGES += libSubSystemShutdown

PRODUCT_PACKAGES += wcnss_service

# FBE support
PRODUCT_COPY_FILES += \
    device/fossil/common-sdm429w/init.qti.qseecomd.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qti.qseecomd.sh

# VB xml
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.verified_boot.xml:system/etc/permissions/android.software.verified_boot.xml

# MSM IRQ Balancer configuration file
PRODUCT_COPY_FILES += \
    device/fossil/common-sdm429w/msm_irqbalance.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance.conf

#wlan driver
PRODUCT_COPY_FILES += \
    device/fossil/common-sdm429w/wlan/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini \
    device/fossil/common-sdm429w/wlan/WCNSS_qcom_wlan_nv.bin:persist/WCNSS_qcom_wlan_nv.bin \
    device/fossil/common-sdm429w/wlan/WCNSS_wlan_dictionary.dat:persist/WCNSS_wlan_dictionary.dat


PRODUCT_PACKAGES += \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf


#for wlan
PRODUCT_PACKAGES += \
    wificond \
    wifilogd

ifeq ($(CLOCKWORK_ENABLE_TELEPHONY), true)
    PRODUCT_PACKAGES += telephony-ext
    PRODUCT_BOOT_JARS += telephony-ext
    PRODUCT_PACKAGES += ims-ext-common
    #PRODUCT_BOOT_JARS += ims-ext-common
endif
PRODUCT_TAGS += dalvik.gc.type-precise

# Powerhint configuration file
PRODUCT_COPY_FILES += \
     device/fossil/common-sdm429w/powerhint.xml:system/etc/powerhint.xml

#Healthd 2.0 packages
PRODUCT_PACKAGES += \
    android.hardware.health@2.0-impl \
    android.hardware.health@2.0-service

PRODUCT_FULL_TREBLE_OVERRIDE := true
PRODUCT_VENDOR_MOVE_ENABLED := true

#for android_filesystem_config.h
PRODUCT_PACKAGES += \
    fs_config_files

# Sensor HAL conf file
PRODUCT_COPY_FILES += \
     $(BOARD_COMMON_DIR)/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
     ro.bt.bdaddr_path=/mnt/vendor/persist/bdaddr.ini

PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.0-impl \
    vendor.qti.hardware.vibrator@1.2-service

# Power
PRODUCT_PACKAGES += \
    android.hardware.power@1.0-service \
    android.hardware.power@1.0-impl

PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service

PRODUCT_PACKAGES += \
    vendor.display.color@1.0-service \
    vendor.display.color@1.0-impl

$(call inherit-product, device/google/clockwork/build/wearable-mdpi-512-dalvik-heap.mk)

PRODUCT_PACKAGES += \
    libandroid_net \
    libandroid_net_32

#Enable Lights Impl HAL Compilation
PRODUCT_PACKAGES += android.hardware.light@2.0-impl

#Thermal
PRODUCT_PACKAGES += android.hardware.thermal@1.0-impl \
                    android.hardware.thermal@1.0-service

# Key master settings ##
#set KMGK_USE_QTI_SERVICE to true to enable QTI KEYMASTER and GATEKEEPER HIDLs
KMGK_USE_QTI_SERVICE := true
# Enable KEYMASTER 4.0 for Android P
ENABLE_KM_4_0 := true
DEVICE_MANIFEST_FILE += device/fossil/common/manifest/keymaster_4_0.xml
## End of keymaster ##

ifeq ($(CLOCKWORK_ENABLE_TELEPHONY), true)
    PRODUCT_PROPERTY_OVERRIDES += rild.libpath=/system/vendor/lib/libril-qc-qmi-1.so
    PRODUCT_PROPERTY_OVERRIDES += vendor.rild.libpath=/system/vendor/lib/libril-qc-qmi-1.so
    ifeq ($(TARGET_HAS_LOW_RAM), true)
        PRODUCT_PROPERTY_OVERRIDES += persist.radio.multisim.config=ssss
    endif
    # Enable qcrild and disable rild
    ENABLE_VENDOR_RIL_SERVICE := true
endif



TARGET_MOUNT_POINTS_SYMLINKS := false

SDM660_DISABLE_MODULE := true

#Property for enabling learning module
PRODUCT_PROPERTY_OVERRIDES += vendor.debug.enable.lm=1

# When AVB 2.0 is enabled, dm-verity is enabled differently,
# below definitions are only required for AVB 1.0
ifeq ($(BOARD_AVB_ENABLE),false)
# dm-verity definitions
  PRODUCT_SUPPORTS_VERITY := true
endif

# Enable vndk-sp Libraries
PRODUCT_PACKAGES += vndk_package
PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE := true
TARGET_USES_MKE2FS := true


# Rule for kernel binary
LOCAL_KERNEL := device/fossil/$(TARGET_DEVICE)-kernel/kernel

# Kernel DTBO dir
BOARD_PREBUILT_DTBO_DIRS := device/fossil/$(TARGET_DEVICE)-kernel

# Prebuilt DTBO
BOARD_PREBUILT_DTBOIMAGE := out/target/product/$(TARGET_DEVICE)/prebuilt_dtbo.img

PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel

ifeq ($(TARGET_KERNEL_VERSION),4.9)
  PRODUCT_VENDOR_KERNEL_HEADERS := \
    device/fossil/common-sdm429w/kernel-headers/4.9/kernel-headers
else ifeq ($(TARGET_KERNEL_VERSION),4.14)
  PRODUCT_VENDOR_KERNEL_HEADERS := \
    device/fossil/common-sdm429w/kernel-headers/4.14/kernel-headers
endif

# zram-perf
PRODUCT_PACKAGES += \
    zram-perf

ifeq ($(TARGET_USES_FOSSIL_COMMON), true)
    include device/fossil/common/device-common.mk
endif

