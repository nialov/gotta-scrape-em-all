{ stdenv, lib, writeShellApplication, makeWrapper, installShellFiles, appPython
}:

let
  name = "gotta-scrape-em-all";
  entrypoint = writeShellApplication {
    name = "entrypoint";

    runtimeInputs = [ appPython ];

    text = ''
      uvicorn main:FASTAPI_APP "$@"
    '';
  };

in stdenv.mkDerivation {
  inherit name;
  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ appPython makeWrapper ];
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    cp ${entrypoint}/bin/entrypoint $out/bin/${name}
    chmod +x $out/bin/${name}
    cp ${./main.py} $out/main.py
  '';
  postFixup = ''
    wrapProgram $out/bin/${name} --prefix PYTHONPATH : $out
  '';
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/${name} --help
  '';

}

# buildPythonPackage rec {
# pname = "gotta-scrape-em-all";
# version = "0.1.0";
# format = "setuptools";

# # disabled = pythonOlder "3.8";

# src = ./.;

# # nativeBuildInputs = [
# # setuptools-rust
# # ] ++ (with rustPlatform; [
# # cargoSetupHook
# # rust.cargo
# # rust.rustc
# # ]);

# propagatedBuildInputs = [ fastapi uvicorn typer ];

# # checkInputs = [
# # dirty-equals
# # pytest-mock
# # pytest-timeout
# # pytestCheckHook
# # ];

# pythonImportsCheck = [ "gotta_scrape_em_all" ];

# checkPhase = ''
# $out/bin/gotta-scrape-em-all --help
# '';

# postInstallPhase = ''
# $out/bin/gotta-scrape-em-all --help
# '';

# # preCheck = ''
# # cd tests
# # '';

# # meta = with lib; {
# # broken = stdenv.isDarwin;
# # description = "Simple, modern file watching and code reload";
# # homepage = "https://watchfiles.helpmanual.io/";
# # license = licenses.mit;
# # maintainers = with maintainers; [ fab ];
# # };
# }
