ARCHS = arm64 arm64e

export SDKVERSION = 13.4

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = sana

sana_FILES = Tweak.x
sana_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += sanaPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk
