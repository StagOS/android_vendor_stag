# Copyright (C) 2016 The Pure Nexus Project
# Copyright (C) 2016 The JDCTeam
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

StagOS_VERSION = 12.1
STAG_PLATFORM_RELEASE_OR_CODENAME := 12L

STAG_BASE_VERSION = $(StagOS_VERSION)

CURRENT_DEVICE=$(shell echo "$(TARGET_PRODUCT)" | cut -d'_' -f 2,3)
TARGET_PRODUCT_SHORT := $(subst aosp_,,$(CUSTOM_BUILD))

ifeq ($(BUILD_TYPE),OFFICIAL)
      IS_OFFICIAL=true
      STAG_BUILD_TYPE := OFFICIAL
else
ifeq ($(BUILD_TYPE),TEST)
   STAG_BUILD_TYPE := TEST
else
   STAG_BUILD_TYPE := UNOFFICIAL
endif
endif

STAG_ZIP_TYPE = Pristine

# GApps
ifeq ($(WITH_GAPPS),true)
STAG_ZIP_TYPE := GApps
endif

STAG_VERSION := StagOS-$(CURRENT_DEVICE)-$(StagOS_VERSION)-$(STAG_BUILD_TYPE)-$(STAG_ZIP_TYPE)-$(shell date -u +%Y%m%d-%H%M)

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
 ro.stag.version=$(STAG_VERSION) \
 ro.stag.releasetype=$(STAG_BUILD_TYPE) \
 ro.mod.version=$(StagOS_VERSION) \
 ro.stag.build.version=$(STAG_BASE_VERSION) \
 ro.stag.ziptype=$(STAG_ZIP_TYPE) \
 ro.stag.settings.android_version=$(STAG_PLATFORM_RELEASE_OR_CODENAME)


STAG_DISPLAY_VERSION := StagOS-$(StagOS_VERSION)-$(STAG_BUILD_TYPE)
ROM_FINGERPRINT := StagOS/$(STAG_VERSION)/$(TARGET_PRODUCT_SHORT)/$(shell date -u +%Y%m%d-%H%M)

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
 ro.stag.display.version=$(STAG_DISPLAY_VERSION) \
 ro.stag.fingerprint=$(ROM_FINGERPRINT)

