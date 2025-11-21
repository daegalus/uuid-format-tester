import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import '../lib/src/encoders/base91_uuid.dart';

void main() {
  group('Base91 Encoding Tests', () {
    test('Encode and decode simple text', () {
      final input = Uint8List.fromList('Hello World'.codeUnits);
      final encoded = encodeBase91(input);
      expect(encoded.isNotEmpty, true);

      final decoded = decodeBase91(encoded);
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

      final encoded = encodeBase91(uuid);
      expect(encoded.isNotEmpty, true);

      final decoded = decodeBase91(encoded);
      expect(decoded, uuid);
    });

    test('Encode and decode empty bytes', () {
      final empty = Uint8List(0);
      final encoded = encodeBase91(empty);
      expect(encoded, '');

      final decoded = decodeBase91(encoded);
      expect(decoded.isEmpty, true);
    });

    test('Encode and decode single byte', () {
      final singleByte = Uint8List.fromList([42]);
      final encoded = encodeBase91(singleByte);
      expect(encoded.isNotEmpty, true);

      final decoded = decodeBase91(encoded);
      expect(decoded, singleByte);
    });

    test('Encode and decode all zeros', () {
      final zeros = Uint8List(16);
      final encoded = encodeBase91(zeros);
      expect(encoded.isNotEmpty, true);

      final decoded = decodeBase91(encoded);
      expect(decoded, zeros);
    });

    test('Encode and decode all 0xFF', () {
      final allFF = Uint8List.fromList(List.filled(16, 0xFF));
      final encoded = encodeBase91(allFF);
      expect(encoded.isNotEmpty, true);

      final decoded = decodeBase91(encoded);
      expect(decoded, allFF);
    });

    test('Base91 is more compact than Base64', () {
      final testData = Uint8List.fromList(List.generate(100, (i) => i));
      final base91Encoded = encodeBase91(testData);

      // Base91 should be ~23% more efficient than Base64
      // Base64 would be ~133 characters for 100 bytes
      // Base91 should be ~110-120 characters
      expect(base91Encoded.length, lessThan(130));
    });

    test('Invalid character throws error', () {
      // Test with a character not in the Base91 alphabet (like '-')
      expect(() => decodeBase91('ABC-DEF'), throwsFormatException);
    });
  });
}
