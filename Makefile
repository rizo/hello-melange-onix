.PHONY: lock
lock:
	nix develop -f default.nix --max-jobs auto  -v lock

.PHONY: shell
shell:
	nix develop -f default.nix --max-jobs auto  -v shell

.PHONY: build
build:
	dune build @melange

.PHONY: watch
watch:
	dune build -w @melange

.PHONY: clean
	dune clean

.PHONY: bundle
bundle:
	npm exec -- \
		esbuild _build/default/src/es6/src/App.js --bundle --minify --outfile=public/index.js

.PHONY: serve
serve:
	npm exec -- \
		esbuild _build/default/src/es6/src/App.js --bundle --servedir=public --outfile=public/index.js

