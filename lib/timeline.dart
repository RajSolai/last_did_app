import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TimeLineOfTask extends StatefulWidget {
  final String taskId;
  const TimeLineOfTask({Key? key, required this.taskId}) : super(key: key);

  @override
  _TimeLineOfTaskState createState() => _TimeLineOfTaskState();
}

class _TimeLineOfTaskState extends State<TimeLineOfTask> {
  List timeline = [];

  @override
  void initState() {
    super.initState();
    loadTimeline();
  }

  void loadTimeline() async {
    var timeLineBox = await Hive.openBox('${widget.taskId}-timeline');
    final boxValues = timeLineBox.values.toList();
    timeline = boxValues;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: timeline.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(timeline[index]['title']),
            subtitle: Text(timeline[index]['date'].toString()),
          );
        },
      ),
    );
  }
}
