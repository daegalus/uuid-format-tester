import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid_short_web/src/encoders/base92_uuid.dart';

void main() {
  group('Base92 Encoding Tests', () {
    test('Encode and decode simple text', () {
      final input = Uint8List.fromList('dCode'.codeUnits);
      final encoded = encodeBase92(input);
      expect(encoded.isNotEmpty, true);

      final decoded = decodeBase92(encoded);
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

      final encoded = encodeBase92(uuid);
      expect(encoded.isNotEmpty, true);

      final decoded = decodeBase92(encoded);
      expect(decoded, uuid);
    });

    test('Encode and decode empty bytes', () {
      final empty = Uint8List(0);
      final encoded = encodeBase92(empty);
      expect(encoded, '~'); // Tilde represents empty string

      final decoded = decodeBase92(encoded);
      expect(decoded.isEmpty, true);
    });

    test('Encode and decode single byte', () {
      final singleByte = Uint8List.fromList([42]);
      final encoded = encodeBase92(singleByte);
      expect(encoded.isNotEmpty, true);

      final decoded = decodeBase92(encoded);
      expect(decoded, singleByte);
    });

    test('Encode and decode all zeros', () {
      final zeros = Uint8List(16);
      final encoded = encodeBase92(zeros);
      expect(encoded.isNotEmpty, true);

      final decoded = decodeBase92(encoded);
      expect(decoded, zeros);
    });

    test('Encode and decode all 0xFF', () {
      final allFF = Uint8List.fromList(List.filled(16, 0xFF));
      final encoded = encodeBase92(allFF);
      expect(encoded.isNotEmpty, true);

      final decoded = decodeBase92(encoded);
      expect(decoded, allFF);
    });

    test('Encode even number of bytes', () {
      final evenBytes = Uint8List.fromList([1, 2, 3, 4, 5, 6]);
      final encoded = encodeBase92(evenBytes);
      expect(encoded.isNotEmpty, true);

      final decoded = decodeBase92(encoded);
      expect(decoded, evenBytes);
    });

    test('Encode odd number of bytes', () {
      final oddBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final encoded = encodeBase92(oddBytes);
      expect(encoded.isNotEmpty, true);

      final decoded = decodeBase92(encoded);
      expect(decoded, oddBytes);
    });

    test('Invalid character throws error', () {
      expect(
          () => decodeBase92('INVALID~TILDE~IN~MIDDLE'), throwsFormatException);
    });
  });
}
