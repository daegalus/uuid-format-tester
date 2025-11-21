/// UUID Encoding Algorithms Library
///
/// This library provides various encoding schemes for UUIDs:
/// - Base64UUID: A lossless 132-bit encoding (4-bit prefix + 128-bit UUID)
/// - UUID-NCName: IETF standard encodings (Base32, Base58, Base64 variants)
/// - Base85: Ascii85 (Adobe) and Z85 (ZeroMQ) encodings
///
/// All encoders follow best practices and can be extracted into a standalone package.
library;

export 'base64_uuid.dart';
export 'base85_uuid.dart';
export 'uuid_ncname.dart';
