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
        target = '', "${record.target}"'';
        modifiers = recordModifiers record;
      in
      "${type}(${label}${target}${modifiers})";
    cname = target;
    alias = target;
    dhcid = target;
    dname = target;
    ns = target;

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

    https =
      record:
      let
        type = lib.toUpper record.type;
        label = ''"${record.label}"'';
        priority = ", ${toString record.priority}";
        target = '', "${record.target}"'';
        params = '', "${record.params}"'';
        modifiers = recordModifiers record;
      in
      "${type}(${label}${priority}${target}${params}${modifiers})";

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

    mx =
      record:
      let
        type = lib.toUpper record.type;
        label = ''"${record.label}"'';
        priority = ", ${toString record.priority}";
        target = '', "${record.target}"'';
        modifiers = recordModifiers record;
      in
      "${type}(${label}${priority}${target}${modifiers})";

    nameserver =
      record:
      let
        type = lib.toUpper record.type;
        target = ''"${record.target}"'';
      in
      "${type}(${target})";

    nameserver_ttl =
      record:
      let
        type = lib.toUpper record.type;
        ttl = toString record.ttl;
      in
      "${type}(${ttl})";

    naptr =
      record:
      let
        type = lib.toUpper record.type;
        label = ''"${record.label}"'';
        order = ", ${toString record.order}";
        preference = ", ${toString record.preference}";
        terminalflag = '', "${record.terminalflag}"'';
        service = '', "${record.service}"'';
        regexp = '', "${record.regexp}"'';
        target = '', "${record.target}"'';
        modifiers = recordModifiers record;
      in
      "${type}(${label}${order}${preference}${terminalflag}${service}${regexp}${target}${modifiers})";

    ptr =
      record:
      let
        type = lib.toUpper record.type;
        address = ''"${record.address}"'';
        target = '', "${record.target}"'';
        modifiers = recordModifiers record;
      in
      "${type}(${address}${target}${modifiers})";

    soa =
      record:
      let
        type = lib.toUpper record.type;
        label = ''"${record.label}"'';
        ns = '', "${record.ns}"'';
        mbox = '', "${record.mbox}"'';
        refresh_rate = ", ${toString record.refresh_rate}";
        retry_rate = ", ${toString record.retry_rate}";
        expire_time = ", ${toString record.expire_time}";
        default_ttl = ", ${toString record.default_ttl}";
        modifiers = recordModifiers record;
      in
      "${type}(${label}${ns}${mbox}${refresh_rate}${retry_rate}${expire_time}${default_ttl}${modifiers})";

    srv =
      record:
      let
        type = lib.toUpper record.type;
        label = ''"${record.label}"'';
        priority = ", ${toString record.priority}";
        weight = ", ${toString record.weight}";
        port = ", ${toString record.port}";
        target = '', "${record.target}"'';
        modifiers = recordModifiers record;
      in
      "${type}(${label}${priority}${weight}${port}${target}${modifiers})";

    sshfp =
      record:
      let
        type = lib.toUpper record.type;
        label = ''"${record.label}"'';
        algorithm = ", ${toString record.algorithm}";
        fingerprint_type = ", ${toString record.fingerprint_type}";
        fingerprint = '', "${record.fingerprint}"'';
        modifiers = recordModifiers record;
      in
      "${type}(${label}${algorithm}${fingerprint_type}${fingerprint}${modifiers})";

    svcb =
      record:
      let
        type = lib.toUpper record.type;
        label = ''"${record.label}"'';
        priority = ", ${toString record.priority}";
        address = '', "${record.address}"'';
        params = '', "${record.params}"'';
        modifiers = recordModifiers record;
      in
      "${type}(${label}${priority}${address}${params}${modifiers})";

    tlsa =
      record:
      let
        type = lib.toUpper record.type;
        label = ''"${record.label}"'';
        usage = ", ${toString record.usage}";
        selector = ", ${toString record.selector}";
        matching_type = ", ${toString record.matching_type}";
        certificate = '', "${record.certificate}"'';
        modifiers = recordModifiers record;
      in
      "${type}(${label}${usage}${selector}${matching_type}${certificate}${modifiers})";

    txt =
      record:
      let
        type = lib.toUpper record.type;
        label = ''"${record.label}"'';
        quoteString = x:
          ''"${lib.replaceStrings [ "\"" ] [ "\\\"" ] x}"'';
        text =
          if lib.isList record.text
          then ", [" + lib.concatMapStringsSep ", " quoteString record.text + "]"
          else '', ${quoteString record.text}'';
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
    loc_builder_dd = builder;
    loc_builder_dmm_str = builder;
    loc_builder_dms_str = builder;
    loc_builder_str = builder;

    caa =
      record: throw "Record of type ${record.type} not supported, use ${record.type}_builder instead";

    loc =
      record:
      throw "Record of type ${record.type} not supported, use loc_builder_dd, loc_builder_dmm_str, loc_builder_dms_str, or loc_builder_str instead";

  };
in
if typeHandler ? ${record.type} then
  typeHandler.${record.type} record
else
  throw "Record of type ${record.type} not supported"
