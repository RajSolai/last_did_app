import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

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
    timeline = boxValues.reversed.toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timeline'),
      ),
      body: Timeline.tileBuilder(
        builder: TimelineTileBuilder.connected(
          contentsAlign: ContentsAlign.basic,
          contentsBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(timeline[index]['title']),
                Gap(5),
                Chip(
                  color: WidgetStatePropertyAll(Colors.green),
                  side: BorderSide(color: Colors.green),
                  label: Text(
                    DateFormat('dd-MM-yyyy hh:mm a').format(
                      timeline[index]['date'].toLocal(),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          indicatorBuilder: (context, index) => OutlinedDotIndicator(
            size: 30,
            color: Colors.green,
            backgroundColor: Colors.green,
            child: Icon(Icons.check, color: Colors.white),
          ),
          connectorBuilder: (context, index, type) => SolidLineConnector(
            color: Colors.green,
          ),
          itemCount: timeline.length,
        ),
      ),
    );
  }
}
