import 'dart:typed_data';
import 'dart:convert';

import 'package:b/b.dart';
import 'package:base32/base32.dart' as myb32;
import 'package:base32/encodings.dart' as myb32e;
import 'package:flutter/material.dart';
import 'package:uuid/parsing.dart';
import 'package:uuid/uuid.dart';

import 'uuid_formats_item.dart';

/// Displays a list of SampleItems.
class UUIDFormatList extends StatefulWidget {
  static const routeName = '/';
  const UUIDFormatList({super.key});

  @override
  _UUIDFormatListView createState() => _UUIDFormatListView();
}

class _UUIDFormatListView extends State<UUIDFormatList> {
  List<UUIDFormatsItem> items = [];
  String mode = "v7";
  String base32encoding = "crockford";
  bool lowercaseB32 = false;
  String b48Alphabet = "ABCDEFGHJKLMNOPQRSTVWXYZabcdefghijkmnopqrstvwxyz";
  String b52Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
  final ScrollController _scrollController = ScrollController();
  final ScrollController _hScrollController = ScrollController();

  _UUIDFormatListView() {
    // Sanity check base UUID based on https://github.com/uuid6/new-uuid-encoding-techniques-ietf-draft/blob/master/TRADEOFFS.md#summary-of-concerns-and-tradeoffs
    const uuidString = "f81d4fae-7dec-11d0-a765-00a0c91e6bf6";
    items.add(uuidToItem(uuidString));
  }

  Uint8List _serializeBigInt(BigInt bi) {
    Uint8List array = Uint8List((bi.bitLength / 8).ceil());
    for (int i = array.length - 1; i >= 0; i--) {
      array[i] = (bi >> (i * 8)).toUnsigned(8).toInt();
    }
    return array;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FloatingActionButton.extended(
                onPressed: add,
                label: const Text("Add"),
                icon: const Icon(Icons.add),
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  for (var i = 0; i < 10; i++) {
                    add();
                  }
                },
                label: const Text("Add 10"),
                icon: const Icon(Icons.add_to_queue),
              ),
              FloatingActionButton.extended(
                onPressed: clear,
                label: const Text("Clear"),
                icon: const Icon(Icons.clear_all),
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  _scrollController.animateTo(0,
                      duration: Durations.long4, curve: Curves.easeOut);
                },
                label: const Text("Top"),
                icon: const Icon(Icons.arrow_upward),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text('UUID Format Tester'),
          centerTitle: true,
        ),

        // To work with lists that may contain a large number of items, it’s best
        // to use the ListView.builder constructor.
        //
        // In contrast to the default ListView constructor, which requires
        // building all Widgets up front, the ListView.builder constructor lazily
        // builds Widgets as they’re scrolled into view.
        body: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownMenu(
                            label: const Text("UUID Version"),
                            dropdownMenuEntries: const [
                              DropdownMenuEntry(value: "v1", label: "v1"),
                              DropdownMenuEntry(value: "v4", label: "v4"),
                              DropdownMenuEntry(value: "v6", label: "v6"),
                              DropdownMenuEntry(value: "v7", label: "v7"),
                              DropdownMenuEntry(
                                  value: "v8", label: "v8 (custom)"),
                            ],
                            initialSelection: "v7",
                            onSelected: (String? value) {
                              setState(() {
                                mode = value!;
                              });
                            }),
                        // DropdownMenu(
                        //     label: const Text("Base32 Alphabet"),
                        //     dropdownMenuEntries: const [
                        //       DropdownMenuEntry(
                        //           value: "b32hex", label: "Base32 Hex"),
                        //       DropdownMenuEntry(
                        //           value: "crockford", label: "Crockford"),
                        //       DropdownMenuEntry(
                        //           value: "rfc4648", label: "RFC4648"),
                        //       DropdownMenuEntry(
                        //           value: "geohash", label: "Geohash"),
                        //       DropdownMenuEntry(value: "zbase", label: "zbase"),
                        //     ],
                        //     initialSelection: "crockford",
                        //     onSelected: (String? value) {
                        //       setState(() {
                        //         base32encoding = value!;
                        //       });
                        //     }),
                        Wrap(
                          direction: Axis.horizontal,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Checkbox(
                              value: lowercaseB32,
                              onChanged: (bool? value) {
                                setState(() {
                                  lowercaseB32 = value!;
                                });
                              },
                            ),
                            const Text("Lowercase Base32/Base36"),
                          ],
                        ),
                      ],
                    )),
                Scrollbar(
                    controller: _hScrollController,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _hScrollController,
                        child: DataTable(
                          dataRowMaxHeight: double.infinity,
                          columns: const [
                            DataColumn(label: SelectableText('UUID')),
                            DataColumn(label: SelectableText('base32')),
                            DataColumn(label: SelectableText('base36')),
                            DataColumn(label: SelectableText('base48')),
                            DataColumn(label: SelectableText('base52')),
                            DataColumn(label: SelectableText('base58')),
                            DataColumn(label: SelectableText('base62')),
                            DataColumn(label: SelectableText('base64')),
                          ],
                          rows: items
                              .map((item) => DataRow(cells: [
                                    DataCell(SelectableText(item.uuid)),
                                    //DataCell(SelectableText(item.b32.toString())),
                                    DataCell(DataTable(
                                      headingRowHeight: 0.0,
                                      dividerThickness: 0.0,
                                      columns: const [
                                        DataColumn(label: Text("variant")),
                                        DataColumn(label: Text("hash"))
                                      ],
                                      rows: [
                                        DataRow(cells: [
                                          const DataCell(Text("hex")),
                                          DataCell(
                                              SelectableText(item.b32.b32hex))
                                        ]),
                                        DataRow(cells: [
                                          const DataCell(Text("crockford")),
                                          DataCell(SelectableText(
                                              item.b32.crockford))
                                        ]),
                                        DataRow(cells: [
                                          const DataCell(Text("rfc4648")),
                                          DataCell(
                                              SelectableText(item.b32.rfc4648))
                                        ]),
                                        DataRow(cells: [
                                          const DataCell(Text("geohash")),
                                          DataCell(
                                              SelectableText(item.b32.geohash))
                                        ]),
                                        DataRow(cells: [
                                          const DataCell(Text("zbase")),
                                          DataCell(
                                              SelectableText(item.b32.zbase))
                                        ]),
                                      ],
                                    )),
                                    DataCell(SelectableText(item.b36)),
                                    DataCell(SelectableText(item.b48)),
                                    DataCell(SelectableText(item.b52)),
                                    DataCell(SelectableText(item.b58)),
                                    DataCell(SelectableText(item.b62)),
                                    //DataCell(SelectableText(item.b64.toString())),
                                    DataCell(DataTable(
                                      headingRowHeight: 0,
                                      dividerThickness: 0,
                                      columns: const [
                                        DataColumn(label: Text("variant")),
                                        DataColumn(label: Text("hash"))
                                      ],
                                      rows: [
                                        DataRow(cells: [
                                          const DataCell(Text("standard")),
                                          DataCell(
                                              SelectableText(item.b64.base64))
                                        ]),
                                        DataRow(cells: [
                                          const DataCell(Text("urlsafe")),
                                          DataCell(SelectableText(
                                              item.b64.base64url))
                                        ]),
                                      ],
                                    )),
                                  ]))
                              .toList(),
                        ))),
              ],
            )));
  }

  add() {
    // Add a new SampleItem to the list when the user taps the button.
    const uuid = Uuid();
    String versionedUUID = "";
    switch (mode) {
      case "v4":
        versionedUUID = uuid.v4();
        break;
      case "v1":
        versionedUUID = uuid.v1();
        break;
      case "v6":
        versionedUUID = uuid.v6();
        break;
      case "v8":
        versionedUUID = uuid.v8();
        break;
      default:
        versionedUUID = uuid.v7();
        break;
    }

    final item = uuidToItem(versionedUUID);

    items.add(item);

    // Notify the framework that the internal state of this object has
    // changed.
    setState(() {});
  }

  UUIDFormatsItem uuidToItem(String uuidString) {
    final uuidStringNoDashes = uuidString.replaceAll("-", "");
    final uuid = UuidParsing.parseAsByteList(uuidString);

    final b32c = myb32.base32.encode(uuid, encoding: myb32e.Encoding.crockford);
    final b32h = myb32.base32.encode(uuid, encoding: myb32e.Encoding.base32Hex);
    final b32r =
        myb32.base32.encode(uuid, encoding: myb32e.Encoding.standardRFC4648);
    final b32g = myb32.base32.encode(uuid, encoding: myb32e.Encoding.geohash);
    final b32z = myb32.base32.encode(uuid, encoding: myb32e.Encoding.zbase32);
    final b36 = BaseConversion(from: base16.toLowerCase(), to: base36)(
        uuidStringNoDashes);
    final b48 = BaseConversion(from: base16.toLowerCase(), to: b48Alphabet)(
        uuidStringNoDashes);
    final b52 = BaseConversion(from: base16.toLowerCase(), to: b52Alphabet)(
        uuidStringNoDashes);
    final b58 = BaseConversion(from: base16.toLowerCase(), to: base58)(
        uuidStringNoDashes);
    final b62 = BaseConversion(from: base16.toLowerCase(), to: base62)(
        uuidStringNoDashes);
    final b64 = const Base64Codec().encode(uuid);
    final b64url = const Base64Codec.urlSafe().encode(uuid);

    if (lowercaseB32) {
      return UUIDFormatsItem(
          uuidString,
          Base32Set(b32h.toLowerCase(), b32c.toLowerCase(), b32r.toLowerCase(),
              b32g.toLowerCase(), b32z.toLowerCase(), "".toLowerCase()),
          b36.toLowerCase(),
          b48,
          b52,
          b58,
          b62,
          Base64Set(b64, b64url, ""));
    }

    return UUIDFormatsItem(
        uuidString,
        Base32Set(b32h, b32c, b32r, b32g, b32z, ""),
        b36,
        b48,
        b52,
        b58,
        b62,
        Base64Set(b64, b64url, ""));
  }

  clear() {
    setState(() {
      items = [];
    });
  }
}
