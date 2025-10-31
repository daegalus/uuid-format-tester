import 'dart:typed_data';
import 'dart:convert';
import 'package:base32/base32.dart' as myb32;
import 'package:base32/encodings.dart' as myb32e;

/// UUID-NCName encoding implementation
/// Based on https://datatracker.ietf.org/doc/html/draft-taylor-uuid-ncname-04
///
/// This library implements three compact UUID representations:
/// - UUID-NCName-32: 26 characters using Base32 (case-insensitive)
/// - UUID-NCName-58: 23 characters using Base58 (with underscore padding)
/// - UUID-NCName-64: 22 characters using Base64url
///
/// All encodings preserve UUID version and variant information as "bookend"
/// characters that always start and end with letters A-P (case-insensitive).
class UuidNCName {
  /// The Base58 alphabet (Bitcoin variant)
  static const String _base58Alphabet =
      '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';

  /// Encode bytes to Base58 (Bitcoin encoding - preserves leading zeros)
  static String _bytesToBase58(List<int> bytes) {
    if (bytes.isEmpty) return '';

    // Count leading zero bytes
    int leadingZeros = 0;
    while (leadingZeros < bytes.length && bytes[leadingZeros] == 0) {
      leadingZeros++;
    }

    // Convert bytes to a big integer
    BigInt num = BigInt.zero;
    for (int byte in bytes) {
      num = (num << 8) | BigInt.from(byte);
    }

    // Convert to base58
    String result = '';
    while (num > BigInt.zero) {
      final remainder = (num % BigInt.from(58)).toInt();
      result = _base58Alphabet[remainder] + result;
      num = num ~/ BigInt.from(58);
    }

    // Add '1' for each leading zero byte
    return ('1' * leadingZeros) + result;
  }

  /// Decode Base58 to bytes (Bitcoin encoding - preserves leading zeros)
  static Uint8List _base58ToBytes(String encoded) {
    if (encoded.isEmpty) return Uint8List(0);

    // Count leading '1's (representing zero bytes)
    int leadingOnes = 0;
    while (leadingOnes < encoded.length && encoded[leadingOnes] == '1') {
      leadingOnes++;
    }

    // Convert from base58 to big integer
    BigInt num = BigInt.zero;
    for (int i = 0; i < encoded.length; i++) {
      final char = encoded[i];
      final value = _base58Alphabet.indexOf(char);
      if (value < 0) {
        throw ArgumentError('Invalid Base58 character: $char');
      }
      num = num * BigInt.from(58) + BigInt.from(value);
    }

    // Convert big integer to bytes
    final List<int> bytes = [];
    while (num > BigInt.zero) {
      bytes.insert(0, (num & BigInt.from(0xff)).toInt());
      num = num >> 8;
    }

    // Add leading zero bytes
    return Uint8List.fromList(List.filled(leadingOnes, 0) + bytes);
  }

  /// Shifts UUID bits to extract version and variant
  /// Returns a tuple of (shifted bytes, version, variant)
  static _ShiftResult _shiftEncode(List<int> uuidBytes) {
    // Step 1-2: Convert to four 32-bit unsigned network-endian integers
    final buffer = ByteData(16);
    for (int i = 0; i < 16; i++) {
      buffer.setUint8(i, uuidBytes[i]);
    }

    int int0 = buffer.getUint32(0, Endian.big);
    int int1 = buffer.getUint32(4, Endian.big);
    int int2 = buffer.getUint32(8, Endian.big);
    int int3 = buffer.getUint32(12, Endian.big);

    // Step 3-4: Extract version and variant
    int version = (int1 & 0x0000f000) >> 12;
    int variant = (int2 & 0xf0000000) >> 24;

    // Step 5-7: Apply shifting algorithm
    int newInt1 = (int1 & 0xffff0000) |
        ((int1 & 0x00000fff) << 4) |
        ((int2 & 0x0fffffff) >> 24);
    int newInt2 = ((int2 & 0x00ffffff) << 8) | (int3 >> 24);
    int newInt3 = ((int3 << 8) | variant) & 0xffffffff;

    // Step 8: Convert back to bytes
    final shiftedBuffer = ByteData(16);
    shiftedBuffer.setUint32(0, int0, Endian.big);
    shiftedBuffer.setUint32(4, newInt1, Endian.big);
    shiftedBuffer.setUint32(8, newInt2, Endian.big);
    shiftedBuffer.setUint32(12, newInt3, Endian.big);

    final shiftedBytes = Uint8List(16);
    for (int i = 0; i < 16; i++) {
      shiftedBytes[i] = shiftedBuffer.getUint8(i);
    }

    return _ShiftResult(shiftedBytes, version, variant);
  }

  /// Reverses the bit shifting to restore original UUID structure
  static Uint8List _shiftDecode(
      List<int> shiftedBytes, int version, int variant) {
    // Step 1-2: Convert to four 32-bit unsigned network-endian integers
    final buffer = ByteData(16);
    for (int i = 0; i < 16; i++) {
      buffer.setUint8(i, shiftedBytes[i]);
    }

    int int0 = buffer.getUint32(0, Endian.big);
    int int1 = buffer.getUint32(4, Endian.big);
    int int2 = buffer.getUint32(8, Endian.big);
    int int3 = buffer.getUint32(12, Endian.big);

    // Step 3: Extract variant from last byte
    int variantBits = (int3 & 0xf0) << 24;

    // Step 4-6: Reverse the shifting
    int3 = int3 >> 8;
    int3 |= ((int2 & 0xff) << 24);
    int2 = int2 >> 8;
    int2 |= ((int1 & 0xf) << 24) | variantBits;

    // Step 8: Restore version bits
    int1 = (int1 & 0xffff0000) | (version << 12) | ((int1 >> 4) & 0xfff);

    // Step 9: Convert back to bytes
    final resultBuffer = ByteData(16);
    resultBuffer.setUint32(0, int0, Endian.big);
    resultBuffer.setUint32(4, int1, Endian.big);
    resultBuffer.setUint32(8, int2, Endian.big);
    resultBuffer.setUint32(12, int3, Endian.big);

    final result = Uint8List(16);
    for (int i = 0; i < 16; i++) {
      result[i] = resultBuffer.getUint8(i);
    }

    return result;
  }

  /// Encodes a UUID as Base32-NCName (26 characters)
  ///
  /// Format: Version (1 char) + Base32 data (24 chars) + Variant (1 char)
  /// All characters are case-insensitive.
  ///
  /// Example: `068d0f22-7ce5-4fe2-9f81-3a09af4ed880` -> `ea2gq6it44x7c7aj2bgxu5weaj`
  static String encodeBase32(List<int> uuidBytes, {bool lowercase = true}) {
    final shifted = _shiftEncode(uuidBytes);
    final shiftedBytes = Uint8List.fromList(shifted.bytes);

    // Step 1: Shift ONLY the last octet right by one bit (align=true)
    // This is done to align the data to Base32's 5-bit boundaries
    shiftedBytes[15] >>= 1;

    // Step 2: Encode with Base32 (RFC 4648)
    String b32 = myb32.base32
        .encode(shiftedBytes, encoding: myb32e.Encoding.standardRFC4648);

    // Step 3: Truncate to 25 characters (removes padding)
    b32 = b32.replaceAll('=', '');
    if (b32.length > 25) {
      b32 = b32.substring(0, 25);
    }

    // Step 4: Convert version to Base32 character (lowercase 'a' offset)
    String versionChar = String.fromCharCode(((shifted.version & 15) + 97));

    // Step 5: Return version + b32
    String result = versionChar + b32;

    return lowercase ? result.toLowerCase() : result.toUpperCase();
  }

  /// Encodes a UUID as Base58-NCName (23 characters)
  ///
  /// Format: Version (1 char) + Base58 data (15-21 chars) + underscores + Variant (1 char)
  /// Bookend characters are case-insensitive.
  ///
  /// Example: `068d0f22-7ce5-4fe2-9f81-3a09af4ed880` -> `EBdYYqP7vH96E8SLjJaTH_J`
  static String encodeBase58(List<int> uuidBytes,
      {bool uppercaseBookends = true}) {
    final shifted = _shiftEncode(uuidBytes);

    // Step 1: Remove the last octet (contains variant)
    final dataBytes = Uint8List(15);
    for (int i = 0; i < 15; i++) {
      dataBytes[i] = shifted.bytes[i];
    }

    // Step 2: Get variant nibble from the last byte (upper 4 bits)
    int variantNibble = shifted.bytes[15] >> 4;
    String variantChar =
        String.fromCharCode((variantNibble & 15) + 65); // Base32 'A' offset

    // Step 3: Encode with Base58 (Bitcoin - preserves leading zeros)
    String b58 = _bytesToBase58(dataBytes);

    // Step 4: Pad with underscores to 21 characters
    while (b58.length < 21) {
      b58 += '_';
    }

    // Step 5: Convert version to Base32 character (uppercase 'A' offset)
    String versionChar = String.fromCharCode((shifted.version & 15) + 65);

    // Step 6: Return version + b58 + variant
    if (uppercaseBookends) {
      return versionChar + b58 + variantChar;
    } else {
      return versionChar.toLowerCase() + b58 + variantChar.toLowerCase();
    }
  }

  /// Encodes a UUID as Base64url-NCName (22 characters)
  ///
  /// Format: Version (1 char) + Base64url data (20 chars) + Variant (1 char)
  /// Bookend characters are case-insensitive.
  ///
  /// Example: `068d0f22-7ce5-4fe2-9f81-3a09af4ed880` -> `EBo0PInzl_i-BOgmvTtiAJ`
  static String encodeBase64(List<int> uuidBytes,
      {bool uppercaseBookends = true}) {
    final shifted = _shiftEncode(uuidBytes);
    final shiftedBytes = Uint8List.fromList(shifted.bytes);

    // Step 1: Shift ONLY the last octet right by two bits (align=true)
    // This is done to align the data to Base64's 6-bit boundaries
    shiftedBytes[15] >>= 2;

    // Step 2: Encode with base64url
    String b64 = base64Url.encode(shiftedBytes);

    // Step 3: Truncate to 21 characters (remove padding)
    b64 = b64.replaceAll('=', '');
    if (b64.length > 21) {
      b64 = b64.substring(0, 21);
    }

    // Step 4: Convert version to Base32 character (uppercase 'A' offset)
    String versionChar = String.fromCharCode((shifted.version & 15) + 65);

    // Step 5: Return version + b64
    if (uppercaseBookends) {
      return versionChar + b64;
    } else {
      return versionChar.toLowerCase() + b64;
    }
  }

  /// Decodes a UUID-NCName string back to UUID bytes
  ///
  /// Automatically detects the encoding type based on length:
  /// - 26 characters: Base32
  /// - 23 characters: Base58
  /// - 22 characters: Base64
  static Uint8List decode(String ncname) {
    // Determine encoding type by length
    if (ncname.length == 26) {
      return _decodeBase32(ncname);
    } else if (ncname.length == 23) {
      return _decodeBase58Ncname(ncname);
    } else if (ncname.length == 22) {
      return _decodeBase64(ncname);
    } else {
      throw ArgumentError('Invalid UUID-NCName length: ${ncname.length}');
    }
  }

  static Uint8List _decodeBase32(String ncname) {
    // Step 2: Extract version from first character
    final versionChar = ncname[0].toLowerCase();
    final version = versionChar.codeUnitAt(0) - 97; // lowercase 'a' offset
    if (version < 0 || version > 15) {
      throw ArgumentError('Invalid version character: ${ncname[0]}');
    }

    // Get the data portion
    String b32Data = ncname.substring(1).toUpperCase();

    // Add padding for Base32 decoder
    b32Data += 'A======';

    // Decode Base32
    final decoded =
        myb32.base32.decode(b32Data, encoding: myb32e.Encoding.standardRFC4648);

    // Shift ONLY the last byte left by one bit (reverse the right shift from encoding)
    final shiftedBytes = Uint8List.fromList(decoded);
    shiftedBytes[15] <<= 1;

    // The variant is encoded in the shifted data's last byte
    final variant = shiftedBytes[15] & 0xf0;

    // Reverse the shift
    return _shiftDecode(shiftedBytes, version, variant >> 4);
  }

  static Uint8List _decodeBase58Ncname(String ncname) {
    // Step 2: Extract version and variant from bookends
    final versionChar = ncname[0].toUpperCase();
    final version = versionChar.codeUnitAt(0) - 65;
    if (version < 0 || version > 15) {
      throw ArgumentError('Invalid version character: ${ncname[0]}');
    }

    final variantChar = ncname[ncname.length - 1].toUpperCase();
    int variantNibble = variantChar.codeUnitAt(0) - 65;
    if (variantNibble < 0 || variantNibble > 15) {
      throw ArgumentError(
          'Invalid variant character: ${ncname[ncname.length - 1]}');
    }

    // Step 3c: Remove bookends and trailing underscores
    String b58Data = ncname.substring(1, ncname.length - 1);
    b58Data = b58Data.replaceAll('_', '');

    // Step 3d: Decode Base58 (Bitcoin - preserves leading zeros)
    final dataBytes = _base58ToBytes(b58Data);

    // Pad to 15 bytes if necessary
    final paddedData = Uint8List(15);
    final offset = 15 - dataBytes.length;
    for (int i = 0; i < dataBytes.length; i++) {
      paddedData[offset + i] = dataBytes[i];
    }

    // Step 3e: Append variant byte (upper nibble from variantNibble, lower nibble as 0xf)
    final shiftedBytes = Uint8List(16);
    for (int i = 0; i < 15; i++) {
      shiftedBytes[i] = paddedData[i];
    }
    shiftedBytes[15] = (variantNibble << 4) | 0x0f;

    // Reverse the shift
    return _shiftDecode(shiftedBytes, version, variantNibble);
  }

  static Uint8List _decodeBase64(String ncname) {
    // Step 2: Extract version from first character
    final versionChar = ncname[0].toUpperCase();
    final version = versionChar.codeUnitAt(0) - 65; // uppercase 'A' offset
    if (version < 0 || version > 15) {
      throw ArgumentError('Invalid version character: ${ncname[0]}');
    }

    // Get the data portion
    String b64Data = ncname.substring(1);

    // Add padding for Base64 decoder
    b64Data += 'A==';

    // Decode Base64url
    final decoded = base64Url.decode(b64Data);

    // Shift ONLY the last byte left by two bits (reverse the right shift from encoding)
    final shiftedBytes = Uint8List.fromList(decoded);
    shiftedBytes[15] <<= 2;

    // The variant is encoded in the shifted data's last byte
    final variant = shiftedBytes[15] & 0xf0;

    // Reverse the shift
    return _shiftDecode(shiftedBytes, version, variant >> 4);
  }

  /// Formats UUID bytes as a canonical UUID string
  static String toCanonicalUuid(List<int> uuidBytes) {
    if (uuidBytes.length != 16) {
      throw ArgumentError('UUID must be exactly 16 bytes');
    }

    final hex =
        uuidBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
  }
}

/// Helper class to hold shift operation results
class _ShiftResult {
  final List<int> bytes;
  final int version;
  final int variant;

  _ShiftResult(this.bytes, this.version, this.variant);
}
