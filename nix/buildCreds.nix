{ ... }:
with builtins;
config:
if
  config.settings ? "sops" && config.settings.sops ? "file" && config.settings.sops ? "extractString"
then
  ''! sops decrypt --extract "${config.settings.sops.extractString}" ${config.settings.sops.file}''
else if config.settings ? "credsCommand" then
  "! ${config.settings.credsCommand}"
else
  config.settings.credsFile or ""
