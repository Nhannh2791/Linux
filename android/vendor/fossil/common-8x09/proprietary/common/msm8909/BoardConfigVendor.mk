# BoardConfigVendor.mk
# Qualcomm Technologies proprietary product specific compile-time definitions.

# Disabling GMS as part of Bring-up
TARGET_GMS_DISABLE := true

USE_CAMERA_STUB := false
ifeq ($(TARGET_KERNEL_VERSION), 4.9)
    WIFI_DRIVER_INSTALL_TO_KERNEL_OUT := true
endif
BOARD_USES_QTI_HARDWARE := true
BOARD_USES_ADRENO := true
HAVE_ADRENO_SOURCE := true
HAVE_ADRENO_SC_SOURCE := true
HAVE_ADRENO_FIRMWARE := true
#ENABLE_WEBGL := true
#BOARD_USE_QCOM_LLVM_CLANG_RS := true
TARGET_USES_ION := true
USE_OPENGL_RENDERER := true
#TARGET_USES_C2D_COMPOSITION := true

TARGET_USES_ASHMEM := true
TARGET_USES_SECURITY_BRIDGE := true
TARGET_USES_POST_PROCESSING := true
TARGET_USE_SBC_DECODER := true

ifeq ($(TARGET_USES_AOSP),true)
  BOARD_VENDOR_QCOM_LOC_PDK_FEATURE_SET := false
  BOARD_USES_DPM := false
  TARGET_FASTCV_DISABLED := true
  TARGET_SCVE_DISABLED := true
else
  BOARD_VENDOR_QCOM_LOC_PDK_FEATURE_SET := false
ifneq ($(TARGET_SUPPORTS_WEARABLES),true)
  BOARD_USES_DPM := true
  CONFIG_EAP_PROXY := qmi
endif
endif

#AUDIO_FEATURE_FLAGS
BOARD_USES_ALSA_AUDIO := true
BOARD_SUPPORTS_SOUND_TRIGGER := true
BOARD_SUPPORTS_QSTHW_API := true
USE_XML_AUDIO_POLICY_CONF := 1
AUDIO_FEATURE_ENABLED_SOURCE_TRACKING := true
AUDIO_FEATURE_ENABLED_FLUENCE := true
AUDIO_FEATURE_ENABLED_HFP := true
AUDIO_FEATURE_ENABLED_MULTI_VOICE_SESSIONS := true
AUDIO_FEATURE_ENABLED_KPI_OPTIMIZE := true
AUDIO_FEATURE_ENABLED_BG_KEYWORD_DETECTION := true
AUDIO_FEATURE_ENABLED_ACDB_LICENSE := true
AUDIO_FEATURE_ENABLED_DYNAMIC_LOG := false
MM_AUDIO_ENABLED_FTM := true
TARGET_USES_QCOM_MM_AUDIO := true
AUDIO_FEATURE_ENABLED_SND_MONITOR := true
AUDIO_FEATURE_ENABLED_BG_CAL := true
AUDIO_FEATURE_ENABLED_A2DP_OFFLOAD := true
AUDIO_FEATURE_ENABLED_PM_SUPPORT := true
#AUDIO_FEATURE_FLAGS

ifeq ($(CLOCKWORK_ENABLE_TELEPHONY),true)
#Enable IMS and CNE
TARGET_USES_IMS := true
endif

ifneq ($(TARGET_SUPPORTS_WEARABLES),true)
BOARD_USES_QCNE := true
endif

#GPS FEATURE FLAGS
BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := default
#BOARD_VENDOR_QCOM_LOC_PDK_FEATURE_SET := true
ifeq ($(TARGET_SUPPORTS_ANDROID_WEAR),true)
LW_FEATURE_SET := true
endif
#END

BOARD_HAS_QCOM_WLAN := true
ifneq ($(wildcard $(QCPATH)/mdm-helper/libmdmdetect),)
 CONFIG_EAP_PROXY_MDM_DETECT := true
endif
CONFIG_EAP_PROXY_DUAL_SIM := true
CONFIG_EAP_PROXY_AKA_PRIME := true
#BOARD_HAS_ATH_WLAN_AR6004 := true
BOARD_HAVE_BLUETOOTH := true
#BOARD_HAS_QCA_BT_AR3002 := true
#BOARD_HAVE_QCOM_FM := true

ifeq ($(TARGET_USES_AOSP),false)
BOARD_ANT_WIRELESS_DEVICE := "vfs-prerelease"
endif

ifeq ($(BOARD_HAVE_BLUETOOTH), true)
  # Comment the following flag to enable bluedriod
  BOARD_HAVE_BLUETOOTH_BLUEZ := false
  ifneq ($(BOARD_HAVE_BLUETOOTH_BLUEZ), true)
    TARGET_HAS_SPLIT_A2DP_FEATURE := true
    BOARD_HAVE_BLUETOOTH_QCOM := true
    QCOM_BT_USE_SMD_TTY := true
    BLUETOOTH_HCI_USE_MCT := true
    BOARD_USES_WIPOWER := false
  endif # BOARD_HAVE_BLUETOOTH_BLUEZ
endif # BOARD_HAVE_BLUETOOTH

ifeq ($(findstring true,$(BOARD_HAS_ATH_WLAN_AR6004) $(BOARD_HAS_QCOM_WLAN)),true)
  BOARD_WLAN_DEVICE := qcwcn
  BOARD_WPA_SUPPLICANT_DRIVER := NL80211
  BOARD_HOSTAPD_DRIVER := NL80211
  WIFI_DRIVER_INSTALL_TO_KERNEL_OUT := true
  ifeq ($(PRODUCT_VENDOR_MOVE_ENABLED),true)
    ifeq ($(TARGET_KERNEL_VERSION), 4.9)
      WIFI_DRIVER_MODULE_PATH := "/system/vendor/lib/modules/wlan.ko"
    else
      WIFI_DRIVER_MODULE_PATH := "/vendor/lib/modules/wlan.ko"
    endif
  else
  WIFI_DRIVER_MODULE_PATH := "/system/lib/modules/wlan.ko"
  endif
  WIFI_DRIVER_MODULE_NAME := "wlan"
  WIFI_DRIVER_MODULE_ARG := ""
  WPA_SUPPLICANT_VERSION := VER_0_8_X
  HOSTAPD_VERSION := VER_0_8_X
  # JB MR1 or later
  BOARD_HAS_CFG80211_KERNEL3_4 := true
  # KitKat
  ifeq ($(call is-platform-sdk-version-at-least,19),true)
    BOARD_HAS_CFG80211_KERNEL3_4 := false
    BOARD_HAS_CFG80211_KERNEL3_10 := true
  endif
  BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
  BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
endif

# TODO: Bring-up exception - all modules must be fixed by corresponding teams
INTERNAL_LOCAL_CLANG_EXCEPTION_PROJECTS += \
 $(abspath $(TOPDIR)$(QCPATH)/gles/adreno200) \
 $(QCPATH)/gles/adreno200 \
  $(QCPATH)/fastcv-noship \
  $(QCPATH)/gps-noship \
  $(QCPATH)/kernel-tests \
  $(QCPATH)/mare-noship \
  $(QCPATH)/mm-camera-lib \
  $(QCPATH)/mm-camera/mm-camera2/media-controller/modules/imglib \
  $(QCPATH)/mm-camera/mm-camera2/tests \
  $(QCPATH)/mm-mux


# TODO: Bring-up exception - all modules must be fixed by corresponding teams 	121
TARGET_CINCLUDES_EXCEPTION_PROJECTS := \
  $(abspath $(TOPDIR)$(QCPATH)/gles/adreno200) \
  $(QCPATH)/gles/adreno200 \
  $(QCPATH)/gps-noship-external \
  $(QCPATH)/gps-noship \
  disregard/filesystems/mtd-utils

ifeq ($(TARGET_USES_AOSP),true)
ALLOW_MISSING_DEPENDENCIES := true
endif
