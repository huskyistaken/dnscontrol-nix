{
  pkgs ? import <nixpkgs> { },
}:
pkgs.symlinkJoin rec {
  name = "dnscontrol-nix";
  paths = [
    (pkgs.writers.writePython3Bin "dnscontrol-nix" { } (builtins.readFile ./src/dnscontrol-nix.py))
    pkgs.sops
  ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/dnscontrol-nix \
      --prefix PATH : "${pkgs.dnscontrol}/bin"
    ln -s $out/bin/${name} $out/bin/lix-dns
  '';
}
