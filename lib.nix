{ lib, ... }:
rec {
  buildConfig = nixConfig: {
    creds = _buildCreds nixConfig;
    config = _buildConfig nixConfig;
    inherit nixConfig;
  };
  _buildCreds = import ./nix/buildCreds.nix { };
  _buildConfig = import ./nix/buildConfig.nix { inherit lib; };
}
