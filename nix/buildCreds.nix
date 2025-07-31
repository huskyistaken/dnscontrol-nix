{ ... }:
with builtins;
config:
if
  config.settings ? "sops" && config.settings.sops ? "file" && config.settings.sops ? "extractString"
then
  let
    sops =
      if config.settings.sops ? "package" then "${config.settings.sops.package}/bin/sops" else "sops";
    extractString = config.settings.sops.extractString;
    file = builtins.toString config.settings.sops.file;
  in
  "! ${sops} decrypt --extract \"${extractString}\" ${file}"
else if config.settings ? "credsCommand" then
  "! ${config.settings.credsCommand}"
else
  config.settings.credsFile or ""
