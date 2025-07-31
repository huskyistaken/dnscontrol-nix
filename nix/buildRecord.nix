{ lib, ... }:
with builtins;
record:
let
  typeHandler = rec {
    recordModifiers =
      record:
      let
        ttl =
          if record ? "ttl" then
            let
              conversionFunction = {
                "string" = (x: "\"${x}\"");
                "int" = (x: "${toString x}");
              };
              ttl = record.ttl;
              ttlType = typeOf ttl;
            in
            ", TTL(${conversionFunction.${ttlType} ttl})"
          else
            "";
        modifiers = if record ? "modifiers" then ", ${toJSON record.modifiers}" else "";
      in
      "${ttl}${modifiers}";

    address =
      record:
      let
        type = lib.toUpper record.type;
        label = ''"${record.label}"'';
        address = '', "${record.address}"'';
        modifiers = recordModifiers record;
      in
      "${type}(${label}${address}${modifiers})";
    a = address;
    aaaa = address;

    target =
      record:
      let
        type = lib.toUpper record.type;
        label = ''"${record.label}"'';

        canHavePriority =
          type:
          elem type [
            "mx"
            "https"
            "srv"
          ];
        priority =
          if record ? "priority" && canHavePriority record.type then ", ${toString record.priority}" else "";

        canHaveWeight = type: elem type [ "srv" ];
        weight =
          if record ? "weight" && canHaveWeight record.type then ", ${toString record.weight}" else "";

        canHavePort = type: elem type [ "srv" ];
        port = if record ? "port" && canHavePort record.type then ", ${toString record.port}" else "";

        canHaveParams = type: elem type [ "https" ];
        params = if record ? "params" && canHaveParams record.type then '', "${record.params}"'' else "";

        target = '', "${record.target}"'';
        modifiers = recordModifiers record;
      in
      "${type}(${label}${priority}${weight}${port}${target}${params}${modifiers})";
    cname = target;
    alias = target;
    dhcid = target;
    dname = target;
    mx = target;
    https = target;
    srv = target;

    dnskey =
      record:
      let
        type = lib.toUpper record.type;
        label = ''"${record.label}"'';
        flag = ", ${toString record.flag}";
        protocol = ", ${toString record.protocol}";
        algorithm = ", ${toString record.algorithm}";
        publicKey = '', "${record.publicKey}"'';
        modifiers = recordModifiers record;
      in
      "${type}(${label}${flag}${protocol}${algorithm}${publicKey}${modifiers})";

    ds =
      record:
      let
        type = lib.toUpper record.type;
        label = ''"${record.label}"'';
        keyTag = ", ${toString record.keyTag}";
        algorithm = ", ${toString record.algorithm}";
        digestType = ", ${toString record.digestType}";
        digest = '', "${record.digest}"'';
        modifiers = recordModifiers record;
      in
      "${type}(${label}${keyTag}${algorithm}${digestType}${digest}${modifiers})";

    ignore =
      record:
      let
        type = lib.toUpper record.type;
        labelSpec = ''"${record.labelSpec or "*"}"'';
        typeSpec = '', "${record.typeSpec or "*"}"'';
        targetSpec = '', "${record.targetSpec or "*"}"'';
        modifiers = recordModifiers record;
      in
      "${type}(${labelSpec}${typeSpec}${targetSpec}${modifiers})";

    include =
      record:
      let
        type = lib.toUpper record.type;
        domain = ''"${record.domain}"'';
      in
      "${type}(${domain})";

    ptr =
      record:
      let
        type = lib.toUpper record.type;
        address = ''"${record.address}"'';
        target = '', "${record.target}"'';
        modifiers = recordModifiers record;
      in
      "${type}(${address}${target}${modifiers})";

    sshfp =
      record:
      let
        type = lib.toUpper record.type;
        label = ''"${record.label}"'';
        algorithm = ", ${toString record.algorithm}";
        fingerptint_type = ", ${toString record.fingerptint_type}";
        fingerprint = '', "${record.fingerprint}"'';
        modifiers = recordModifiers record;
      in
      "${type}(${label}${algorithm}${fingerptint_type}${fingerprint}${modifiers})";

    txt =
      record:
      let
        type = lib.toUpper record.type;
        label = ''"${record.label}"'';
        text = '', "${record.text}"'';
        modifiers = recordModifiers record;
      in
      "${type}(${label}${text}${modifiers})";

    builder =
      record:
      let
        type = lib.toUpper record.type;
        parameters = toJSON record.parameters;
      in
      "${type}(${parameters})";
    caa_builder = builder;
    dkim_builder = builder;
    dmarc_builder = builder;
    m365_builder = builder;
    spf_builder = builder;

    caa =
      record: throw "Record of type ${record.type} not supported, use ${record.type}_builder instead";
  };
in
if typeHandler ? ${record.type} then
  typeHandler.${record.type} record
else
  throw "Record of type ${record.type} not supported"
