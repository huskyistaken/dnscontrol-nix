{ lib, ... }:
rec {
  buildConfig = nixConfig: {
    creds = _buildCreds nixConfig;
    config = _buildConfig nixConfig;
  };
  _buildCreds = import ./buildCreds.nix { inherit lib; };
  _buildConfig = import ./buildConfig.nix { inherit lib; };
}
