{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = inputs@{ self, nixpkgs, utils, ... }:
    utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        gotta-scrape-em-all = import ./default.nix {
          inherit (pkgs) stdenv lib;
          inherit (pkgs.python3.pkgs) buildPythonPackage fastapi uvicorn typer;
        };
      in {
        packages = { inherit gotta-scrape-em-all; };
        packages.default = gotta-scrape-em-all;
        devShells.default = let
          my-python = pkgs.python3;
          python-with-my-packages = my-python.withPackages (p:
            with p;
            [
              gotta-scrape-em-all
              # other python packages you want
            ]);
        in pkgs.mkShell {
          buildInputs = with pkgs; [
            python-with-my-packages
            pre-commit
            # other dependencies
          ];
          envrc_contents = ''
            use flake
          '';
          shellHook = ''
            PYTHONPATH=${python-with-my-packages}/${python-with-my-packages.sitePackages}
            # maybe set more env-vars
            [[ ! -a .envrc ]] && echo -n "$envrc_contents" > .envrc
          '';
        };
        nixosModules = {
          gotta-scrape-em-all-module = import ./module.nix self;
        };
      });
}
