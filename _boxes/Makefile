#!/usr/bin/make -f
echo:=@echo
echotbl:=@printf "%-20s %s\n"

.PHONY: help
help:
	$(echo) "Targets:"
	$(echo)
	$(echotbl) "help" "This text"
	$(echotbl) "list" "List all targets"
	$(echotbl) "*.box" "A vagrant box file"
	$(echotbl) "add-*" "Add a box file"
	$(echotbl) "all" "All box files"
	$(echotbl) "add-all" "Add all box files"
	$(echo)
	$(echo) "Available box targets: $(boxes)"
	$(echo) "Available add targets: $(addboxes)"


# List all the makefile targets
# https://stackoverflow.com/a/26339924
.PHONY: list
list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'


boxes:=$(patsubst %/Vagrantfile,%.box,$(wildcard */Vagrantfile))

getdir=$(dir $<)
$(boxes): %.box: %/Vagrantfile
	cd "$(getdir)" && vagrant box update
	cd "$(getdir)" && vagrant up
	origdir=`pwd` && cd "$(getdir)" && vagrant package --output "$$origdir"/$@
	cd "$(getdir)" && vagrant destroy --force

addboxes:=$(patsubst %.box,add-%,$(boxes))
.PHONY: $(addboxes)
$(addboxes): add-%: %.box
	vagrant box add --force $* $<

.PHONY: clean
clean:
	-rm -f $(boxes)

.PHONY: all add-all
all: $(boxes)

add-all: $(addboxes)

