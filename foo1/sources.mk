CURRENT_DIR := $(ROOT_DIR)/foo1

INC_DIRS += \
	$(CURRENT_DIR)

SRC_FILES += \
    $(sort $(wildcard $(CURRENT_DIR)/*.c)) \
	$(sort $(wildcard $(CURRENT_DIR)/*.cpp)) \
	$(sort $(wildcard $(CURRENT_DIR)/*.s))
