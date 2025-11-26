import 'package:flutter_test/flutter_test.dart';
import 'package:b/b.dart';
import '../lib/src/constants/alphabets.dart';

void main() {
  group('Base62 Encoding Variants Tests', () {
    test('Sort variant uses correct alphabet', () {
      // The sort alphabet starts with digits: 0-9, then A-Z, then a-z
      expect(base62SortAlphabet,
          '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz');
      expect(base62SortAlphabet.length, 62);
    });

    test('IEEE variant uses correct alphabet', () {
      // The IEEE alphabet starts with uppercase: A-Z, then a-z, then 0-9
      expect(base62IeeeAlphabet,
          'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789');
      expect(base62IeeeAlphabet.length, 62);
    });

    test('Sort and IEEE alphabets contain same characters', () {
      final sortChars = base62SortAlphabet.split('')..sort();
      final ieeeChars = base62IeeeAlphabet.split('')..sort();
      expect(sortChars.join(), ieeeChars.join());
    });

    test('Encode same value produces different results for each variant', () {
      const hexValue = 'f81d4fae7dec11d0a76500a0c91e6bf6';

      final sortEncoded = BaseConversion(
          from: base16.toLowerCase(), to: base62SortAlphabet)(hexValue);
      final ieeeEncoded = BaseConversion(
          from: base16.toLowerCase(), to: base62IeeeAlphabet)(hexValue);

      // They should be different because the alphabets have different orderings
      expect(sortEncoded, isNot(equals(ieeeEncoded)));
      expect(sortEncoded.isNotEmpty, true);
      expect(ieeeEncoded.isNotEmpty, true);
    });

    test('Sort variant encoding is reversible', () {
      const hexValue = '123e4567e89b12d3a456426614174000';

      final encoded = BaseConversion(
          from: base16.toLowerCase(), to: base62SortAlphabet)(hexValue);
      final decoded = BaseConversion(
          from: base62SortAlphabet, to: base16.toLowerCase())(encoded);

      expect(decoded, hexValue);
    });

    test('IEEE variant encoding is reversible', () {
      const hexValue = '123e4567e89b12d3a456426614174000';

      final encoded = BaseConversion(
          from: base16.toLowerCase(), to: base62IeeeAlphabet)(hexValue);
      final decoded = BaseConversion(
          from: base62IeeeAlphabet, to: base16.toLowerCase())(encoded);

      expect(decoded, hexValue);
    });

    test('Null UUID (all zeros) encodes correctly in both variants', () {
      const hexValue = '00000000000000000000000000000000';

      final sortEncoded = BaseConversion(
          from: base16.toLowerCase(), to: base62SortAlphabet)(hexValue);
      final ieeeEncoded = BaseConversion(
          from: base16.toLowerCase(), to: base62IeeeAlphabet)(hexValue);

      // All zeros should encode to '0' or 'A' depending on alphabet
      expect(sortEncoded, '0');
      expect(ieeeEncoded, 'A');
    });

    test('Max UUID (all Fs) encodes correctly in both variants', () {
      const hexValue = 'ffffffffffffffffffffffffffffffff';

      final sortEncoded = BaseConversion(
          from: base16.toLowerCase(), to: base62SortAlphabet)(hexValue);
      final ieeeEncoded = BaseConversion(
          from: base16.toLowerCase(), to: base62IeeeAlphabet)(hexValue);

      // Both should produce valid Base62 strings
      expect(sortEncoded.isNotEmpty, true);
      expect(ieeeEncoded.isNotEmpty, true);

      // They should be different
      expect(sortEncoded, isNot(equals(ieeeEncoded)));
    });

    test('Sort variant produces shorter encoding than hex for UUID', () {
      const hexValue = 'f81d4fae7dec11d0a76500a0c91e6bf6';

      final sortEncoded = BaseConversion(
          from: base16.toLowerCase(), to: base62SortAlphabet)(hexValue);

      // Base62 should be shorter than hex (32 chars)
      expect(sortEncoded.length, lessThan(32));
    });

    test('IEEE variant produces shorter encoding than hex for UUID', () {
      const hexValue = 'f81d4fae7dec11d0a76500a0c91e6bf6';

      final ieeeEncoded = BaseConversion(
          from: base16.toLowerCase(), to: base62IeeeAlphabet)(hexValue);

      // Base62 should be shorter than hex (32 chars)
      expect(ieeeEncoded.length, lessThan(32));
    });
  });
}
