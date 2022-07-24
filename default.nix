{ stdenv, lib, fastapi, uvicorn, typer, buildPythonPackage }:

buildPythonPackage rec {
  pname = "gotta-scrape-em-all";
  version = "0.1.0";
  format = "setuptools";

  # disabled = pythonOlder "3.8";

  src = ./.;

  # nativeBuildInputs = [
  # setuptools-rust
  # ] ++ (with rustPlatform; [
  # cargoSetupHook
  # rust.cargo
  # rust.rustc
  # ]);

  propagatedBuildInputs = [ fastapi uvicorn typer ];

  # checkInputs = [
  # dirty-equals
  # pytest-mock
  # pytest-timeout
  # pytestCheckHook
  # ];

  pythonImportsCheck = [ "gotta_scrape_em_all" ];

  checkPhase = ''
    $out/bin/gotta-scrape-em-all --help
  '';

  # preCheck = ''
  # cd tests
  # '';

  # meta = with lib; {
  # broken = stdenv.isDarwin;
  # description = "Simple, modern file watching and code reload";
  # homepage = "https://watchfiles.helpmanual.io/";
  # license = licenses.mit;
  # maintainers = with maintainers; [ fab ];
  # };
}
