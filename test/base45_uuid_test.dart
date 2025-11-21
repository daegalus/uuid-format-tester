import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid_short_web/src/encoders/base45_uuid.dart';

void main() {
  group('Base45 Encoding Tests', () {
    test('Encode and decode "AB"', () {
      // Example from RFC 9285
      final input = Uint8List.fromList([65, 66]);
      final encoded = encodeBase45(input);
      expect(encoded, 'BB8');

      final decoded = decodeBase45(encoded);
      expect(decoded, input);
    });

    test('Encode and decode "Hello!!"', () {
      // Example from RFC 9285
      final input = Uint8List.fromList([72, 101, 108, 108, 111, 33, 33]);
      final encoded = encodeBase45(input);
      expect(encoded, '%69 VD92EX0');

      final decoded = decodeBase45(encoded);
      expect(decoded, input);
    });

    test('Encode and decode "base-45"', () {
      // Example from RFC 9285
      final input = Uint8List.fromList([98, 97, 115, 101, 45, 52, 53]);
      final encoded = encodeBase45(input);
      expect(encoded, 'UJCLQE7W581');

      final decoded = decodeBase45(encoded);
      expect(decoded, input);
    });

    test('Decode "QED8WEX0"', () {
      // Example from RFC 9285
      final encoded = 'QED8WEX0';
      final decoded = decodeBase45(encoded);
      final expected = Uint8List.fromList([105, 101, 116, 102, 33]);
      expect(decoded, expected);
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

      final encoded = encodeBase45(uuid);
      expect(encoded.isNotEmpty, true);

      final decoded = decodeBase45(encoded);
      expect(decoded, uuid);
    });

    test('Encode and decode empty bytes', () {
      final empty = Uint8List(0);
      final encoded = encodeBase45(empty);
      expect(encoded, '');

      final decoded = decodeBase45(encoded);
      expect(decoded.isEmpty, true);
    });

    test('Encode and decode single byte', () {
      final singleByte = Uint8List.fromList([42]);
      final encoded = encodeBase45(singleByte);
      expect(encoded.length, 2); // Single byte encodes to 2 characters

      final decoded = decodeBase45(encoded);
      expect(decoded, singleByte);
    });

    test('Invalid character throws error', () {
      expect(() => decodeBase45('INVALID@CHAR'), throwsFormatException);
    });

    test('Value exceeds 65535 throws error', () {
      // GGW represents 65536 which is > 65535
      expect(() => decodeBase45('GGW'), throwsFormatException);
    });
  });
}
