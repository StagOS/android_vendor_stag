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
StagOS_VERSION = 9.0
ifeq ($(StagOS_BETA),true)
   STAG_BUILD_TYPE := BETA
endif
CURRENT_DEVICE=$(shell echo "$(TARGET_PRODUCT)" | cut -d'_' -f 2,3)
LIST = $(shell curl -s https://raw.githubusercontent.com/StagOS/android_vendor_stag/p9/stag.devices)
FOUND_DEVICE =  $(filter $(CURRENT_DEVICE), $(LIST))
ifeq ($(FOUND_DEVICE),$(CURRENT_DEVICE))
   IS_OFFICIAL=true
   STAG_BUILD_TYPE := OFFICIAL
else
   STAG_BUILD_TYPE := UNOFFICIAL
endif
STAG_VERSION := StagOS-$(CURRENT_DEVICE)-$(StagOS_VERSION)-$(STAG_BUILD_TYPE)-$(shell date -u +%Y%m%d-%H%M)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
 ro.stag.version=$(StagOS_VERSION) \
 ro.stag.releasetype=$(STAG_BUILD_TYPE) \
 ro.mod.version=$(StagOS_VERSION)
STAG_DISPLAY_VERSION := StagOS-$(StagOS_VERSION)-$(STAG_BUILD_TYPE)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
 ro.stag.display.version=$(STAG_DISPLAY_VERSION)
