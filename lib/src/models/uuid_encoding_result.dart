/// Data models for UUID encoding results.
library;

/// Result of encoding a UUID into multiple formats.
class UuidEncodingResult {
  const UuidEncodingResult({
    required this.uuid,
    required this.base32,
    required this.base36,
    required this.base48,
    required this.base52,
    required this.base58,
    required this.base62,
    required this.base64,
  });

  final String uuid;
  final Base32Encoding base32;
  final String base36;
  final String base48;
  final String base52;
  final Base58Encoding base58;
  final String base62;
  final Base64Encoding base64;
}

/// Base32 encoding variants.
class Base32Encoding {
  const Base32Encoding({
    required this.hex,
    required this.crockford,
    required this.rfc4648,
    required this.geohash,
    required this.zbase,
    required this.ncname,
  });

  final String hex;
  final String crockford;
  final String rfc4648;
  final String geohash;
  final String zbase;
  final String ncname;

  @override
  String toString() {
    return '$hex (hex)\n$crockford (crockford)\n$rfc4648 (rfc)\n$geohash (geohash)\n$zbase (zbase)\n$ncname (ncname)';
  }
}

/// Base58 encoding variants.
class Base58Encoding {
  const Base58Encoding({
    required this.bitcoin,
    required this.ncname,
  });

  final String bitcoin;
  final String ncname;

  @override
  String toString() {
    return '$bitcoin (bitcoin)\n$ncname (ncname)';
  }
}

/// Base64 encoding variants.
class Base64Encoding {
  const Base64Encoding({
    required this.standard,
    required this.urlSafe,
    required this.ncname,
    required this.uuid,
  });

  final String standard;
  final String urlSafe;
  final String ncname;
  final String uuid;

  @override
  String toString() {
    return '$standard\n$urlSafe (url)\n$ncname (ncname)\n$uuid (uuid)';
  }
}
