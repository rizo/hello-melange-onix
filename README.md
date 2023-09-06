# hello-melange-onix

A simple melange app with native dune support and onix for dependency management.

## Usage

Update the lock file:
```shell
$ make lock
```

Start a development shell:
```shell
$ make shell
```

Build the project:
```shell
[nix]$ make build
[nix]$ make watch
```

Install node_modules:
```shell
[nix]$ npm ci
```

Bundle the project:
```shell
[nix]$ make bundle
```

Run locally:
```shell
[nix]$ make serve
```
