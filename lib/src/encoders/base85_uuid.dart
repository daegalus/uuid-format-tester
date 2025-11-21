/// Implementation of Base85 encoding variants for UUIDs.
///
/// Supports three Base85 variants:
/// - Ascii85 (Adobe): Used in PostScript and PDF, with special compression
/// - Z85: ZeroMQ's Base85, designed for embedding in source code
/// - Custom: Simple Base85 without Y/Z compression logic
///
/// References:
/// - Ascii85: https://en.wikipedia.org/wiki/Ascii85
/// - Z85: https://rfc.zeromq.org/spec/32/
library;

import 'dart:typed_data';

/// Ascii85 (Adobe) alphabet: ASCII 33-117 (! to u)
const String _ascii85Alphabet =
    '!"#\$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstu';

/// Z85 alphabet: designed to avoid quotes and backslash for source code embedding
const String _z85Alphabet =
    '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.-:+=^!/*?&<>()[]{}@%\$#';

/// Custom alphabet: same as Ascii85 but without Y/Z compression
const String _customAlphabet = _ascii85Alphabet;

/// Encodes UUID bytes to Ascii85 (Adobe) format.
///
/// Ascii85 encodes 4 bytes into 5 characters from the alphabet (ASCII 33-117).
/// Special case: 4 zero bytes are encoded as 'z' for compression.
/// UUIDs are 16 bytes, which encode to 20 characters.
///
/// Example:
/// ```dart
/// var encoded = encodeAscii85(uuidBytes);
/// ```
String encodeAscii85(Uint8List bytes) {
  if (bytes.length != 16) {
    throw ArgumentError('UUID must be exactly 16 bytes');
  }

  final result = StringBuffer();

  // Process 4 bytes at a time
  for (var i = 0; i < bytes.length; i += 4) {
    // Convert 4 bytes to 32-bit unsigned integer (big-endian)
    final value = (bytes[i] << 24) |
        (bytes[i + 1] << 16) |
        (bytes[i + 2] << 8) |
        bytes[i + 3];

    // Special case: all zeros compress to 'z'
    if (value == 0) {
      result.write('z');
      continue;
    }

    // Encode as 5 base-85 digits (most significant first)
    final chars = <int>[];
    var remainder = value;
    for (var j = 0; j < 5; j++) {
      chars.insert(0, remainder % 85);
      remainder ~/= 85;
    }

    // Convert to ASCII characters
    for (var charIndex in chars) {
      result.write(_ascii85Alphabet[charIndex]);
    }
  }

  return result.toString();
}

/// Decodes Ascii85 (Adobe) format back to bytes.
///
/// Decodes groups of 5 characters (or 'z' for zeros) back to 4 bytes.
///
/// Example:
/// ```dart
/// var bytes = decodeAscii85(encoded);
/// ```
Uint8List decodeAscii85(String encoded) {
  final result = <int>[];
  var i = 0;

  while (i < encoded.length) {
    // Handle 'z' compression (4 zero bytes)
    if (encoded[i] == 'z') {
      result.addAll([0, 0, 0, 0]);
      i++;
      continue;
    }

    // Collect 5 characters (or fewer for last group)
    var charsToProcess = 5;
    if (i + 5 > encoded.length) {
      charsToProcess = encoded.length - i;
    }

    // Convert 5 characters to 32-bit value
    var value = 0;
    for (var j = 0; j < charsToProcess; j++) {
      final char = encoded[i + j];
      final charValue = _ascii85Alphabet.indexOf(char);
      if (charValue < 0) {
        throw ArgumentError('Invalid Ascii85 character: $char');
      }
      value = value * 85 + charValue;
    }

    // Pad if necessary (last group)
    if (charsToProcess < 5) {
      for (var j = charsToProcess; j < 5; j++) {
        value = value * 85 + 84; // 'u' is the highest value
      }
    }

    // Convert to 4 bytes (big-endian)
    result.add((value >> 24) & 0xFF);
    result.add((value >> 16) & 0xFF);
    result.add((value >> 8) & 0xFF);
    result.add(value & 0xFF);

    i += charsToProcess;
  }

  return Uint8List.fromList(result);
}

/// Encodes UUID bytes to Z85 format.
///
/// Z85 is ZeroMQ's Base85 variant designed for embedding in source code.
/// It uses a different alphabet that avoids quotes and backslashes.
/// UUIDs (16 bytes) encode to exactly 20 characters.
///
/// Unlike Ascii85, Z85 does NOT use the 'z' compression for zero bytes.
/// Z85 requires input length to be divisible by 4.
///
/// Example:
/// ```dart
/// var encoded = encodeZ85(uuidBytes);
/// ```
String encodeZ85(Uint8List bytes) {
  if (bytes.length != 16) {
    throw ArgumentError('UUID must be exactly 16 bytes');
  }

  final result = StringBuffer();

  // Process 4 bytes at a time
  for (var i = 0; i < bytes.length; i += 4) {
    // Convert 4 bytes to 32-bit unsigned integer (big-endian)
    final value = (bytes[i] << 24) |
        (bytes[i + 1] << 16) |
        (bytes[i + 2] << 8) |
        bytes[i + 3];

    // Encode as 5 base-85 digits (least significant first for Z85)
    final chars = <int>[];
    var remainder = value;
    for (var j = 0; j < 5; j++) {
      chars.insert(0, remainder % 85);
      remainder ~/= 85;
    }

    // Convert to Z85 alphabet characters
    for (var charIndex in chars) {
      result.write(_z85Alphabet[charIndex]);
    }
  }

  return result.toString();
}

/// Decodes Z85 format back to bytes.
///
/// Decodes groups of 5 characters back to 4 bytes using the Z85 alphabet.
///
/// Example:
/// ```dart
/// var bytes = decodeZ85(encoded);
/// ```
Uint8List decodeZ85(String encoded) {
  if (encoded.length % 5 != 0) {
    throw ArgumentError('Z85 encoded string length must be divisible by 5');
  }

  final result = <int>[];

  for (var i = 0; i < encoded.length; i += 5) {
    // Convert 5 characters to 32-bit value
    var value = 0;
    for (var j = 0; j < 5; j++) {
      final char = encoded[i + j];
      final charValue = _z85Alphabet.indexOf(char);
      if (charValue < 0) {
        throw ArgumentError('Invalid Z85 character: $char');
      }
      value = value * 85 + charValue;
    }

    // Convert to 4 bytes (big-endian)
    result.add((value >> 24) & 0xFF);
    result.add((value >> 16) & 0xFF);
    result.add((value >> 8) & 0xFF);
    result.add(value & 0xFF);
  }

  return Uint8List.fromList(result);
}

/// Encodes UUID bytes to Custom Base85 format.
///
/// Custom Base85 uses the same alphabet as Ascii85 but WITHOUT any special
/// compression for zeros (no 'z') or spaces (no 'y'). This is a simpler
/// variant that always encodes 4 bytes to exactly 5 characters.
/// UUIDs (16 bytes) encode to exactly 20 characters.
///
/// Example:
/// ```dart
/// var encoded = encodeCustomBase85(uuidBytes);
/// ```
String encodeCustomBase85(Uint8List bytes) {
  if (bytes.length != 16) {
    throw ArgumentError('UUID must be exactly 16 bytes');
  }

  final result = StringBuffer();

  // Process 4 bytes at a time
  for (var i = 0; i < bytes.length; i += 4) {
    // Convert 4 bytes to 32-bit unsigned integer (big-endian)
    final value = (bytes[i] << 24) |
        (bytes[i + 1] << 16) |
        (bytes[i + 2] << 8) |
        bytes[i + 3];

    // NO special compression - always encode as 5 characters
    // Encode as 5 base-85 digits (most significant first)
    final chars = <int>[];
    var remainder = value;
    for (var j = 0; j < 5; j++) {
      chars.insert(0, remainder % 85);
      remainder ~/= 85;
    }

    // Convert to ASCII characters
    for (var charIndex in chars) {
      result.write(_customAlphabet[charIndex]);
    }
  }

  return result.toString();
}

/// Decodes Custom Base85 format back to bytes.
///
/// Decodes groups of 5 characters back to 4 bytes without handling
/// special compression characters.
///
/// Example:
/// ```dart
/// var bytes = decodeCustomBase85(encoded);
/// ```
Uint8List decodeCustomBase85(String encoded) {
  if (encoded.length % 5 != 0) {
    throw ArgumentError(
        'Custom Base85 encoded string length must be divisible by 5');
  }

  final result = <int>[];

  for (var i = 0; i < encoded.length; i += 5) {
    // Convert 5 characters to 32-bit value
    var value = 0;
    for (var j = 0; j < 5; j++) {
      final char = encoded[i + j];
      final charValue = _customAlphabet.indexOf(char);
      if (charValue < 0) {
        throw ArgumentError('Invalid Custom Base85 character: $char');
      }
      value = value * 85 + charValue;
    }

    // Convert to 4 bytes (big-endian)
    result.add((value >> 24) & 0xFF);
    result.add((value >> 16) & 0xFF);
    result.add((value >> 8) & 0xFF);
    result.add(value & 0xFF);
  }

  return Uint8List.fromList(result);
}
