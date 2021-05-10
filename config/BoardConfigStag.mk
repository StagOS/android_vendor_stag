# Safetynet
# TARGET_FORCE_BUILD_FINGERPRINT := google/redfin/redfin:11/RQ2A.210505.003/7255357:user/release-keys

# Charger
ifeq ($(WITH_LINEAGE_CHARGER),true)
    BOARD_HAL_STATIC_LIBRARIES := libhealthd.lineage
endif

include vendor/stag/config/BoardConfigKernel.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/stag/config/BoardConfigQcom.mk
endif

include vendor/stag/config/BoardConfigSoong.mk
