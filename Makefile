EXEC := gsettings
SCHEMA := org.gnome.desktop.peripherals.mouse left-handed

# set schema: false for right-handed mode, true for left-handed mode
# to reset (i.e. change to right-handed mode), call this Makefile without arguments

all: reset

.PHONY: reset
reset:
	$(EXEC) reset $(SCHEMA)

.PHONY: get
get:
	$(EXEC) get $(SCHEMA)

.PHONY: left
left:
	$(EXEC) set $(SCHEMA) true

.PHONY: right
right:
	$(EXEC) set $(SCHEMA) false
