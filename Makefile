path2sub_module = project\data
branch_name = main

code-check-sub-module-modify: code-sub-module-modify
	IF EXIST $@ RMDIR /S /Q $@
	git clone --recurse-submodules .\code-origin $@ \
	&& IF EXIST $(MAKEDIR)\$@\$(path2sub_module)\new-file.txt (ECHO $@ - OK) ELSE (EXIT /B -1)

code-sub-module-modify: code-check-sub-module-exists
	IF EXIST $@ RMDIR /S /Q $@
	git clone --recurse-submodules .\code-origin $@ \
	&& PUSHD $(MAKEDIR)\$@\$(path2sub_module) \
	&& @ECHO some content > new-file.txt \
	&& git checkout $(branch_name) \
	&& git add new-file.txt \
	&& git commit --message="modifying submodule contents" \
	&& git push \
	&& POPD \
	&& PUSHD $(MAKEDIR)\$@ \
	&& git stage $(path2sub_module) \
	&& git commit --message="modifying submodule contents" \
	&& git push

code-check-sub-module-exists: code-add-sub-module
	IF EXIST $@ RMDIR /S /Q $@
	git clone --recurse-submodules .\code-origin $@ \
	&& IF EXIST $(MAKEDIR)\$@\$(path2sub_module) (ECHO $@ - OK) ELSE (EXIT /B -1)

code-add-sub-module: code-origin data-origin
	IF EXIST $@ RMDIR /S /Q $@
	git clone --recurse-submodules .\code-origin $@ \
	&& PUSHD $(MAKEDIR)\$@ \
	&& git submodule add $(MAKEDIR)\data-origin $(path2sub_module) \
	&& git commit --message="adding submodule" \
	&& git push \
	&& POPD

data-origin:
	IF EXIST data-repo RMDIR /S /Q data-repo
	MKDIR data-repo \
	&& PUSHD $(MAKEDIR)\data-repo \
	&& git init \
	&& @ECHO .vs > .gitignore \
	&& git add .gitignore \
	&& git commit --all --message="initiate repo" \
	&& git branch -m $(branch_name) \
	&& POPD \
	&& git clone --bare $(MAKEDIR)/data-repo data-origin \
	&& RMDIR /S /Q data-repo

code-origin:
	IF EXIST code-repo RMDIR /S /Q code-repo
	MKDIR code-repo \
	&& PUSHD $(MAKEDIR)\code-repo \
	&& git init \
	&& @ECHO .vs > .gitignore \
	&& git add .gitignore \
	&& git commit --all --message="initiate repo" \
	&& git branch -m $(branch_name) \
	&& POPD \
	&& git clone --bare $(MAKEDIR)/code-repo code-origin \
	&& RMDIR /S /Q code-repo

clean:
	git clean -fxd
	FOR /D %G IN ("code-*","data-*") DO RD /S /Q "%~G"
