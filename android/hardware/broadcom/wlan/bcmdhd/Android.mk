#ifeq ($(BOARD_WLAN_DEVICE),bcmdhd)
ifeq ($(BOARD_WLAN_DEVICE), $(filter $(BOARD_WLAN_DEVICE), bcmdhd brcmfmac))
    include $(call all-subdir-makefiles)
endif
