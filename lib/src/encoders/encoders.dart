/// UUID Encoding Algorithms Library
///
/// This library provides various encoding schemes for UUIDs:
/// - Base45: RFC 9285 encoding for QR codes
/// - Base64UUID: A lossless 132-bit encoding (4-bit prefix + 128-bit UUID)
/// - UUID-NCName: IETF standard encodings (Base32, Base58, Base64 variants)
/// - Base85: Ascii85 (Adobe) and Z85 (ZeroMQ) encodings
/// - Base91: Efficient encoding using 91 printable ASCII characters
/// - Base92: Encoding using 92 printable ASCII characters
/// - Base100: Emoji-based encoding
///
/// All encoders follow best practices and can be extracted into a standalone package.
library;

export 'base45_uuid.dart';
export 'base64_uuid.dart';
export 'base85_uuid.dart';
export 'base91_uuid.dart';
export 'base92_uuid.dart';
export 'base100_uuid.dart';
export 'uuid_ncname.dart';
