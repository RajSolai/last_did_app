import 'dart:html';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:last_did_app/settings.dart';
import 'package:last_did_app/timeline.dart';

import 'services/items_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String newItemTitle = '';
  String newItemDescription = '';
  bool isEditMode = false;
  bool isDeleteMode = false;

  final itemsController = Get.put(ItemsController());

  DateTime newItemDate = DateTime.now();
  TextEditingController editTitle = TextEditingController();
  TextEditingController editDescription = TextEditingController();
  String typeOfItem = 'good_habit';

  Future<void> showEditDialog(String id) async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit item'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  controller: editTitle,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                // const Gap(10),
                // TextField(
                //   decoration: const InputDecoration(
                //     labelText: 'Description',
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(10)),
                //     ),
                //   ),
                //   controller: editDescription,
                //   onChanged: (value) {
                //     setState(() {});
                //   },
                // ),
                const Gap(10),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                    items: const [
                      DropdownMenuItem(
                        value: 'good_habit',
                        child: Text('Good habit'),
                      ),
                      DropdownMenuItem(
                        value: 'bad_habit',
                        child: Text('Bad habit'),
                      ),
                    ],
                    value: typeOfItem,
                    onChanged: (val) {
                      setState(() {
                        typeOfItem = val ?? 'good_habit';
                      });
                    },
                  ),
                ),
                const Gap(10),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.purple[100]),
                  ),
                  onPressed: () async {
                    var date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setState(() {
                        newItemDate = date;
                      });
                    }
                  },
                  child: Text(
                    'Last Did: ${DateFormat('dd-MM-yyyy').format(newItemDate)}',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red[100]),
                ),
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green[100]),
                ),
                onPressed: () async {
                  await itemsController.editItem(
                    id,
                    editTitle.text,
                    editDescription.text,
                    typeOfItem,
                    newItemDate,
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  int differenceInDays(DateTime date1, DateTime date2) {
    DateTime datePart1 = DateTime(date1.year, date1.month, date1.day);
    DateTime datePart2 = DateTime(date2.year, date2.month, date2.day);
    return datePart1.difference(datePart2).inDays;
  }

  void showNewItemDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              'Add a new item',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  onChanged: (value) {
                    newItemTitle = value;
                    setState(() {});
                  },
                ),
                const Gap(10),
                // TextField(
                //   decoration: const InputDecoration(
                //     labelText: 'Description',
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(10)),
                //     ),
                //   ),
                //   onChanged: (value) {
                //     newItemDescription = value;
                //     setState(() {});
                //   },
                // ),
                // const Gap(10),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                    items: const [
                      DropdownMenuItem(
                        value: 'good_habit',
                        child: Text('Good habit'),
                      ),
                      DropdownMenuItem(
                        value: 'bad_habit',
                        child: Text('Bad habit'),
                      ),
                    ],
                    value: typeOfItem,
                    onChanged: (val) {
                      setState(() {
                        typeOfItem = val ?? 'good_habit';
                      });
                    },
                  ),
                ),
                const Gap(10),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.purple[100]),
                  ),
                  onPressed: () async {
                    var date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setState(() {
                        newItemDate = date;
                      });
                    }
                  },
                  child: Text(
                    'Last Did: ${DateFormat('dd-MM-yyyy').format(newItemDate)}',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red[100]),
                ),
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green[100]),
                ),
                onPressed: () {
                  itemsController.addNewItem(
                    newItemTitle,
                    newItemDate,
                    typeOfItem,
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  void initState() {
    window.document
        .querySelector('meta[name="theme-color"]')
        ?.setAttribute('content', '#f3e5f5');
    super.initState();
    itemsController.getTheItems();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: showNewItemDialog,
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SettingsPage();
                  },
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
          title: const Text(
            'Last Did',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                isEditMode = !isEditMode;
                setState(() {});
                itemsController.getTheItems();
              },
              icon: Icon(
                isEditMode ? Icons.done : Icons.edit,
              ),
            ),
            IconButton(
              onPressed: () {
                isDeleteMode = !isDeleteMode;
                setState(() {});
                itemsController.getTheItems();
              },
              icon: Icon(
                isDeleteMode ? Icons.done : Icons.delete,
              ),
            ),
          ],
          backgroundColor: Colors.purple[50],
        ),
        body: Column(
          children: [
            const SizedBox(height: 5),
            Flexible(
              child: Obx(
                () => ListView.separated(
                  itemCount: itemsController.items.length,
                  padding: const EdgeInsets.all(0),
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 1,
                      color: Colors.purple[100],
                    );
                  },
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () async {
                        await Get.to(
                          TimeLineOfTask(
                            taskId: itemsController.items[index]?['id'],
                          ),
                        );
                      },
                      trailing: isEditMode
                          ? SizedBox(
                              child: IconButton(
                                padding: const EdgeInsets.all(10),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.grey[200]),
                                ),
                                icon: const Icon(
                                  Icons.edit,
                                ),
                                onPressed: () {
                                  final item = itemsController.items[index];
                                  newItemDate = item?['date'] ?? DateTime.now();
                                  editTitle.text = item?['title'] ?? '';
                                  editDescription.text =
                                      item?['description'] ?? '';
                                  typeOfItem = item?['type'] ?? 'good_habit';
                                  debugPrint("ID is ${item?['id']}");
                                  showEditDialog(item?['id'] ?? '');
                                },
                              ),
                            )
                          : (isDeleteMode
                              ? SizedBox(
                                  child: IconButton(
                                    padding: const EdgeInsets.all(10),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.grey[200]),
                                    ),
                                    icon: const Icon(
                                      Icons.delete_forever,
                                    ),
                                    onPressed: () async {
                                      // delete item
                                      final isConfirmed = await confirm(
                                        context,
                                        title: const Text('Are you sure?'),
                                        content: const Text(
                                            'Do you want to delete this item?'),
                                      );
                                      if (!isConfirmed) return;
                                      itemsController.deleteItem(
                                          itemsController.items[index]?['id']);
                                    },
                                  ),
                                )
                              : null),
                      onLongPress: () {
                        // vibrate phone using js
                        itemsController.updateItemAsDoneToday(
                          context,
                          itemsController.items[index]?['id'],
                        );
                      },
                      minVerticalPadding: 20,
                      leading: Container(
                        width: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 1),
                            AutoSizeText(
                              '${differenceInDays(DateTime.now(), itemsController.items[index]?['date'] ?? DateTime.now())}',
                              style: GoogleFonts.robotoCondensed(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AutoSizeText(
                              'days ago',
                              style: GoogleFonts.robotoCondensed(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      title: Text(
                        itemsController.items[index]?['title'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
