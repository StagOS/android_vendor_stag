LOCAL_PATH := $(call my-dir)
include $(call all-subdir-makefiles,$(LOCAL_PATH))

# Common
include vendor/stag/config/common.mk

# Version
include vendor/stag/config/version.mk

# overrides
include vendor/stag/config/overrides.mk

# Clocks
$(call inherit-product-if-exists, vendor/SystemUIClocks/product.mk)

# OTA
include vendor/stag/config/ota.mk

# Themes
#$(call inherit-product, vendor/stag/config/themes.mk)

# Plugins
#include packages/apps/PotatoPlugins/plugins.mk
