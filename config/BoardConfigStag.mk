include vendor/stag/config/BoardConfigKernel.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/stag/config/BoardConfigQcom.mk
endif

include vendor/stag/config/BoardConfigSoong.mk
