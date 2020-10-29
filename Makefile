ARCHS = arm64 arm64e

export SDKVERSION = 13.4

INSTALL_TARGET_PROCESSES = SpringBoard

#THEOS_PLATFORM_DEB_COMPRESSION_LEVEL = 6

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = sana

sana_FILES = Tweak.x
sana_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += sanaPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk
