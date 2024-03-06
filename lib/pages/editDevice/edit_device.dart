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
  bool isSwitchedOn = false;
  bool isInteger = false;
  double intensity = 0.35; // Assuming 35% is the initial value from the image
  String currentRole = '';

  String getImagePath() {
    if (widget.device.propertiesMap != null &&
        widget.device.propertiesMap?['deviceRole'] == 'Light') {
      return isSwitchedOn
          ? 'images/icons/light100.png'
          : 'images/icons/light0.png';
    } else if (widget.device.propertiesMap != null &&
        widget.device.propertiesMap?['deviceRole'] == 'BlindsWithPositioning') {
      return isSwitchedOn
          ? 'images/icons/drzwi100.png'
          : 'images/icons/drzwi0.png';
    } else if (widget.device.propertiesMap != null &&
        widget.device.propertiesMap?['deviceRole'] == 'OpeningSensor') {
      return isSwitchedOn
          ? 'images/icons/roleta_wew100.png'
          : 'images/icons/roleta_wew0.png';
    } else if (widget.device.propertiesMap != null &&
        widget.device.propertiesMap?['deviceRole'] == 'Other') {
      return 'images/icons/czujnik_ruchu0.png';
    } else {
      // If there is no deviceRole, return the default image
      return 'images/l3homeation.png';
    }
  }

  bool setSystemValue(IoT_Device device) {
    dynamic value = device.propertiesMap?["value"];
    if (value is int) {
      intensity = value / 100;
      isInteger = true;
    }
    if (value == 99 || value == true) {
      isSwitchedOn = true;
      return true;
    } else if (value == 0 || value == false) {
      isSwitchedOn = false;
      return false;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.device.propertiesMap);
    setSystemValue(widget.device);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Edit Device', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // Use SingleChildScrollView to avoid overflow
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.device.name!,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24), // For spacing

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text('Power:', style: TextStyle(fontSize: 16.0)),
                  ),
                  Radio<bool>(
                    value: true,
                    groupValue: isSwitchedOn,
                    onChanged: (bool? value) async {
                      await widget.onTap(widget.device, () {
                        // This is the callback function
                        setState(() {
                          // Assuming the device instance's value is now updated
                          isSwitchedOn = setSystemValue(widget.device);
                          print("Current state is $isSwitchedOn");
                        });
                      });
                    },
                  ),
                  Text('On'),
                  Radio<bool>(
                    value: false,
                    groupValue: isSwitchedOn,
                    onChanged: (bool? value) async {
                      await widget.onTap(widget.device, () {
                        // This is the callback function
                        setState(() {
                          // Assuming the device instance's value is now updated
                          isSwitchedOn = setSystemValue(widget.device);
                          print("Current state is $isSwitchedOn");
                        });
                      });
                    },
                  ),
                  Text('Off'),
                  Expanded(
                    flex: 2,
                    child: Image.asset(
                      getImagePath(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: isInteger,
                child: Column(
                  children: [
                    Slider(
                      value: intensity,
                      min: 0,
                      max: 1,
                      divisions: 100,
                      onChanged: (double value) {
                        setState(() {
                          intensity = value;
                        });
                      },
                    ),
                    Center(
                      child: Text(
                        '${(intensity * 100).round()}%',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),

              // SizedBox(height: 24), // For spacing before the Save button
              // SizedBox(
              //   width:
              //       double.infinity, // Makes the button stretch to full width
              //   child: ElevatedButton(
              //     onPressed: () {
              //       widget.onTap();
              //     },
              //     child: Text('Save Edit'),
              //     style: ElevatedButton.styleFrom(
              //       // primary: Theme.of(context).accentColor, // Use the accent color from the theme
              //       padding: EdgeInsets.symmetric(
              //           vertical: 12.0), // Add padding for a taller button
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
