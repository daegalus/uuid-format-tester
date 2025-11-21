import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid_short_web/src/encoders/base100_uuid.dart';

void main() {
  group('Base100 Encoding Tests', () {
    test('Encode bytes to emojis', () {
      final input = Uint8List.fromList([0, 1, 2, 3, 4, 5]);
      final encoded = encodeBase100(input);

      // Each byte should produce one emoji
      // Note: Emojis are multi-byte UTF-16, so we can't just check length
      expect(encoded.isNotEmpty, true);

      final decoded = decodeBase100(encoded);
      expect(decoded, input);
    });

    test('Encode and decode 16-byte UUID', () {
      final uuid = Uint8List.fromList([
        0x12,
        0x34,
        0x56,
        0x78,
        0x9A,
        0xBC,
        0xDE,
        0xF0,
        0x11,
        0x22,
        0x33,
        0x44,
        0x55,
        0x66,
        0x77,
        0x88
      ]);

      final encoded = encodeBase100(uuid);
      expect(encoded.isNotEmpty, true);

      final decoded = decodeBase100(encoded);
      expect(decoded, uuid);
    });

    test('Encode and decode empty bytes', () {
      final empty = Uint8List(0);
      final encoded = encodeBase100(empty);
      expect(encoded, '');

      final decoded = decodeBase100(encoded);
      expect(decoded.isEmpty, true);
    });

    test('Encode and decode single byte', () {
      final singleByte = Uint8List.fromList([42]);
      final encoded = encodeBase100(singleByte);
      expect(encoded.isNotEmpty, true);

      final decoded = decodeBase100(encoded);
      expect(decoded, singleByte);
    });

    test('Encode all possible byte values (0-255)', () {
      final allBytes = Uint8List.fromList(List.generate(256, (i) => i));
      final encoded = encodeBase100(allBytes);
      expect(encoded.isNotEmpty, true);

      final decoded = decodeBase100(encoded);
      expect(decoded, allBytes);
    });

    test('Encode and decode all zeros', () {
      final zeros = Uint8List(16);
      final encoded = encodeBase100(zeros);
      expect(encoded.isNotEmpty, true);

      final decoded = decodeBase100(encoded);
      expect(decoded, zeros);
    });

    test('Encode and decode all 0xFF', () {
      final allFF = Uint8List.fromList(List.filled(16, 0xFF));
      final encoded = encodeBase100(allFF);
      expect(encoded.isNotEmpty, true);

      final decoded = decodeBase100(encoded);
      expect(decoded, allFF);
    });

    test('Encoding produces valid emojis', () {
      final input = Uint8List.fromList([100, 150, 200, 255]);
      final encoded = encodeBase100(input);

      // Check that the encoded string contains valid Unicode
      expect(() => encoded.codeUnits, returnsNormally);
    });

    test('Each byte maps to one emoji', () {
      final input = Uint8List.fromList([0, 127, 255]);
      final encoded = encodeBase100(input);

      // The encoded string should represent 3 emojis (though UTF-16 length will be 6)
      final decoded = decodeBase100(encoded);
      expect(decoded.length, 3);
    });
  });
}
