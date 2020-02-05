# set schema: false for right-handed mode, true for left-handed mode
# call this Makefile in command line: `make get`, `make reset`, `make left`, `make right`
# to display help: call this Makefile without arguments

HEADER := [Mouse mode setting utility]

EXEC := gsettings
SCHEMA := org.gnome.desktop.peripherals.mouse left-handed

GET_SCHEMA := $(EXEC) get $(SCHEMA)
RESET_SCHEMA := $(EXEC) reset $(SCHEMA)
SET_SCHEMA_LEFT := $(EXEC) set $(SCHEMA) true
SET_SCHEMA_RIGHT := $(EXEC) set $(SCHEMA) false

# display help
define HELP
@echo '$(HEADER)'
@echo 'Set mouse mode: `make left` / `make right`'
@echo 'Get mouse mode: `make get`'
@echo 'Reset mouse mode: `make reset`'
endef

# display feedback when applying a setting
TO_UPPER := tr [:lower:] [:upper:]
GET_MOUSE_MODE := $(GET_SCHEMA) | sed s/true/left/g \
	| sed s/false/right/g
FEEDBACK := @echo "Your mouse is now in `echo \`\
	$(GET_MOUSE_MODE)\`-handed | $(TO_UPPER)` mode."


.PHONY: all
all:
	$(HELP)

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
