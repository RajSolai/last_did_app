import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nanoid/async.dart';

class ItemsController extends GetxController {
  RxList items = [].obs;
  RxList actualItems = [].obs;

  Future<void> getTheItems() async {
    var box = await Hive.openBox('mainBox');
    final boxValues = box.values.toList();
    items.value = boxValues;
    actualItems.value = boxValues;
    // sort the boxes
    items.sort(
        (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    items.refresh();
  }

  void addNewItem(String title, DateTime date, String typeOfItem) async {
    var box = await Hive.openBox('mainBox');
    var boxId = await nanoid();
    var timeLineBox = await Hive.openBox('$boxId-timeline');
    await box.add({
      'id': boxId,
      'title': title,
      'description': '',
      'type': typeOfItem, // good or bad
      'date': date,
    });
    await timeLineBox.add({
      'title': 'Added $title',
      'date': DateTime.now().toLocal(),
      'type': 'just-added'
    });
    await getTheItems();
  }

  void deleteItem(String id) async {
    var box = await Hive.openBox('mainBox');
    final boxValues = box.values.toList();
    final newList = boxValues.where((element) => element['id'] != id).toList();
    await box.clear();
    for (var item in newList) {
      await box.add(item);
    }
    await getTheItems();
  }

  void updateItemAsDoneToday(BuildContext context, String id) async {
    var box = await Hive.openBox('mainBox');
    var timeLineBox = await Hive.openBox('$id-timeline');
    DateTime previousDate = DateTime.now().toLocal();
    final boxValues = box.values.toList();
    final newList = boxValues.map((e) {
      if (e['id'] == id) {
        previousDate = e['date'];
        return {
          'id': e['id'],
          'title': e['title'],
          'description': e['description'],
          'type': e['type'],
          'date': DateTime.now(),
        };
      } else {
        return e;
      }
    }).toList();
    await timeLineBox.add({
      'title': 'Habit updated as Done',
      'date': DateTime.now().toLocal(),
      'type': 'habit-did',
      'current-date': DateTime.now().toLocal(),
      'previous-date': previousDate
    });
    await box.clear();
    for (var item in newList) {
      await box.add(item);
    }
    await getTheItems();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Updated! 🎉'),
      ),
    );
  }

  Future<void> editItem(
    String id,
    String title,
    String desc,
    String type,
    DateTime date,
  ) async {
    var box = await Hive.openBox('mainBox');
    var timeLineBox = await Hive.openBox('$id-timeline');
    final boxValues = box.values.toList();
    final actualIndex = boxValues.indexWhere((element) => element['id'] == id);
    final previousData = boxValues[actualIndex];
    await box.putAt(actualIndex, {
      'id': id,
      'title': title,
      'description': desc,
      'date': date,
      'type': type,
    });
    await timeLineBox.add({
      'title': 'Habit updated as Done',
      'date': DateTime.now().toLocal(),
      'type': 'habit-edit',
      'current-date': date,
      'previous-date': previousData?['date']
    });
    await getTheItems();
  }
}
