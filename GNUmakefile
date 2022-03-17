.PHONY:

code-clone: code-origin data-origin
	rm -fr $@
	git clone ./code-origin code-clone \
	&& cd code-clone \
	&& git submodule add $(CURDIR)/data-origin \
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
	&& git config --local init.defaultBranch main \
	&& git commit --all --message="initiate repo" \
	&& cd $(CURDIR) \
	&& git clone --bare $(CURDIR)/$(1)-repo $(1)-origin \
	&& rm -fr $(1)-repo
endef

$(eval $(call make-origin,code))
$(eval $(call make-origin,data))

clean:
	git clean -fxd
	rm -fr code-origin data-origin
