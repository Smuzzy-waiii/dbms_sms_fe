import 'package:dbms_sms_fe/api_helper.dart';
import 'package:dbms_sms_fe/main.dart';
import 'package:flutter/material.dart';

import 'monitor_sensor.dart';

class HomeScreen extends StatefulWidget {
  int user_id;
  HomeScreen({super.key, required this.user_id});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> sensors = [];
  List<Map<String, dynamic>> makes = [];
  Map<String, dynamic> selectedMake = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    APIHelper.getSensors(widget.user_id).then((value) {
      if (value['success']) {
        setState(() {
          sensors = List<Map<String, dynamic>>.from(value['sensors']);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value['detail']),
        ));
      }
    });

    APIHelper.getMakes().then((value) {
      if (value['success']) {
        setState(() {
          makes = List<Map<String, dynamic>>.from(value['makes']);
          selectedMake = makes[0];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value['detail']),
        ));
        Navigator.of(context).pop();
      }
    });
  }

  AlertDialog getSensorDialog(context) => AlertDialog(
        title: Text('Create a Sensor'),
        content: Column(children: [
          Text(
            'Choose a make',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(
            height: 10,
          ),
          if (makes != [])
            DropdownButton(
              value: selectedMake,
              onChanged: (value) {
                setState(() {
                  selectedMake = value!;
                });
              },
              items: makes.map((e) {
                return DropdownMenuItem(
                  child: Text("${e['make_name']} (${e['sensor_unit']})"),
                  value: e,
                );
              }).toList(),
            ),
        ]),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel')),
          TextButton(
            child: Text('Create'),
            onPressed: () async {
              var resp = await APIHelper.createSensor(
                widget.user_id,
                selectedMake["make_id"],
              );
              if (!resp["success"]) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(resp['detail']),
                ));
              } else {
                APIHelper.getSensors(widget.user_id).then((value) {
                  if (value['success']) {
                    setState(() {
                      sensors =
                          List<Map<String, dynamic>>.from(value['sensors']);
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(value['detail']),
                    ));
                  }
                });
              }
              Navigator.of(context).pop();
            },
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Monitor'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case "Create a Sensor":
                  showDialog(
                      context: context,
                      builder: (_) => getSensorDialog(context));
                  break;
                case "Logout":
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Landing()));
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Create a Sensor', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: sensors == []
          ? CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: ListView(children: [
                Text(
                  "Pick a sensor to monitor",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Divider(
                  thickness: 1,
                ),
                for (var sensor in sensors)
                  Column(
                    children: [
                      ListTile(
                        title: Text(sensor['make_name'] +
                            "-" +
                            sensor['sensor_id'].toString()),
                        subtitle: Text(sensor['sensor_unit']),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MonitorSensor(
                                    user_id: widget.user_id,
                                    sensor_id: sensor['sensor_id'],
                                    sensor_unit: sensor['sensor_unit'],
                                    sensor_name: sensor['make_name'] +
                                        "-" +
                                        sensor['sensor_id'].toString(),
                                  )));
                        },
                      ),
                      Divider(
                        thickness: 1,
                      )
                    ],
                  ),
              ]),
            ),
    );
  }
}
