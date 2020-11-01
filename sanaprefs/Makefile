ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = sanaPrefs

sanaPrefs_FILES = SANRootListController.m SANSubtitleCell.m SANRootHeaderView.m
sanaPrefs_FRAMEWORKS = UIKit
sanaPrefs_PRIVATE_FRAMEWORKS = Preferences
sanaPrefs_INSTALL_PATH = /Library/PreferenceBundles
sanaPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
