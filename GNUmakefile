.PHONY:

path2sub_module = project/data
branch_name = main

code-sub-module-modify: code-check-sub-module-exists
	rm -fr $@ \
	&& git clone --recurse-submodules ./code-origin $@ \
	&& test -e $@/$(path2sub_module)/new-file.txt \
	|| cd $@/$(path2sub_module) \
	&& touch new-file.txt \
	&& git checkout $(branch_name) \
	&& git add new-file.txt \
	&& git commit --message="modifying submodule contents" \
	&& git push \
	&& cd $(CURDIR)/$@ \
	&& git status \
	&& git add .gitmodules \
	&& git commit --message="modifying submodule contents" \
	&& git push

code-check-sub-module-exists: code-add-sub-module
	rm -fr $@ \
	&& git clone --recurse-submodules ./code-origin $@ \
	&& test -e $@/$(path2sub_module) && echo OK

code-add-sub-module: code-origin data-origin
	rm -fr $@ \
	&& git clone --recurse-submodules ./code-origin $@ \
	&& test -e $@/$(path2sub_module) \
	|| cd $@ \
	&& git submodule add $(CURDIR)/data-origin $(path2sub_module) \
	&& git commit --message="adding submodule" \
	&& git push

define make-origin
$(1)-origin:
	rm -fr $(1)-repo \
	&& mkdir $(1)-repo \
	&& cd $(1)-repo \
	&& git init \
	&& touch .gitignore \
	&& git add .gitignore \
	&& git commit --all --message="initiate repo" \
	&& git branch -m $(branch_name) \
	&& cd $(CURDIR) \
	&& git clone --bare $(CURDIR)/$(1)-repo $(1)-origin \
	&& rm -fr $(1)-repo
endef

$(eval $(call make-origin,code))
$(eval $(call make-origin,data))

clean:
	git clean -fxd
	rm -fr code-* data-*
