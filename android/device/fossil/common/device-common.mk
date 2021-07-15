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

# Power key configuration file
ifneq (,$(wildcard device/fossil/$(TARGET_DEVICE)/input-devices/qpnp_pon.kl))
    PRODUCT_COPY_FILES += \
        device/fossil/$(TARGET_DEVICE)/input-devices/qpnp_pon.kl:system/usr/keylayout/qpnp_pon.kl \
        device/fossil/$(TARGET_DEVICE)/input-devices/qpnp_pon.kcm:system/usr/keychars/qpnp_pon.kcm
endif

# GPIO key configuration file
ifneq (,$(wildcard device/fossil/$(TARGET_DEVICE)/input-devices/gpio-keys.kl))
PRODUCT_COPY_FILES += \
    device/fossil/$(TARGET_DEVICE)/input-devices/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl
endif


# Touchscreen configuration file
PRODUCT_COPY_FILES += \
	device/fossil/common/raydium_ts.idc:system/usr/idc/raydium_ts.idc \
	device/fossil/common/raydium_ts.kl:system/usr/keylayout/raydium_ts.kl

WIFI_VENDOR_CYPRESS_PATH := vendor/cypress
PRODUCT_COPY_FILES += \
    $(WIFI_VENDOR_CYPRESS_PATH)/firmware/sta/brcmfmac43012-sdio.bin:/vendor/firmware/brcmfmac/sta/brcmfmac43012-sdio.bin \
    $(WIFI_VENDOR_CYPRESS_PATH)/firmware/sta/brcmfmac43012-sdio.clm_blob:/vendor/firmware/brcmfmac/sta/brcmfmac43012-sdio.clm_blob \
    $(WIFI_VENDOR_CYPRESS_PATH)/firmware/ap/brcmfmac43012-sdio.bin:/vendor/firmware/brcmfmac/ap/brcmfmac43012-sdio.bin \
    $(WIFI_VENDOR_CYPRESS_PATH)/firmware/ap/brcmfmac43012-sdio.clm_blob:/vendor/firmware/brcmfmac/ap/brcmfmac43012-sdio.clm_blob \
    $(WIFI_VENDOR_CYPRESS_PATH)/nvram/brcmfmac43012-sdio.txt:/vendor/firmware/brcmfmac/sta/brcmfmac43012-sdio.txt




