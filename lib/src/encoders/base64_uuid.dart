/// Implementation of Base64UUID encoding specification.
///
/// Spec: https://github.com/sergeyprokhorenko/Base64UUID
///
/// Base64UUID provides a compact, sortable, and URL-safe case-sensitive text
/// representation of UUIDs using a 64-character ASCII alphabet.
///
/// The encoding is lossless - all 128 bits of the UUID are preserved by
/// prepending a 4-bit prefix (0100) to create a 132-bit value that encodes
/// to exactly 22 characters.
library;

import 'dart:typed_data';

/// The Base64UUID alphabet as defined in the specification.
/// $0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz
const String _alphabet =
    r'$0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz';

/// Encodes a UUID to Base64UUID format.
///
/// The encoding process:
/// 1. Convert UUID from hex to 128-bit binary
/// 2. Prepend 0100 (4 bits) to create a 132-bit value
/// 3. Encode the resulting 132-bit value as a 22-character Base64UUID string
///
/// The encoding is lossless and works with all UUID versions.
///
/// Example:
/// ```dart
/// var encoded = encodeBase64UUID('00000000-0000-0000-0000-000000000000');
/// print(encoded); // F$$$$$$$$$$$$$$$$$$$$
/// ```
String encodeBase64UUID(String uuid) {
  // Remove dashes and convert to bytes
  final hex = uuid.replaceAll('-', '');
  final bytes = Uint8List(16);
  for (var i = 0; i < 16; i++) {
    bytes[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
  }

  // Create a 132-bit value by prepending 0100 (4 bits) to the 128-bit UUID
  // Layout: [0100][UUID bit 0-127]
  // We'll store this in 17 bytes (136 bits, using first 132)
  final extended = Uint8List(17);

  // Byte 0: 0100 in top 4 bits + top 4 bits of bytes[0]
  extended[0] = 0x40 | ((bytes[0] >> 4) & 0x0F);

  // Bytes 1-15: shift all UUID bits left by 4 positions
  for (var i = 1; i < 16; i++) {
    extended[i] = ((bytes[i - 1] & 0x0F) << 4) | ((bytes[i] >> 4) & 0x0F);
  }

  // Byte 16: last 4 bits of UUID go to upper nibble, lower nibble stays 0
  extended[16] = (bytes[15] & 0x0F) << 4;

  // Now encode 132 bits as Base64UUID (22 characters, 6 bits each)
  final result = StringBuffer();
  var bitBuffer = 0;
  var bitsInBuffer = 0;
  var charCount = 0;

  for (var i = 0; i < 17 && charCount < 22; i++) {
    bitBuffer = (bitBuffer << 8) | extended[i];
    bitsInBuffer += 8;

    while (bitsInBuffer >= 6 && charCount < 22) {
      bitsInBuffer -= 6;
      final index = (bitBuffer >> bitsInBuffer) & 0x3F;
      result.write(_alphabet[index]);
      charCount++;
    }
  }

  return result.toString();
}

/// Decodes a Base64UUID string back to UUID format.
///
/// The decoding process:
/// 1. Decode the 22-character Base64UUID string to 132-bit value
/// 2. Extract the 128 bits of UUID data (ignoring the 4-bit prefix)
/// 3. Convert back to standard 36-character hexadecimal UUID format
///
/// The decoding is lossless and preserves all bits of the original UUID.
///
/// Example:
/// ```dart
/// var uuid = decodeBase64UUID('F$$$$$$$$$$$$$$$$$$$$');
/// print(uuid); // 00000000-0000-0000-0000-000000000000
/// ```
String decodeBase64UUID(String encoded) {
  // Remove optional quotes
  var str = encoded.trim();
  if (str.startsWith('"') && str.endsWith('"') && str.length > 2) {
    str = str.substring(1, str.length - 1);
  }

  if (str.length != 22) {
    throw ArgumentError(
        'Base64UUID string must be exactly 22 characters, got ${str.length}');
  }

  // Decode from Base64UUID to 132 bits
  final extended = Uint8List(17);
  var bitBuffer = 0;
  var bitsInBuffer = 0;
  var byteIndex = 0;

  for (var i = 0; i < str.length; i++) {
    final char = str[i];
    final index = _alphabet.indexOf(char);
    if (index == -1) {
      throw ArgumentError('Invalid Base64UUID character: $char');
    }

    bitBuffer = (bitBuffer << 6) | index;
    bitsInBuffer += 6;

    while (bitsInBuffer >= 8 && byteIndex < 17) {
      bitsInBuffer -= 8;
      extended[byteIndex++] = (bitBuffer >> bitsInBuffer) & 0xFF;
    }
  }

  // Flush any remaining bits (should be 4 bits left for byte 16)
  if (bitsInBuffer > 0 && byteIndex < 17) {
    extended[byteIndex] = (bitBuffer << (8 - bitsInBuffer)) & 0xFF;
  }

  // Now we have 132 bits in extended: [0100][128 bits UUID]
  // extended[0] = 0100xxxx where xxxx are the top 4 bits of UUID byte 0
  // We need to extract all 128 bits of the UUID

  final restored = Uint8List(16);

  // Reconstruct UUID bytes by extracting the shifted bits
  // Bytes 0-14: low 4 bits of extended[i] + high 4 bits of extended[i+1]
  for (var i = 0; i < 15; i++) {
    restored[i] = ((extended[i] & 0x0F) << 4) | ((extended[i + 1] >> 4) & 0x0F);
  }

  // Byte 15: low 4 bits of extended[15] + high 4 bits of extended[16]
  restored[15] = ((extended[15] & 0x0F) << 4) | ((extended[16] >> 4) & 0x0F);

  // Convert to hex string with dashes
  final hex = restored.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
}
