/// A placeholder class that represents an entity or model.
class UUIDFormatsItem {
  const UUIDFormatsItem(this.uuid, this.b32, this.b36, this.b48, this.b52,
      this.b58, this.b62, this.b64);

  final String uuid;
  final Base32Set b32;
  final String b36;
  final String b48;
  final String b52;
  final Base58Set b58;
  final String b62;
  final Base64Set b64;
}

class Base32Set {
  const Base32Set(this.b32hex, this.crockford, this.rfc4648, this.geohash,
      this.zbase, this.ncname);

  final String b32hex;
  final String crockford;
  final String rfc4648;
  final String geohash;
  final String zbase;
  final String ncname;

  @override
  String toString() {
    return '$b32hex (hex)\n$crockford (crockford)\n$rfc4648 (rfc)\n$geohash (geohash)\n$zbase (zbase)\n$ncname (ncname)';
  }
}

class Base58Set {
  const Base58Set(this.bitcoin, this.ncname);

  final String bitcoin;
  final String ncname;

  @override
  String toString() {
    return '$bitcoin (bitcoin)\n$ncname (ncname)';
  }
}

class Base64Set {
  const Base64Set(this.base64, this.base64url, this.ncname, this.uuid);

  final String base64;
  final String base64url;
  final String ncname;
  final String uuid;

  @override
  String toString() {
    return '$base64\n$base64url (url)\n$ncname (ncname)\n$uuid (uuid)';
  }
}
