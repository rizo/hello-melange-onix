{ pkgs ? import <nixpkgs> { } }:

let
  ocamlPackages = pkgs.ocaml-ng.ocamlPackages_4_14;

  onix = import (builtins.fetchGit {
    url = "https://github.com/odis-labs/onix.git";
    rev = "444245996f7c10697c566f2c60623cea9311cb72";
  }) {
    inherit pkgs ocamlPackages;
    verbosity = "debug";
  };

in onix.env {
  repos = [{
    url = "https://github.com/ocaml/opam-repository.git";
    rev = "a0ac569e24e60513e00b200b140d2f445039d873";
  }];
  path = ./.;
  deps = { "ocaml-system" = "*"; };
  vars = {
    with-dev-setup = true;
    with-test = true;
    with-doc = true;
  };

  overlay = self: super: {
    "melange" = super.melange.overrideAttrs (superAttrs: {
      postInstall = ''
        wrapProgram "$out/bin/melc" \
          --set MELANGELIB "$OCAMLFIND_DESTDIR/melange/melange:$OCAMLFIND_DESTDIR/melange/runtime/melange:$OCAMLFIND_DESTDIR/melange/belt/melange"
        mkdir -p $out/lib/melange
        cp -r $OCAMLFIND_DESTDIR/melange/mel_runtime \
            $out/lib/melange/__MELANGE_RUNTIME__
        cp -r $OCAMLFIND_DESTDIR/melange/mel_runtime \
            $out/lib/melange/mel_runtime
      '';
      buildInputs = (superAttrs.buildInputs or [ ]) ++ [ pkgs.makeWrapper ];
    });
  };
}
