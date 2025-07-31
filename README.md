# dnscontrol-nix

A glorified transpiler from `nix` to the `javascript` DSL used by [dnscontrol](https://github.com/StackExchange/dnscontrol).
This tool acts as a wrapper, reading DNS configurations specified in a flake and feeding them into dnscontrol.

`dnscontrol-nix` is designed to integrate seamlessly with sops, allowing `creds.json` to be managed alongside other secrets.

## Features

- Yet another piece of infra you can manage with nix.
- Extremely alpha software (new and exciting bugs).
- Integrates with sops.
- Exposes the lix subcommand `lix dns`.

## Example

``` nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    dnscontrol-nix.url = "git+https://codeberg.org/hu5ky/dnscontrol-nix.git";
  };

  outputs =
    inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [ inputs.dnscontrol-nix.packages.${pkgs.system}.default ];
      };

      dns = inputs.dnscontrol-nix.lib.buildConfig {
        settings.sops = {
          package = pkgs.sops;
          file = ./secrets.yaml;
          extractString = "['dns-creds']";
        };
        domains = {
          "personal" = {
            domain = "my-cool-website.tld";
            registrar = "porkbun";
            dnsProvider = "cloudflare";

            records = [
              { type = "alias"; label = "@"; target = "codeberg.page."; }
              { type = "txt"; label = "@"; text = "hu5ky.codeberg.page"; }
              { type = "cname"; label = "www"; target = "husky.sh."; }
              { type = "ignore"; labelSpec = "matrix"; typeSpec = "A"; } # Managed by ddns script

              { type = "mx"; label = "@"; priority = 10; target = "mail1.mailserver.tld."; }
              { type = "mx"; label = "@"; priority = 10; target = "mail2.mailserver.tld."; }
              { type = "mx"; label = "@"; priority = 20; target = "mail3.mailserver.tld."; }
              { type = "cname"; label = "openpgpkey"; target = "wkd.keys.openpgp.org."; }
            ];
          };
        };
      };
    };
}
```

## Shout outs
- [dnscontrol](https://github.com/StackExchange/dnscontrol)
- [NixOS-DNS](https://github.com/Janik-Haag/NixOS-DNS) (Similar project with a different approach for Octodns)
