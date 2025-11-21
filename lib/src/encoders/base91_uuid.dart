import 'dart:typed_data';

/// Base91 encoding
/// Alphabet: A-Z, a-z, 0-9, and special characters (91 total)
/// Excludes: dash (-), backslash (\), apostrophe (')
const String _base91Alphabet =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#\$%&()*+,./:;<=>?@[]^_`{|}~"';

/// Encode UUID bytes to Base91
/// Based on the reference implementation from http://base91.sourceforge.net/
String encodeBase91(Uint8List bytes) {
  if (bytes.isEmpty) return '';

  final result = StringBuffer();
  int accumulator = 0;
  int bits = 0;

  for (int byte in bytes) {
    accumulator |= byte << bits;
    bits += 8;

    if (bits > 13) {
      int value = accumulator & 8191; // 13 bits

      if (value > 88) {
        accumulator >>= 13;
        bits -= 13;
      } else {
        value = accumulator & 16383; // 14 bits
        accumulator >>= 14;
        bits -= 14;
      }

      result.write(_base91Alphabet[value % 91]);
      result.write(_base91Alphabet[value ~/ 91]);
    }
  }

  // Handle remaining bits
  if (bits > 0) {
    result.write(_base91Alphabet[accumulator % 91]);
    if (bits > 7 || accumulator > 90) {
      result.write(_base91Alphabet[accumulator ~/ 91]);
    }
  }

  return result.toString();
}

/// Decode Base91 string to bytes
Uint8List decodeBase91(String encoded) {
  if (encoded.isEmpty) return Uint8List(0);

  final bytes = <int>[];
  int accumulator = 0;
  int bits = 0;
  int value = -1;

  for (int i = 0; i < encoded.length; i++) {
    int charValue = _base91Alphabet.indexOf(encoded[i]);

    if (charValue == -1) {
      throw FormatException('Invalid Base91 character: ${encoded[i]}');
    }

    if (value == -1) {
      value = charValue;
    } else {
      value += charValue * 91;

      int numBits;
      if ((value & 8191) > 88) {
        numBits = 13;
      } else {
        numBits = 14;
      }

      accumulator |= value << bits;
      bits += numBits;

      // Extract complete bytes
      do {
        bytes.add(accumulator & 0xFF);
        accumulator >>= 8;
        bits -= 8;
      } while (bits > 7);

      value = -1;
    }
  }

  // Handle remaining value
  if (value != -1) {
    bytes.add((accumulator | (value << bits)) & 0xFF);
  }

  return Uint8List.fromList(bytes);
}
