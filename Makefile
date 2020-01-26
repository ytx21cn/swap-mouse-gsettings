# set schema: false for right-handed mode, true for left-handed mode
# to reset (i.e. change to right-handed mode), call this Makefile without arguments
EXEC := gsettings
SCHEMA := org.gnome.desktop.peripherals.mouse left-handed

GET_SCHEMA := $(EXEC) get $(SCHEMA)
RESET_SCHEMA := $(EXEC) reset $(SCHEMA)
SET_SCHEMA_LEFT := $(EXEC) set $(SCHEMA) true
SET_SCHEMA_RIGHT := $(EXEC) set $(SCHEMA) false

TO_UPPER := tr a-z A-Z
GET_MOUSE_MODE := $(GET_SCHEMA) | sed s/true/left/g \
	| sed s/false/right/g | $(TO_UPPER)
FEEDBACK := @echo "Your mouse is now in `echo \`\
	$(GET_MOUSE_MODE)\`-handed | $(TO_UPPER)` mode."

.PHONY: all
all: reset

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
