.PHONY: lock
lock:
	nix develop -f default.nix -j8 -v lock

.PHONY: shell
shell:
	nix develop -f default.nix -j8 -v shell

.PHONY: build
build:
	dune build @melange

.PHONY: watch
watch:
	dune build -w @melange

bundle:
	npm exec -- \
		esbuild _build/default/src/es6/src/App.js --bundle --minify --outfile=public/index.js

serve:
	npm exec -- \
		esbuild _build/default/src/Index.bs.js --bundle --servedir=public --outdir=public

