/// Service for encoding UUIDs into various formats.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:b/b.dart';
import 'package:base32/base32.dart' as base32_lib;
import 'package:base32/encodings.dart' as base32_encodings;
import 'package:uuid/parsing.dart';

import '../constants/alphabets.dart';
import '../encoders/encoders.dart';
import '../models/uuid_encoding_result.dart';

/// Service that provides UUID encoding functionality.
class UuidEncodingService {
  /// Encodes a UUID string into all supported formats.
  ///
  /// [uuidString] - The UUID string to encode (with or without dashes).
  /// [lowercaseBase32] - Whether to use lowercase for Base32 encodings.
  ///
  /// Returns a [UuidEncodingResult] containing all encoded formats.
  UuidEncodingResult encodeUuid(
    String uuidString, {
    bool lowercaseBase32 = false,
  }) {
    final uuidNoDashes = uuidString.replaceAll('-', '');
    final uuidBytes = UuidParsing.parseAsByteList(uuidString);

    return UuidEncodingResult(
      uuid: uuidString,
      base32: _encodeBase32(uuidBytes, lowercaseBase32),
      base36: _encodeBase(uuidNoDashes, base36),
      base48: _encodeBase(uuidNoDashes, base48Alphabet),
      base52: _encodeBase(uuidNoDashes, base52Alphabet),
      base58: _encodeBase58(uuidBytes, lowercaseBase32),
      base62: _encodeBase(uuidNoDashes, base62),
      base64: _encodeBase64(uuidBytes, lowercaseBase32),
    );
  }

  /// Encodes UUID bytes to Base32 variants.
  Base32Encoding _encodeBase32(Uint8List uuidBytes, bool lowercase) {
    final hex = base32_lib.base32
        .encode(uuidBytes, encoding: base32_encodings.Encoding.base32Hex);
    final crockford = base32_lib.base32
        .encode(uuidBytes, encoding: base32_encodings.Encoding.crockford);
    final rfc4648 = base32_lib.base32
        .encode(uuidBytes, encoding: base32_encodings.Encoding.standardRFC4648);
    final geohash = base32_lib.base32
        .encode(uuidBytes, encoding: base32_encodings.Encoding.geohash);
    final zbase = base32_lib.base32
        .encode(uuidBytes, encoding: base32_encodings.Encoding.zbase32);
    final ncname = UuidNCName.encodeBase32(uuidBytes, lowercase: !lowercase);

    if (lowercase) {
      return Base32Encoding(
        hex: hex.toLowerCase(),
        crockford: crockford.toLowerCase(),
        rfc4648: rfc4648.toLowerCase(),
        geohash: geohash.toLowerCase(),
        zbase: zbase.toLowerCase(),
        ncname: ncname.toLowerCase(),
      );
    }

    return Base32Encoding(
      hex: hex,
      crockford: crockford,
      rfc4648: rfc4648,
      geohash: geohash,
      zbase: zbase,
      ncname: ncname,
    );
  }

  /// Encodes UUID bytes to Base58 variants.
  Base58Encoding _encodeBase58(Uint8List uuidBytes, bool lowercase) {
    final uuidNoDashes =
        uuidBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    final bitcoin =
        BaseConversion(from: base16.toLowerCase(), to: base58)(uuidNoDashes);
    final ncname = UuidNCName.encodeBase58(uuidBytes);

    return Base58Encoding(
      bitcoin: bitcoin,
      ncname: lowercase ? ncname.toLowerCase() : ncname,
    );
  }

  /// Encodes UUID bytes to Base64 variants.
  Base64Encoding _encodeBase64(Uint8List uuidBytes, bool lowercase) {
    final uuidString =
        uuidBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    final formattedUuid =
        '${uuidString.substring(0, 8)}-${uuidString.substring(8, 12)}-${uuidString.substring(12, 16)}-${uuidString.substring(16, 20)}-${uuidString.substring(20, 32)}';

    final standard = const Base64Codec().encode(uuidBytes);
    final urlSafe = const Base64Codec.urlSafe().encode(uuidBytes);
    final ncname = UuidNCName.encodeBase64(uuidBytes);
    final uuidFormat = encodeBase64UUID(formattedUuid);

    return Base64Encoding(
      standard: standard,
      urlSafe: urlSafe,
      ncname: lowercase ? ncname.toLowerCase() : ncname,
      uuid: uuidFormat,
    );
  }

  /// Encodes a hex string to a different base using the provided alphabet.
  String _encodeBase(String hexString, String alphabet) {
    return BaseConversion(from: base16.toLowerCase(), to: alphabet)(
      hexString.toLowerCase(),
    );
  }
}
