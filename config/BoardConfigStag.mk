# Charger
ifeq ($(WITH_LINEAGE_CHARGER),true)
    BOARD_HAL_STATIC_LIBRARIES := libhealthd.lineage
endif

include vendor/stag/config/BoardConfigKernel.mk

include vendor/stag/config/BoardConfigSoong.mk
