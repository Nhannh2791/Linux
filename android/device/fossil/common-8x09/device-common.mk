#
# Copyright (C) 2018 The Android Open-Source Project
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

DEVICE_PACKAGE_OVERLAYS += \
    device/fossil/$(TARGET_DEVICE)/overlay \
    device/fossil/common-8x09/overlay

PRODUCT_SOONG_NAMESPACES := device/fossil/common-8x09

PRODUCT_SOONG_NAMESPACES += \
    hardware/qcom/display/msm8909w_3100 \
    vendor/fossil/common-8x09/proprietary

ifeq ($(TARGET_PREBUILT_KERNEL),)
    LOCAL_KERNEL := device/fossil/$(TARGET_DEVICE)-kernel/kernel
else
    LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

TARGET_USES_QCOM_BSP := true
TARGET_USES_NQ_NFC := true
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

QCPATH := vendor/fossil/common-8x09/proprietary

# TODO(alainv): Replace this in the makefiles.
BOARD_COMMON_DIR := device/fossil/common-8x09/common

# copied from BoardConfigCommon to ensure inherited product
# configs can pick this up
TARGET_BOARD_PLATFORM := msm8909

BOARD_DISPLAY_HAL := hardware/qcom/display/msm8909
#BOARD_BT_HAL := hardware/qcom/bt/msm8909
#BOARD_WLAN_HAL := hardware/qcom/wlan
BOARD_OPENSOURCE_DIR := device/fossil/common-8x09
WIFI_VENDOR_CYPRESS_PATH := vendor/cypress
PRODUCT_COPY_FILES += \
    $(WIFI_VENDOR_CYPRESS_PATH)/firmware/sta/brcmfmac43012-sdio.bin:vendor/firmware/brcmfmac/sta/brcmfmac43012-sdio.bin \
    $(WIFI_VENDOR_CYPRESS_PATH)/firmware/sta/brcmfmac43012-sdio.clm_blob:vendor/firmware/brcmfmac/sta/brcmfmac43012-sdio.clm_blob \
    $(WIFI_VENDOR_CYPRESS_PATH)/firmware/ap/brcmfmac43012-sdio.bin:vendor/firmware/brcmfmac/ap/brcmfmac43012-sdio.bin \
    $(WIFI_VENDOR_CYPRESS_PATH)/firmware/ap/brcmfmac43012-sdio.clm_blob:vendor/firmware/brcmfmac/ap/brcmfmac43012-sdio.clm_blob \
    $(WIFI_VENDOR_CYPRESS_PATH)/nvram/brcmfmac43012-sdio.txt:vendor/firmware/brcmfmac/sta/brcmfmac43012-sdio.txt

TARGET_SUPPORTS_WEARABLES := true

TARGET_SUPPORTS_ANDROID_WEAR := true

BUILD_FELDSPAR_PDK := true

# Disable QTIC until it's brought up in split system/vendor
# configuration to avoid compilation breakage.
ifeq ($(ENABLE_VENDOR_IMAGE), true)
TARGET_USES_QTIC := false
endif

ifeq ($(TARGET_USES_QCOM_BT), true)
    # Enable Qcomm SOC LOGGING flag
    TARGET_ENABLE_QC_BT_SOC_LOG := true
endif #TARGET_USES_QCOM_BT

#QTIC flag
-include $(QCPATH)/common/config/qtic-config.mk

ifeq ($(strip $(TARGET_USES_QTIC)),true)
# font rendering engine feature switch
-include $(QCPATH)/common/config/rendering-engine.mk
ifneq (,$(strip $(wildcard $(PRODUCT_RENDERING_ENGINE_REVLIB))))
    MULTI_LANG_ENGINE := REVERIE
endif
endif

#Enable DM_VERITY support
PRODUCT_SYSTEM_VERITY_PARTITION := /dev/block/platform/soc/7824900.sdhci/by-name/system
ifeq ($(ENABLE_VENDOR_IMAGE), true)
PRODUCT_VENDOR_VERITY_PARTITION := /dev/block/platform/soc/7824900.sdhci/by-name/vendor
endif

$(call inherit-product, build/target/product/verity.mk)

# video seccomp policy files
PRODUCT_COPY_FILES += \
    device/fossil/common-8x09/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/fossil/common-8x09/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.bt.bdaddr_path=/persist/bdaddr.txt

#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android

PRODUCT_PACKAGES += \
    libqcomvisualizer \
    libqcompostprocbundle \
    libqcomvoiceprocessing

#OEM Services library
PRODUCT_PACKAGES += oem-services
PRODUCT_PACKAGES += libsubsystem_control
PRODUCT_PACKAGES += libSubSystemShutdown

PRODUCT_PACKAGES += wcnss_service

# zram-perf
PRODUCT_PACKAGES += \
    zram-perf

# System tools
PRODUCT_PACKAGES += \
    applypatch \
    e2fsck \
    libdl \
    local_time.default \
    make_ext4fs \
    power.default \
    run-as \
    setup_fs \
    libgabi++

#Healthd 2.0 packages
PRODUCT_PACKAGES += \
    android.hardware.health@2.0-service.fossil

# Trigger PPG when on|off charger
PRODUCT_PACKAGES += \
    fs-ppg

# Bluetooth
PRODUCT_PACKAGES += \
    bluetooth.default

$(call inherit-product, $(BOARD_COMMON_DIR)/common.mk)

# NFC packages
ifeq ($(TARGET_USES_NQ_NFC),true)

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.nfc_nci=msm8909w

PRODUCT_PACKAGES += \
    NfcNci \
    libnfc-nci \
    libnfc_nci_jni \
    android.hardware.nfc@1.1-service \
    libpn553_fw.so \
    libnfc-nci.conf \
    libnfc-nxp.conf \
    com.android.nfc_extras

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/com.android.nfc_extras.xml:system/etc/permissions/com.android.nfc_extras.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:system/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:system/etc/permissions/android.hardware.nfc.hcef.xml

endif # TARGET_USES_NQ_NFC

PRODUCT_COPY_FILES += \
    device/fossil/common-8x09/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini \
    device/fossil/common-8x09/WCNSS_cfg.dat:persist/WCNSS_wlan_dictionary.dat \
    device/fossil/common-8x09/WCNSS_qcom_wlan_nv.bin:persist/WCNSS_qcom_wlan_nv.bin

# Listen configuration file
PRODUCT_COPY_FILES += \
    device/fossil/common-8x09/listen_platform_info.xml:system/etc/listen_platform_info.xml

# Sensor HAL conf file
PRODUCT_COPY_FILES += \
    device/fossil/common-8x09/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

# wifi configuration files.
PRODUCT_COPY_FILES += \
    device/fossil/common-8x09/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf

PRODUCT_COPY_FILES += \
    device/fossil/common-8x09/privapp-permissions-qti.xml:system/etc/permissions/com.qualcomm.qti.twm.xml

PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel \

# Power key configuration file
ifneq (,$(wildcard device/fossil/$(TARGET_DEVICE)/qpnp_pon.kl))
    PRODUCT_COPY_FILES += \
        device/fossil/$(TARGET_DEVICE)/qpnp_pon.kl:system/usr/keylayout/qpnp_pon.kl \
        device/fossil/$(TARGET_DEVICE)/qpnp_pon.kcm:system/usr/keychars/qpnp_pon.kcm
endif

# GPIO key configuration file
ifneq (,$(wildcard device/fossil/$(TARGET_DEVICE)/gpio-keys.kl))
PRODUCT_COPY_FILES += \
    device/fossil/$(TARGET_DEVICE)/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl
endif

# HIDL impls

PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-impl \
    android.hardware.audio@2.0-service \
    android.hardware.audio.effect@2.0-impl \
    android.hardware.audio@4.0 \
    android.hardware.audio@4.0-impl \
    android.hardware.audio.effect@4.0 \
    android.hardware.audio.effect@4.0-impl \
    android.hardware.configstore@1.0-service \
    android.hardware.dumpstate@1.0-service.fossil \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service \
    android.hardware.power@1.0-impl \
    android.hardware.power@1.0-service \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    android.hardware.sensors@1.0-impl \
    android.hardware.sensors@1.0-service \
    android.hardware.wifi@1.0-service \
    vendor.qti.hardware.vibrator@1.2-service


#Enable AOSP KEYMASTER and GATEKEEPER HIDLs
ifneq ($(KMGK_USE_QTI_SERVICE), true)
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service
endif

# Device features.
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/wearable_core_hardware.xml:system/etc/permissions/wearable_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.screen.portrait.xml:system/etc/permissions/android.hardware.screen.portrait.xml \
    frameworks/native/data/etc/android.software.connectionservice.xml:system/etc/permissions/android.software.connectionservice.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:system/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:system/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.xml

# Audio packages
PRODUCT_PACKAGES += \
    audio.a2dp.default \
    audio.primary.msm8909 \
    audio.r_submix.default \
    libaudio-resampler \
    audio.stub.default

# Audio configuration.
USE_XML_AUDIO_POLICY_CONF := 1

PRODUCT_COPY_FILES += \
    frameworks/av/media/libeffects/data/audio_effects.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.conf \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/stub_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/stub_audio_policy_configuration.xml \
    device/fossil/common-8x09/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml \
    device/fossil/common-8x09/mixer_paths_msm8909_pm8916.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths_msm8909_pm8916.xml

# Audio configuration for 3100.
PRODUCT_COPY_FILES += \
    device/fossil/common-8x09/audio_config/audio_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_platform_info.xml \
    device/fossil/common-8x09/audio_config/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    device/fossil/common-8x09/audio_config/graphite_ipc_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/graphite_ipc_platform_info.xml \
    device/fossil/common-8x09/audio_config/mixer_paths_bg.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths_bg.xml \
    device/fossil/common-8x09/audio_config/sound_trigger_mixer_paths_bg.xml:$(TARGET_COPY_OUT_VENDOR)/etc/sound_trigger_mixer_paths_bg.xml \
    device/fossil/common-8x09/audio_config/sound_trigger_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/sound_trigger_platform_info.xml

PRODUCT_COPY_FILES += \
    device/fossil/common-8x09/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml

#add target thermal-engine.conf
ifneq (,$(wildcard device/fossil/$(TARGET_DEVICE)/thermal-engine.conf))
PRODUCT_COPY_FILES += \
    device/fossil/$(TARGET_DEVICE)/thermal-engine.conf:$(TARGET_COPY_OUT_VENDOR)/etc/thermal-engine.conf
endif

PRODUCT_COPY_FILES += \
    device/fossil/common-8x09/init.target_common.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.rc \
    device/fossil/$(TARGET_DEVICE)/init.audio_$(TARGET_DEVICE).rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.audio.rc


ifeq ($(TARGET_SUPPORTS_QCOM_3100), true)
#Adding twm charging WF
PRODUCT_COPY_FILES += \
   device/fossil/common-8x09/twm/twm_usb_charging.png:$(TARGET_COPY_OUT_VENDOR)/skghal/twm/images/twm_usb_charging.png
endif

# gps/location secuity configuration file
PRODUCT_COPY_FILES += \
    device/fossil/common-8x09/common/sec_config:$(TARGET_COPY_OUT_VENDOR)/etc/sec_config

# GPS configuration file.
ifeq ($(TARGET_USES_GPS),true)
PRODUCT_COPY_FILES += \
    device/fossil/common-8x09/gps.conf:$(TARGET_COPY_OUT_VENDOR)/etc/gps.conf
endif

# Touchscreen configuration file
PRODUCT_COPY_FILES += \
	device/fossil/common-8x09/raydium_ts.idc:system/usr/idc/raydium_ts.idc \
	device/fossil/common-8x09/raydium_ts.kl:system/usr/keylayout/raydium_ts.kl

#IDC file for rotating BG switch
ifeq ($(TARGET_USES_RSB),true)
#configure for target
# Init res_x script of RSB
PRODUCT_COPY_FILES += \
    device/fossil/$(TARGET_DEVICE)/bg-spi.idc:system/usr/idc/bg-spi.idc \
    device/fossil/$(TARGET_DEVICE)/init.rsb.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.rsb.sh
endif

# Disable elements watchfaces
CLOCKWORK_DISABLE_ELEMENTS_WATCHFACES := true

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    config.disable_networktime=true

PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196608

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ambient.plugged_timeout_min=10

# Set logcat buffer size to 1Mb for userdebug and eng build
ifneq (,$(filter eng userdebug, $(TARGET_BUILD_VARIANT)))
PRODUCT_PROPERTY_OVERRIDES += \
    ro.logd.size=1048576
endif

# Enable FIFO UI scheduling by default
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    sys.use_fifo_ui=1

# Set dex2oat to use 4 threads for faster initial boot time.
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dex2oat-threads=2 \
    dalvik.vm.boot-dex2oat-threads=4

# Enforce privapp-permissions whitelist
PRODUCT_PROPERTY_OVERRIDES += \
    ro.control_privapp_permissions=enforce

# Add Postboot cleanup script
# Add Fossil Property Util Receiver for Postboot script trigger
PRODUCT_PACKAGES += \
    FsPropertyUtils

# Add the enable flag of Postboot cleanup script
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.vendor.fossil.postboot_cleanup.enable=1

# Set specified modules as 'verify' to save system space.
dex2oat_verify_only := \
    $(TARGET_DEX2OAT_OPTIMIZE_SIZE)

# Disable pre-opt entirely for these modules to save additional system space.
dex2oat_blacklist := \
    $(TARGET_DEX2OAT_BLACKLIST) \
    ClockworkShell \
    MinModWatchfaces \
    Shell \
    Volta

$(call add-product-dex-preopt-module-config,$(dex2oat_verify_only),--compiler-filter=verify)
$(call add-product-dex-preopt-module-config,$(dex2oat_blacklist),disable)

ifeq ($(CLOCKWORK_ENABLE_SPEAKER), true)
$(call inherit-product, device/fossil/$(TARGET_DEVICE)/ringtones.mk)
$(call inherit-product, device/google/clockwork/build/clockwork_audio.mk)

# Fossil sound files
FOSSIL_SOUND_PATH := device/fossil/common-8x09/sound-files

# For alarm sound
CLOCKWORK_OVERRIDE_AUDIO_ALARMS := true
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.alarm_alert=Carbon.ogg
PRODUCT_COPY_FILES += \
    $(FOSSIL_SOUND_PATH)/alarms/Carbon.ogg:system/media/audio/alarms/Carbon.ogg

# For notification sound
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.config.notification_sound=Rhea.ogg
PRODUCT_COPY_FILES += \
    $(FOSSIL_SOUND_PATH)/notifications/Rhea.ogg:system/media/audio/notifications/Rhea.ogg

# Charging sound
PRODUCT_COPY_FILES += \
    ${FOSSIL_SOUND_PATH}/charging/LookAtMe.ogg:system/media/audio/ui/ChargingStarted.ogg
endif

# Metrics sensors
ifeq ($(TARGET_SUPPORTS_SIDEKICK_METRICS), true)
    PRODUCT_COPY_FILES += \
        device/fossil/common-8x09/ssohal/metric_sensors_list.txt:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/metric_sensors_list.txt
endif

$(call inherit-product, device/google/clockwork/build/wearable-mdpi-1024-dalvik-heap.mk)
$(call inherit-product, device/google/clockwork/build/clockwork_google.mk)
# include clockwork-services, if present (for full-source PDK builds)
$(call inherit-product-if-exists,vendor/google_clockwork/products/clockwork_services.mk)
$(call inherit-product-if-exists, vendor/qcom/gpu/msm8909/msm8909-gpu-vendor.mk)

$(call inherit-product, hardware/qcom/msm8x09/msm8x09.mk)

$(call inherit-product, device/fossil/common-8x09/device-selinux.mk)

ifeq ($(TARGET_SUPPORTS_QCOM_3100), true)
PRODUCT_VENDOR_KERNEL_HEADERS := device/fossil/common-8x09/headers/kernel-headers
endif
