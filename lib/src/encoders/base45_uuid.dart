import 'dart:typed_data';

/// Base45 encoding for UUIDs as per RFC 9285
/// Alphabet: 0-9, A-Z, space, $%*+-./:
const String _base45Alphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ \$%*+-./:';

/// Encode UUID bytes to Base45
String encodeBase45(Uint8List bytes) {
  final result = StringBuffer();

  // Process bytes in pairs
  for (int i = 0; i < bytes.length; i += 2) {
    if (i + 1 < bytes.length) {
      // Two bytes available
      int value = (bytes[i] * 256) + bytes[i + 1];

      // Convert to base 45: value = c + (d * 45) + (e * 45 * 45)
      int c = value % 45;
      int d = (value ~/ 45) % 45;
      int e = value ~/ (45 * 45);

      result.write(_base45Alphabet[c]);
      result.write(_base45Alphabet[d]);
      result.write(_base45Alphabet[e]);
    } else {
      // Single byte remaining
      int value = bytes[i];

      // Convert to base 45: value = c + (45 * d)
      int c = value % 45;
      int d = value ~/ 45;

      result.write(_base45Alphabet[c]);
      result.write(_base45Alphabet[d]);
    }
  }

  return result.toString();
}

/// Decode Base45 string to bytes
Uint8List decodeBase45(String encoded) {
  final bytes = <int>[];

  // Process characters in groups of 3 or 2
  for (int i = 0; i < encoded.length;) {
    if (i + 2 < encoded.length) {
      // Three characters available
      int c = _base45Alphabet.indexOf(encoded[i]);
      int d = _base45Alphabet.indexOf(encoded[i + 1]);
      int e = _base45Alphabet.indexOf(encoded[i + 2]);

      if (c == -1 || d == -1 || e == -1) {
        throw FormatException('Invalid Base45 character');
      }

      int value = c + (d * 45) + (e * 45 * 45);

      if (value > 65535) {
        throw FormatException('Invalid Base45 encoding: value exceeds 65535');
      }

      bytes.add(value ~/ 256);
      bytes.add(value % 256);
      i += 3;
    } else if (i + 1 < encoded.length) {
      // Two characters remaining
      int c = _base45Alphabet.indexOf(encoded[i]);
      int d = _base45Alphabet.indexOf(encoded[i + 1]);

      if (c == -1 || d == -1) {
        throw FormatException('Invalid Base45 character');
      }

      int value = c + (45 * d);

      if (value > 255) {
        throw FormatException(
            'Invalid Base45 encoding: single byte exceeds 255');
      }

      bytes.add(value);
      i += 2;
    } else {
      throw FormatException('Invalid Base45 encoding: incomplete pair');
    }
  }

  return Uint8List.fromList(bytes);
}
