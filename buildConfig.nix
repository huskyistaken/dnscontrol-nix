{ lib, ... }:
with builtins;
config:
let
  buildDomain = import ./buildDomain.nix { inherit lib; };
in
concatStringsSep "\n" (
  map (
    id:
    buildDomain {
      domain = config.domains.${id};
      inherit id;
    }
  ) (attrNames config.domains)
)
