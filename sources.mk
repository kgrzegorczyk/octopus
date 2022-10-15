INC_DIRS += \
	$(ROOT_DIR)

SRC_FILES += \
    $(sort $(wildcard $(ROOT_DIR)/*.c)) \
	$(sort $(wildcard $(ROOT_DIR)/*.cpp)) \
	$(sort $(wildcard $(ROOT_DIR)/*.s))

include foo1/sources.mk
include foo2/sources.mk
