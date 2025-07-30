{ lib, ... }:
with builtins;
{ domain, id }:
let
  buildRecord = import ./buildRecord.nix { inherit lib; };
in
''
  // ${id}
  D("${domain.domain or id}",
  NewRegistrar("${domain.registrar}"),
  DnsProvider(NewDnsProvider("${domain.dnsProvider}")),
''
+ (if domain ? "purge" && !domain.purge then "NO_PURGE,\n" else "PURGE,\n")
+ (
  if domain ? "autodnssec" then
    (if domain.autodnssec then "AUTODNSSEC_ON,\n" else "AUTODNSSEC_OFF,\n")
  else
    ""
)
+ (
  if domain ? "ignoreSafetyCheck" && !domain.ignoreSafetyCheck then
    "DISABLE_IGNORE_SAFETY_CHECK,\n"
  else
    ""
)
+ (
  if domain ? "defaultTtl" then
    let
      conversionFunction = {
        "string" = (x: "\"${x}\"");
        "int" = (x: "${toString x}");
      };
      ttl = domain.defaultTtl;
      ttlType = typeOf ttl;
    in
    "DefaultTTL(${conversionFunction.${ttlType} ttl}),\n"
  else
    ""
)
+ (concatStringsSep ",\n" (map buildRecord domain.records))
+ ")"
