# set schema: false for right-handed mode, true for left-handed mode
# to reset (i.e. change to right-handed mode), call this Makefile without arguments
EXEC := gsettings
SCHEMA := org.gnome.desktop.peripherals.mouse left-handed

mouse_mode = $(subst true, left, $(subst false, right,\
	$(shell $(EXEC) get $(SCHEMA))))

to_upper = $(shell echo $(1) | tr a-z A-Z)
feedback = @echo "Your mouse is now in"\
	$(call to_upper, $(1)-handed)" mode."

.PHONY: all
all: reset

.PHONY: reset
reset:
	$(EXEC) reset $(SCHEMA)
	$(call feedback, $(mouse_mode))

.PHONY: get
get:
	$(EXEC) get $(SCHEMA)
	$(call feedback, $(mouse_mode))

.PHONY: left
left:
	$(EXEC) set $(SCHEMA) true
	$(call feedback, $@)

.PHONY: right
right:
	$(EXEC) set $(SCHEMA) false
	$(call feedback, $@)
