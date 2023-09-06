# Commit hash for nixos-23.05 obtained at https://status.nixos.org as of 2023-09-05
{ pkgs ? import
  (fetchTarball "https://github.com/NixOS/nixpkgs/archive/da5adce0ffaf.tar.gz")
  { } }:

let
  ocamlPackages = pkgs.ocaml-ng.ocamlPackages_4_14;

  onix = import (builtins.fetchGit {
    url = "https://github.com/odis-labs/onix.git";
    rev = "a5de90d3437848d048ed73b7e9aa18fb57702ae7";
  }) {
    inherit pkgs ocamlPackages;
    verbosity = "debug";
  };

in onix.env {
  repos = [{
    url = "https://github.com/ocaml/opam-repository.git";
    rev = "8241abf97ddbcb63f614372f31abeb306312f33c";
  }];
  path = ./.;
  deps = { "ocaml-system" = "*"; };
  vars = {
    "with-dev-setup" = true;
    "with-test" = true;
    "with-doc" = true;
  };

  overlay = self: super: {
    "melange" = super.melange.overrideAttrs (superAttrs: {
      postInstall = ''
        wrapProgram "$out/bin/melc" \
          --set MELANGELIB "$OCAMLFIND_DESTDIR/melange/melange:$OCAMLFIND_DESTDIR/melange/belt:$OCAMLFIND_DESTDIR/melange/belt/melange:$OCAMLFIND_DESTDIR/melange/js_parser:$OCAMLFIND_DESTDIR/melange/ppx:$OCAMLFIND_DESTDIR/melange/ppxlib-ast:$OCAMLFIND_DESTDIR/melange/ppxlib:$OCAMLFIND_DESTDIR/melange/runtime:$OCAMLFIND_DESTDIR/melange/runtime/melange"
      '';
      buildInputs = (superAttrs.buildInputs or [ ]) ++ [ pkgs.makeWrapper ];
    });
  };
}
