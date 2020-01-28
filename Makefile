# set schema: false for right-handed mode, true for left-handed mode
# call this Makefile in command line: `make get`, `make reset`, `make left`, `make right`
# to display help: call this Makefile without arguments

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
NEW_TERMINAL := Open a new terminal window to see the effect.

# install / uninstall: put alias to ~/.bashrc
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
all:
	@echo "$(BASHRC_SECTION_HEADER)"
	$(HELP)
	@echo "Run \`make install\` to activate the \`mouse\` command."
	@echo "Run \`make uninstall\` to deactivate the \`mouse\` command."

.PHONY: install
install: uninstall
	@echo -e '\nInstalling mouse setting utility...'
	echo '' >> $(BASHRC_FILE)
	echo "$(BASHRC_SECTION_HEADER)" >> $(BASHRC_FILE)
	echo "$(MAKEFILE_ALIAS)" >> $(BASHRC_FILE)
	$(STRIP_EXTRA_BLANK_LINES)
	@echo 'Installed mouse setting utility.'
	@echo "$(NEW_TERMINAL)"
	$(HELP)

.PHONY: uninstall
uninstall: clean

.PHONY: clean
clean:
	@echo -e '\nUninstalling existing mouse setting utility...'
	sed -i '/$(BASHRC_SECTION_HEADER)/d' $(BASHRC_FILE)
	$(eval makefile_alias_regex = $(subst /,\/,$(MAKEFILE_ALIAS)))
	sed -i "/$(makefile_alias_regex)/d" $(BASHRC_FILE)
	$(STRIP_EXTRA_BLANK_LINES)
	@echo 'Uninstalled Mouse setting utility.'
	@echo "$(NEW_TERMINAL)"

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
