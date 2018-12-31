CM_TARGET := ,
CM_ALL_TARGETS :=
.DEFAULT_GOAL := $(CM_TARGET)
_CM_ALL_TARGETS = $(CM_ALL_TARGETS)
BUILD_DIR ?= build
ECHO := 


# compile_objs(1:GROUP,2:SRCS)
define c_compile_objs
$(eval
$(if $($(1)_DEFINED),$$(error $0: group/target '$(1)' redefined),$(1)_DEFINED := 1)
$(1)_BUILD_DIR ?= $(BUILD_DIR)/$(1)_objs
$(1)_cc ?= $(CC)
$(1)_OBJS := 

$(foreach var,$(2),
CM_CURRENT_OBJ := $(addprefix $$($(1)_BUILD_DIR)/,$(subst ../,__/,$(patsubst %,%.o,$(var))))
$(1)_OBJS += $$(CM_CURRENT_OBJ)
CM_ALL_TARGETS += $$(CM_CURRENT_OBJ)
$$(CM_CURRENT_OBJ) : $(var)
	$(ECHO) mkdir -p $$(@D)
	$(ECHO) $$($(1)_cc) $$(addprefix -I,$$($(1)_INCLUDE_DIRS) $$(INCLUDE_DIRS)) $$(CFLAGS) $$($(1)_FLAGS) -MM -MT $$@ -MF $$@.d -c $$<
	$(ECHO) $$($(1)_cc) $$(addprefix -I,$$($(1)_INCLUDE_DIRS) $$(INCLUDE_DIRS)) $$(CFLAGS) $$($(1)_FLAGS) -c $$< -o $$@
-include $$(CM_CURRENT_OBJ).d
)
)
endef

# link_target_exe(1:TARGET,2:OBJS)
define link_target_exe
$(eval
$(if $($(1)_DEFINED),$$(error $0: group/target '$(1)' redefined),$(1)_DEFINED := 1)
$(1)_BUILD_DIR ?= $(BUILD_DIR)
$(1)_LINKER ?= $(CC)

CM_CURRENT_OBJ := $$($(1)_BUILD_DIR)/bin/$(1)
$(1)_OBJS := $$($(1)_BUILD_DIR)/bin/$(1)
CM_ALL_TARGETS += $$(CM_CURRENT_OBJ)
$$(CM_CURRENT_OBJ) : $(2)
	$(ECHO) mkdir -p $$(@D)
	$(ECHO) $$($(1)_LINKER) $$^ $$($(1)_FLAGS) -o $$@
)
endef

# link_target_so(1:TARGET,2:OBJS)
define link_target_so
$(eval
$(if $($(1)_DEFINED),$$(error $0: group/target '$(1)' redefined),$(1)_DEFINED := 1)
$(1)_BUILD_DIR ?= $(BUILD_DIR)
$(1)_LINKER ?= $(CC)

CM_CURRENT_OBJ := $$($(1)_BUILD_DIR)/lib/lib$(1).so
CM_ALL_TARGETS += $$(CM_CURRENT_OBJ)
$(1)_OBJS := $$(CM_CURRENT_OBJ)
$$(CM_CURRENT_OBJ) : $(2)
	$(ECHO) mkdir -p $$(@D)
	$(ECHO) $$($(1)_LINKER) $$^ $$($(1)_FLAGS) -shared -o $$@
)
endef

.PHONY: $(CM_TARGET) clean _before_comma _after_comma before_comma after_comma
.SECONDEXPANSION:
$(CM_TARGET): before_comma $$(_CM_ALL_TARGETS) _after_comma

_after_comma:| $$(_CM_ALL_TARGETS)
$$(_CM_ALL_TARGETS):| _before_comma

before_comma:| _before_comma
_after_comma:| after_comma

_before_comma:
	@echo It was an accident building a project located at [$$(pwd)] to [$$(readlink -f $(BUILD_DIR))], at $$(date)
	@echo "I got to the spot, found nothing but the comma,"
	@echo "I started tracing the only evidence, trying to find the truth behind the comma,"
	@echo "Nothing guarantees my return, good luck to me."
	@echo "(attachment:)"

_after_comma:
	@echo "(end of attachment)"
	@echo "Finnaly."
	@echo "Eventually."
	@echo "I gave up."

clean:
	$(ECHO) rm $(BUILD_DIR) -rf
