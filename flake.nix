{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = inputs@{ self, nixpkgs, utils, ... }:
    utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        appPython = pkgs.python3.withPackages
          (pythonPackages: with pythonPackages; [ fastapi uvicorn requests ]);
        gotta-scrape-em-all = import ./default.nix {
          inherit (pkgs)
            stdenv lib writeShellApplication makeWrapper installShellFiles;
          # inherit (pkgs.python3.pkgs) fastapi uvicorn typer requests;
          inherit appPython;
        };
      in {
        packages = { inherit gotta-scrape-em-all; };
        packages.default = gotta-scrape-em-all;
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            appPython
            pre-commit
            gotta-scrape-em-all
            # other dependencies
          ];
          envrc_contents = ''
            use flake
          '';
          shellHook = ''
            # maybe set more env-vars
            [[ ! -a .envrc ]] && echo -n "$envrc_contents" > .envrc
          '';
        };
        nixosModules = {
          gotta-scrape-em-all-module = import ./module.nix self;
        };
        checks = {
          test_cli = pkgs.runCommand "test_cli" { } ''
            ${gotta-scrape-em-all}/bin/gotta-scrape-em-all --help
            mkdir $out
          '';
        };
      });
}
