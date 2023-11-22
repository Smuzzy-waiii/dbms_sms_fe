import 'dart:async';

import 'package:dbms_sms_fe/api_helper.dart';
import 'package:flutter/material.dart';

class MonitorSensor extends StatefulWidget {
  int user_id;
  int sensor_id;
  String sensor_unit;
  String sensor_name;
  MonitorSensor(
      {super.key,
      required this.user_id,
      required this.sensor_id,
      required this.sensor_unit,
      required this.sensor_name});

  @override
  State<MonitorSensor> createState() => _MonitorSensorState();
}

class Record {
  double sensorValue;
  DateTime timestamp;
  Record({required this.sensorValue, required this.timestamp});
}

class _MonitorSensorState extends State<MonitorSensor> {
  List<Record>? records;
  Timer? _timer;

  void getObservations() {
    int start_time =
        records != null ? records![-1].timestamp.millisecondsSinceEpoch : 0;
    APIHelper.getObservations(widget.user_id, widget.sensor_id, start_time)
        .then((value) {
      if (value["success"]) {
        setState(() {
          records = value["success"];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value['detail'].toString()),
        ));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getObservations();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      getObservations();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sensor_name),
      ),
      body: Column(),
    );
  }
}
