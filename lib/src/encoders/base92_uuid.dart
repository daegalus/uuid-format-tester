import 'dart:typed_data';

/// Base92 encoding
/// Uses 92 printable ASCII characters (excluding tilde which marks empty string)
const String _base92Alphabet =
    '!#\$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_abcdefghijklmnopqrstuvwxyz{|}';

/// Encode UUID bytes to Base92
String encodeBase92(Uint8List bytes) {
  if (bytes.isEmpty) {
    return '~';
  }

  final result = StringBuffer();

  // Process bytes in 13-bit blocks (pairs of base91 characters)
  int accumulator = 0;
  int bits = 0;

  for (int byte in bytes) {
    accumulator |= byte << bits;
    bits += 8;

    while (bits >= 13) {
      int value = accumulator & 0x1FFF; // 13 bits

      // Convert to two base91 characters (91^2 = 8281 > 2^13 = 8192)
      result.write(_base92Alphabet[value ~/ 91]);
      result.write(_base92Alphabet[value % 91]);

      accumulator >>= 13;
      bits -= 13;
    }
  }

  // Handle remaining bits
  if (bits > 0) {
    if (bits <= 6) {
      // Pad to 6 bits
      int value = accumulator & 0x3F; // 6 bits
      result.write(_base92Alphabet[value]);
    } else {
      // Pad to 13 bits
      int value = accumulator & 0x1FFF; // 13 bits
      result.write(_base92Alphabet[value ~/ 91]);
      result.write(_base92Alphabet[value % 91]);
    }
  }

  return result.toString();
}

/// Decode Base92 string to bytes
Uint8List decodeBase92(String encoded) {
  if (encoded == '~') {
    return Uint8List(0);
  }

  final bytes = <int>[];
  int accumulator = 0;
  int bits = 0;

  for (int i = 0; i < encoded.length; i += 2) {
    if (i + 1 < encoded.length) {
      // Process pair of characters
      int c1 = _base92Alphabet.indexOf(encoded[i]);
      int c2 = _base92Alphabet.indexOf(encoded[i + 1]);

      if (c1 == -1 || c2 == -1) {
        throw FormatException('Invalid Base92 character');
      }

      int value = c1 * 91 + c2;
      accumulator |= value << bits;
      bits += 13;

      // Extract bytes
      while (bits >= 8) {
        bytes.add(accumulator & 0xFF);
        accumulator >>= 8;
        bits -= 8;
      }
    } else {
      // Single character remaining (6 bits)
      int c = _base92Alphabet.indexOf(encoded[i]);

      if (c == -1) {
        throw FormatException('Invalid Base92 character');
      }

      accumulator |= c << bits;
      bits += 6;

      if (bits >= 8) {
        bytes.add(accumulator & 0xFF);
      }
    }
  }

  return Uint8List.fromList(bytes);
}
