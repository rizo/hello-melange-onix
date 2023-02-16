{ pkgs ? import <nixpkgs> { } }:

let
  ocamlPackages = pkgs.ocaml-ng.ocamlPackages_4_14;

  onix = import (builtins.fetchGit {
    url = "https://github.com/odis-labs/onix.git";
    rev = "93f010fc3ca3613790a30f8f1919b601b1583361";
  }) {
    inherit pkgs ocamlPackages;
    verbosity = "debug";
  };

  env = onix.env {
    repo = {
      url = "https://github.com/ocaml/opam-repository.git";
      rev = "a0ac569e24e60513e00b200b140d2f445039d873";
    };
    path = ./.;
    gitignore = ./.gitignore;
    deps = { "ocaml-system" = "*"; };
    vars = {
      with-dev-setup = true;
      with-test = true;
      with-doc = true;
    };
    overlay = self: super: {
      "melange" = super.melange.overrideAttrs (superAttrs: {
        postInstall = ''
          mkdir -p $out/lib/melange
          mv $out/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib/melange/melange $out/lib/melange/melange
          cp -r $out/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib/melange/runtime $out/lib/melange/runtime
        '';
      });
    };
  };
in {
  lock = env.lock;
  shell = pkgs.mkShell {
    inputsFrom = [ env.pkgs.hello-melange ];
    shellHook = ''
      export PS1="[\[\033[1;34m\]nix\[\033[0m\]]\$ "
    '';
  };
}
