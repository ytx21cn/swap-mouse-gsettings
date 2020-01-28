# set schema: false for right-handed mode, true for left-handed mode
# to reset (i.e. change to right-handed mode), call this Makefile without arguments
EXEC := gsettings
SCHEMA := org.gnome.desktop.peripherals.mouse left-handed

GET_SCHEMA := $(EXEC) get $(SCHEMA)
RESET_SCHEMA := $(EXEC) reset $(SCHEMA)
SET_SCHEMA_LEFT := $(EXEC) set $(SCHEMA) true
SET_SCHEMA_RIGHT := $(EXEC) set $(SCHEMA) false

# display feedback when applying a setting
TO_UPPER := tr [:lower:] [:upper:]
GET_MOUSE_MODE := $(GET_SCHEMA) | sed s/true/left/g \
	| sed s/false/right/g
FEEDBACK := @echo "Your mouse is now in `echo \`\
	$(GET_MOUSE_MODE)\`-handed | $(TO_UPPER)` mode."

MAKEFILE_PATH := $(realpath .)/Makefile
MAKEFILE_ALIAS := alias mouse='make -f $(MAKEFILE_PATH)'
BASHRC_FILE := ~/.bashrc
BASHRC_SECTION_HEADER := \# Mouse mode setting utility

define HELP
@echo 'Set mouse mode: `mouse left` / `mouse right`'
@echo 'Get mouse mode: `mouse get`'
@echo 'Reset mouse mode: `mouse reset`'
endef

define STRIP_EXTRA_BLANK_LINES
$(eval tempfile = $(shell mktemp))
@cat -s $(BASHRC_FILE) > $(tempfile)
@cat $(tempfile) > $(BASHRC_FILE)
endef

.PHONY: all
all: reset

.PHONY: install
install: clean
	@echo 'Installing mouse setting utility...'
	@echo '' >> $(BASHRC_FILE)
	@echo "$(BASHRC_SECTION_HEADER)" >> $(BASHRC_FILE)
	@echo "$(MAKEFILE_ALIAS)" >> $(BASHRC_FILE)
	$(STRIP_EXTRA_BLANK_LINES)
	@echo 'Installed mouse setting utility.'
	$(HELP)

.PHONY: clean
clean:
	@echo 'Removing existing mouse setting utility...'
	sed -i '/$(BASHRC_SECTION_HEADER)/d' $(BASHRC_FILE)
	$(eval makefile_alias_regex = $(subst /,\/,$(MAKEFILE_ALIAS)))
	sed -i "/$(makefile_alias_regex)/d" $(BASHRC_FILE)
	@echo 'Mouse setting utility removed.'
	$(STRIP_EXTRA_BLANK_LINES)

.PHONY: reset
reset:
	$(RESET_SCHEMA)
	$(FEEDBACK)

.PHONY: get
get:
	$(GET_SCHEMA)
	$(FEEDBACK)

.PHONY: left
left:
	$(SET_SCHEMA_LEFT)
	$(FEEDBACK)

.PHONY: right
right:
	$(SET_SCHEMA_RIGHT)
	$(FEEDBACK)
