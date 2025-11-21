import 'dart:typed_data';

/// Base100 encoding - each byte is represented by a unique emoji
/// Emoji range: U+1F3F7 to U+1F4F6 (256 emojis total)
const int _base100Offset = 0x1F3F7;

/// Encode UUID bytes to Base100 (emoji encoding)
String encodeBase100(Uint8List bytes) {
  final result = StringBuffer();

  for (int byte in bytes) {
    // Each byte (0-255) maps to an emoji
    int codePoint = _base100Offset + byte;
    result.writeCharCode(codePoint);
  }

  return result.toString();
}

/// Decode Base100 (emoji) string to bytes
Uint8List decodeBase100(String encoded) {
  final bytes = <int>[];

  // Process each character (emoji)
  for (int i = 0; i < encoded.length; i++) {
    int codeUnit = encoded.codeUnitAt(i);

    // Handle UTF-16 surrogate pairs for emojis
    if (codeUnit >= 0xD800 && codeUnit <= 0xDBFF && i + 1 < encoded.length) {
      int highSurrogate = codeUnit;
      int lowSurrogate = encoded.codeUnitAt(i + 1);

      if (lowSurrogate >= 0xDC00 && lowSurrogate <= 0xDFFF) {
        // Combine surrogates to get the actual code point
        int codePoint =
            0x10000 + ((highSurrogate & 0x3FF) << 10) + (lowSurrogate & 0x3FF);

        // Check if it's in the valid Base100 range
        if (codePoint >= _base100Offset && codePoint < _base100Offset + 256) {
          bytes.add(codePoint - _base100Offset);
          i++; // Skip the low surrogate
        } else {
          throw FormatException(
              'Invalid Base100 emoji: U+${codePoint.toRadixString(16).toUpperCase()}');
        }
      }
    } else {
      throw FormatException('Invalid Base100 character');
    }
  }

  return Uint8List.fromList(bytes);
}
