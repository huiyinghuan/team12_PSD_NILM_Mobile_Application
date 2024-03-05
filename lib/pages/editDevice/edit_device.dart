import 'package:flutter/material.dart';
import 'package:l3homeation/models/iot_device.dart';

class EditDevicePage extends StatefulWidget {
  final IoT_Device device;
  final Function onTap;

  const EditDevicePage({required this.device, required this.onTap});

  @override
  _EditDevicePageState createState() => _EditDevicePageState();
}

class _EditDevicePageState extends State<EditDevicePage> {
  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    String? descriptionDevice = widget.device.propertiesMap?["userDescription"];
    if (descriptionDevice == "") {
      descriptionDevice = "No description given";
    }
    List<dynamic> categoriesDevice = widget.device.propertiesMap?["categories"];
    dynamic valueDevice = widget.device.propertiesMap?["value"];
    print("Current device value: $valueDevice");
    if (categoriesDevice.contains("blinds")) {
      valueDevice = 'Open ' + valueDevice.toString() + '%';
    } else if (categoriesDevice.contains("security")) {
      if (valueDevice == false) {
        valueDevice = 'Unlocked';
      } else {
        valueDevice = 'Locked';
      }
    } else if (valueDevice == 99 || valueDevice == true) {
      valueDevice = 'On';
    } else if (valueDevice == 0 || valueDevice == false) {
      valueDevice = 'Off';
    } else {
      valueDevice = valueDevice.toString();
    }

    if (valueDevice == 'Off' || valueDevice == 'Unlocked') {
      switchValue = false;
    } else {
      switchValue = true;
    }

    String categoriesString = categoriesDevice.join(", ");

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.device.name}'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              widget.device.name.toString(),
              style: TextStyle(fontSize: 18.0),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        text: 'Status: ',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                        ),
                        children: [
                          TextSpan(
                            text: valueDevice.toString() + '\n\n',
                            style: TextStyle(
                                color: (valueDevice == 'Off' ||
                                        valueDevice == 'Unlocked')
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'Description Given: \n',
                          ),
                          TextSpan(
                            text: (descriptionDevice != null
                                    ? descriptionDevice
                                    : '') +
                                '\n\n',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: 'Category Chosen: '),
                          TextSpan(
                            text: categoriesString,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Add your Switch and ElevatedButton here
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Switch(
                  // This bool value toggles the switch.
                  value: switchValue,
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.red,
                  onChanged: (bool value) {
                    setState(() {
                      switchValue = value;
                    });
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
