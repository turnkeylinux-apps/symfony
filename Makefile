COMMON_OVERLAYS = github-latest-release

PHP_MEMORY_LIMIT=128M

include $(FAB_PATH)/common/mk/turnkey/lamp.mk
include $(FAB_PATH)/common/mk/turnkey/composer.mk
include $(FAB_PATH)/common/mk/turnkey.mk
