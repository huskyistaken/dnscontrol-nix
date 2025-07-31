{
  pkgs ? import <nixpkgs> { },
  buildPythonPackage ? pkgs.python3Packages.buildPythonPackage,
  dnscontrol ? pkgs.dnscontrol,
  sops ? pkgs.sops,
}:
buildPythonPackage rec {
  pname = "dnscontrol-nix";
  version = "0.1.0";
  pyproject = false;

  src = ./src;

  configurePhase = ''
    substituteInPlace dnscontrol-nix.py \
      --subst-var-by dnscontrol ${dnscontrol}
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin/
    install -m 755 dnscontrol-nix.py $out/bin/dnscontrol-nix
    ln -s $out/bin/dnscontrol-nix $out/bin/lix-dns
    runHook postInstall
  '';
}
