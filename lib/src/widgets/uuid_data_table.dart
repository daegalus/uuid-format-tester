/// Data table widget for displaying UUID encodings.
library;

import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../models/uuid_encoding_result.dart';

/// Table displaying UUIDs and their various encodings.
class UuidDataTable extends StatelessWidget {
  const UuidDataTable({
    required this.items,
    super.key,
  });

  final List<UuidEncodingResult> items;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            localizations.noUuidsYet,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    // Use LayoutBuilder to determine if we should use cards or table
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use card layout for narrow screens (mobile)
        if (constraints.maxWidth < 900) {
          return _buildCardLayout(context);
        }
        // Use table layout for wide screens (desktop)
        return _buildTableLayout(localizations);
      },
    );
  }

  /// Builds a card-based layout for mobile devices.
  Widget _buildCardLayout(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: ExpansionTile(
            title: SelectableText(
              item.uuid,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEncodingSection(localizations.base32, null,
                        base32Variants(item.base32)),
                    const Divider(),
                    _buildEncodingSection(
                        localizations.base36, item.base36, null),
                    const Divider(),
                    _buildEncodingSection(
                        localizations.base48, item.base48, null),
                    const Divider(),
                    _buildEncodingSection(
                        localizations.base52, item.base52, null),
                    const Divider(),
                    _buildEncodingSection(localizations.base58, null,
                        base58Variants(item.base58)),
                    const Divider(),
                    _buildEncodingSection(
                        localizations.base62, item.base62, null),
                    const Divider(),
                    _buildEncodingSection(localizations.base64, null,
                        base64Variants(item.base64)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds a section for a single encoding type in the card layout.
  Widget _buildEncodingSection(
      String title, String? value, List<MapEntry<String, String>>? variants) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        if (variants != null && variants.isNotEmpty)
          ...variants.map((variant) => Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        variant.key,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SelectableText(
                        variant.value,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
        else if (value != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SelectableText(
              value,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  /// Builds the table layout for desktop devices.
  Widget _buildTableLayout(AppLocalizations localizations) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 40,
          dataRowMinHeight: 60,
          dataRowMaxHeight: double.infinity,
          columnSpacing: 16,
          columns: [
            DataColumn(
                label: Text(localizations.uuid,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text(localizations.base32,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text(localizations.base36,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text(localizations.base48,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text(localizations.base52,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text(localizations.base58,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text(localizations.base62,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text(localizations.base64,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: items.map((item) => _buildDataRow(item)).toList(),
        ),
      ),
    );
  }

  /// Builds a data row for a single UUID encoding result.
  DataRow _buildDataRow(UuidEncodingResult item) {
    return DataRow(
      cells: [
        DataCell(SelectableText(item.uuid)),
        DataCell(_buildVariantTable(base32Variants(item.base32))),
        DataCell(SelectableText(item.base36)),
        DataCell(SelectableText(item.base48)),
        DataCell(SelectableText(item.base52)),
        DataCell(_buildVariantTable(base58Variants(item.base58))),
        DataCell(SelectableText(item.base62)),
        DataCell(_buildVariantTable(base64Variants(item.base64))),
      ],
    );
  }

  /// Builds a nested table for encoding variants.
  Widget _buildVariantTable(List<MapEntry<String, String>> variants) {
    return DataTable(
      headingRowHeight: 0,
      dividerThickness: 0,
      dataRowMinHeight: 28,
      dataRowMaxHeight: double.infinity,
      columnSpacing: 8,
      columns: const [
        DataColumn(label: SizedBox.shrink()),
        DataColumn(label: SizedBox.shrink()),
      ],
      rows: variants.map((entry) {
        return DataRow(
          cells: [
            DataCell(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            DataCell(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: SelectableText(
                  entry.value,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  /// Extracts Base32 encoding variants.
  List<MapEntry<String, String>> base32Variants(Base32Encoding base32) {
    return [
      MapEntry('hex', base32.hex),
      MapEntry('crockford', base32.crockford),
      MapEntry('rfc4648', base32.rfc4648),
      MapEntry('geohash', base32.geohash),
      MapEntry('zbase', base32.zbase),
      MapEntry('ncname', base32.ncname),
    ];
  }

  /// Extracts Base58 encoding variants.
  List<MapEntry<String, String>> base58Variants(Base58Encoding base58) {
    return [
      MapEntry('bitcoin', base58.bitcoin),
      MapEntry('ncname', base58.ncname),
    ];
  }

  /// Extracts Base64 encoding variants.
  List<MapEntry<String, String>> base64Variants(Base64Encoding base64) {
    return [
      MapEntry('standard', base64.standard),
      MapEntry('urlsafe', base64.urlSafe),
      MapEntry('ncname', base64.ncname),
      MapEntry('uuid', base64.uuid),
    ];
  }
}
