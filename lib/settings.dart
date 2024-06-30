// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:html' as html;

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nanoid/async.dart';

import 'services/items_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final itemsController = Get.put(ItemsController());
  dynamic myEncode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }

  Future<void> importData() async {
    debugPrint('importData');
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    PlatformFile? file = result?.files.single;
    // file should be json
    if (file != null && file.extension == 'json') {
      final String fileContent = utf8.decode(file.bytes!);
      final List data = json.decode(fileContent);
      debugPrint(data.toString());
      final isConfirmed = await confirm(
        context,
        title: const Text('🚨 Think twice!'),
        content: const Text(
          'Are you sure you want to import data?, this will overwrite your current data !.',
        ),
      );
      if (isConfirmed) {
        var box = await Hive.openBox('mainBox');
        await box.clear();
        for (var item in data) {
          if (item.containsKey('date') && item.containsKey('title')) {
            await box.add({
              'id': await nanoid(),
              'date': DateTime.parse(item['date']),
              'title': item['title'],
              'description': '',
              'type': item['type'] ?? 'good_habit',
            });
          }
        }
        await itemsController.getTheItems();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.purple[50],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            const Text(
              'Import the data from a JSON file, this will overwrite your current data.',
            ),
            Gap(5),
            SizedBox(
              child: ElevatedButton.icon(
                onPressed: () {
                  importData();
                },
                icon: const Icon(Icons.upload),
                label: const Text('Import Data'),
              ),
            ),
            Gap(15),
            const Text(
              'Export the data to a JSON file.',
            ),
            Gap(5),
            SizedBox(
              child: ElevatedButton.icon(
                onPressed: () async {
                  await itemsController.getTheItems();
                  var box = await Hive.openBox('mainBox');
                  final data = box.values.toList();
                  final String jsonData = json.encode(
                    data,
                    toEncodable: myEncode,
                  );
                  html.AnchorElement(
                    href:
                        "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(
                      utf8.encode(
                        jsonData,
                      ),
                    )}",
                  )
                    ..setAttribute("download", "last_did_data.json")
                    ..click();
                },
                icon: const Icon(Icons.download),
                label: const Text('Export Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
