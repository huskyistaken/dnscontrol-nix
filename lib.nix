{ lib, ... }:
rec {
  buildConfig = nixConfig: {
    creds = _buildCreds nixConfig;
    config = _buildConfig nixConfig;
  };
  _buildCreds = import ./nix/buildCreds.nix { inherit lib; };
  _buildConfig = import ./nix/buildConfig.nix { inherit lib; };
}
