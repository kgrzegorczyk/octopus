ROOT_DIR 		:= .
#ROOT_DIR        := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))
BIN_FILE        := octopus
DEBUG           := 0

CROSS_COMPILE   := 
BUILD_DIR       :=  $(ROOT_DIR)/build
BIN             := $(BUILD_DIR)/$(BIN_FILE)

C_FLAGS         := -std=c99 -g
ifneq ($(DEBUG),0)
C_FLAGS         += -DDEBUG
endif

CXX_FLAGS       := -std=c++17 -g
ifneq ($(DEBUG),0)
CXX_FLAGS       += -DDEBUG
endif

AR_FLAGS        := rcs
LD_FLAGS        :=

CC              := $(CROSS_COMPILE)gcc
CXX             := $(CROSS_COMPILE)g++
AR              := $(CROSS_COMPILE)gcc-ar
LD              := $(CROSS_COMPILE)g++
DEP             := $(CROSS_COMPILE)gcc
OBJDUMP         := $(CROSS_COMPILE)objdump
OBJCOPY         := $(CROSS_COMPILE)objcopy
SIZE            := $(CROSS_COMPILE)size

INC_DIRS :=
SRC_FILES :=

include sources.mk

C_FLAGS         += $(addprefix -I,$(INC_DIRS))
CXX_FLAGS       += $(addprefix -I,$(INC_DIRS))

C_DEP_FLAGS     := $(C_FLAGS) -MM -MF
CXX_DEP_FLAGS   := $(CXX_FLAGS) -MM -MF

OBJ_FILES       := $(SRC_FILES:.c=.o)
OBJ_FILES       := $(OBJ_FILES:.cpp=.o)
OBJ_FILES       := $(OBJ_FILES:.s=.o)
OBJ_FILES       := $(subst $(ROOT_DIR)/,$(BUILD_DIR)/,$(OBJ_FILES))

DEP_FILES       := $(OBJ_FILES:.o=.d)

all: $(BIN)

$(BIN): $(OBJ_FILES) $(LD_FILE)
	@mkdir -p $(BUILD_DIR)
	$(LD) -o $(BIN) $(LD_FLAGS) $(OBJ_FILES)
	$(OBJDUMP) -t $(BIN) > $(BIN).sym
	-$(SIZE) $(BIN)

$(BUILD_DIR)/%.o: $(ROOT_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(C_FLAGS) -c -o $@ $<
	@$(if $(DEP),$(DEP) $(C_DEP_FLAGS) $(subst .o,.d,$@) -MP -MT $@ $<,)

$(BUILD_DIR)/%.o: $(ROOT_DIR)/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXX_FLAGS) -c -o $@ $<
	@$(if $(DEP),$(DEP) $(CXX_DEP_FLAGS) $(subst .o,.d,$@) -MP -MT $@ $<,)

$(BUILD_DIR)/%.o: $(ROOT_DIR)/%.s
	@mkdir -p $(dir $@)
	$(CC) $(C_FLAGS) -c -o $@ $<
	@$(if $(DEP),$(DEP) $(C_DEP_FLAGS) $(subst .o,.d,$@) -MP -MT $@ $<,)

clean:
	@rm -rf $(BUILD_DIR)

-include $(DEP_FILES)

.PHONY: all clean
