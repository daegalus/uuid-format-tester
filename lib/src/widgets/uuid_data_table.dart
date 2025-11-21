/// Data table widget for displaying UUID encodings.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../localization/app_localizations.dart';
import '../models/uuid_encoding_result.dart';

/// Table displaying UUIDs and their various encodings.
class UuidDataTable extends StatefulWidget {
  const UuidDataTable({
    required this.items,
    super.key,
  });

  final List<UuidEncodingResult> items;

  @override
  State<UuidDataTable> createState() => _UuidDataTableState();
}

class _UuidDataTableState extends State<UuidDataTable> {
  bool _isListView = false;
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (widget.items.isEmpty) {
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
        // Use table or list layout for wide screens (desktop) with toggle
        return Column(
          children: [
            _buildViewToggle(),
            Expanded(
              child: _isListView
                  ? _buildListView(localizations)
                  : _buildTableLayout(localizations),
            ),
          ],
        );
      },
    );
  }

  /// Builds the toggle button to switch between table and list views.
  Widget _buildViewToggle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('View: '),
          const SizedBox(width: 8),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: false,
                label: Text('Table'),
                icon: Icon(Icons.table_chart),
              ),
              ButtonSegment(
                value: true,
                label: Text('List'),
                icon: Icon(Icons.list),
              ),
            ],
            selected: {_isListView},
            emptySelectionAllowed: false,
            onSelectionChanged: (Set<bool> selected) {
              if (selected.isNotEmpty) {
                setState(() {
                  _isListView = selected.first;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  /// Builds a list view showing encodings in a flat table structure.
  Widget _buildListView(AppLocalizations localizations) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Add column headers once at the top
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 0,
              dataRowMaxHeight: 0,
              columnSpacing: 16,
              columns: const [
                DataColumn(
                    label: Text('UUID',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Encoding',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Variant',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Output',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: const [],
            ),
          ),
          const SizedBox(height: 8),
          // UUID groups
          ...widget.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isEven = index % 2 == 0;

            // Build rows for this UUID
            final rows = <_EncodingRow>[];

            // Add Base32 variants
            for (final variant in base32Variants(item.base32)) {
              rows.add(_EncodingRow(
                uuid: item.uuid,
                encoding: localizations.base32,
                variant: variant.key,
                output: variant.value,
              ));
            }

            // Add Base36
            rows.add(_EncodingRow(
              uuid: item.uuid,
              encoding: localizations.base36,
              variant: '-',
              output: item.base36,
            ));

            // Add Base48
            rows.add(_EncodingRow(
              uuid: item.uuid,
              encoding: localizations.base48,
              variant: '-',
              output: item.base48,
            ));

            // Add Base52
            rows.add(_EncodingRow(
              uuid: item.uuid,
              encoding: localizations.base52,
              variant: '-',
              output: item.base52,
            ));

            // Add Base58 variants
            for (final variant in base58Variants(item.base58)) {
              rows.add(_EncodingRow(
                uuid: item.uuid,
                encoding: localizations.base58,
                variant: variant.key,
                output: variant.value,
              ));
            }

            // Add Base62
            rows.add(_EncodingRow(
              uuid: item.uuid,
              encoding: localizations.base62,
              variant: '-',
              output: item.base62,
            ));

            // Add Base64 variants
            for (final variant in base64Variants(item.base64)) {
              rows.add(_EncodingRow(
                uuid: item.uuid,
                encoding: localizations.base64,
                variant: variant.key,
                output: variant.value,
              ));
            }

            // Add Base85 variants
            for (final variant in base85Variants(item.base85)) {
              rows.add(_EncodingRow(
                uuid: item.uuid,
                encoding: localizations.base85,
                variant: variant.key,
                output: variant.value,
              ));
            }

            // Return a container for this UUID's encodings
            return Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              decoration: BoxDecoration(
                color: isEven
                    ? Theme.of(context).colorScheme.secondaryContainer
                    : Theme.of(context).colorScheme.surface,
                border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: 0,
                  dataRowMinHeight: 36,
                  dataRowMaxHeight: 60,
                  columnSpacing: 16,
                  columns: const [
                    DataColumn(label: SizedBox.shrink()),
                    DataColumn(label: SizedBox.shrink()),
                    DataColumn(label: SizedBox.shrink()),
                    DataColumn(label: SizedBox.shrink()),
                  ],
                  rows: rows.map((row) {
                    return DataRow(
                      cells: [
                        DataCell(SelectableText(
                          row.uuid,
                          style: GoogleFonts.robotoMono(
                            fontSize: 12,
                          ),
                        )),
                        DataCell(Text(
                          row.encoding,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                        DataCell(Text(
                          row.variant,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        )),
                        DataCell(SelectableText(
                          row.output,
                          style: GoogleFonts.robotoMono(
                            fontSize: 12,
                          ),
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Builds a card-based layout for mobile devices.
  Widget _buildCardLayout(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: ExpansionTile(
            title: SelectableText(
              item.uuid,
              style: GoogleFonts.robotoMono(
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
                    const Divider(),
                    _buildEncodingSection(localizations.base85, null,
                        base85Variants(item.base85)),
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
                        style: GoogleFonts.robotoMono(
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
              style: GoogleFonts.robotoMono(
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
    return Scrollbar(
      controller: _horizontalController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _horizontalController,
        scrollDirection: Axis.horizontal,
        child: Scrollbar(
          controller: _verticalController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _verticalController,
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
                DataColumn(
                    label: Text(localizations.base85,
                        style: const TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: widget.items.map((item) => _buildDataRow(item)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a data row for a single UUID encoding result.
  DataRow _buildDataRow(UuidEncodingResult item) {
    final monoStyle = GoogleFonts.robotoMono(
      fontSize: 13,
    );

    return DataRow(
      cells: [
        DataCell(SelectableText(item.uuid, style: monoStyle, maxLines: 1)),
        DataCell(_buildVariantTable(base32Variants(item.base32))),
        DataCell(SelectableText(item.base36, style: monoStyle, maxLines: 1)),
        DataCell(SelectableText(item.base48, style: monoStyle, maxLines: 1)),
        DataCell(SelectableText(item.base52, style: monoStyle, maxLines: 1)),
        DataCell(_buildVariantTable(base58Variants(item.base58))),
        DataCell(SelectableText(item.base62, style: monoStyle, maxLines: 1)),
        DataCell(_buildVariantTable(base64Variants(item.base64))),
        DataCell(_buildVariantTable(base85Variants(item.base85))),
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
                  style: GoogleFonts.robotoMono(
                    fontSize: 13,
                  ),
                  maxLines: 1,
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

  /// Extracts Base85 encoding variants.
  List<MapEntry<String, String>> base85Variants(Base85Encoding base85) {
    return [
      MapEntry('ascii85', base85.ascii85),
      MapEntry('z85', base85.z85),
      MapEntry('custom', base85.custom),
    ];
  }
}

/// Helper class to represent a row in the list view.
class _EncodingRow {
  const _EncodingRow({
    required this.uuid,
    required this.encoding,
    required this.variant,
    required this.output,
  });

  final String uuid;
  final String encoding;
  final String variant;
  final String output;
}
