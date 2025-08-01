{ lib, ... }:
rec {
  buildConfig = nixConfig: {
    outputs = {
      creds = _buildCreds nixConfig;
      config = _buildConfig nixConfig;
    };
  } // nixConfig;
  _buildCreds = import ./nix/buildCreds.nix { };
  _buildConfig = import ./nix/buildConfig.nix { inherit lib; };
}
