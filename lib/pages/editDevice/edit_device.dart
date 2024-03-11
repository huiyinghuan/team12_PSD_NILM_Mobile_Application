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
  bool? isSwitchedOn;
  int intensity = 100;
  String currentRole = '';

  @override
  void initState() {
    super.initState();
    if (widget.device.needSlider!) {
      isSwitchedOn = widget.device.value > 0 ? true : false;
    } else {
      isSwitchedOn = widget.device.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    // setSystemValue(widget.device);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Edit Device', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // Use SingleChildScrollView to avoid overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.device.name!,
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24), // For spacing

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Text('Power:', style: TextStyle(fontSize: 16.0)),
                  ),
                  Radio<bool>(
                    value: true,
                    groupValue: isSwitchedOn,
                    onChanged: (bool? value) {
                      setState(() {
                        isSwitchedOn = true;
                        if (!widget.device.needSlider!) {
                          widget.device.setToTrue();
                          widget.device.value = true;
                        } else {
                          widget.device.value = intensity;
                          widget.device.sendCurrentValue();
                        }
                      });
                    },
                  ),
                  const Text('On'),
                  Radio<bool>(
                    value: false,
                    groupValue: isSwitchedOn,
                    onChanged: (bool? value) {
                      setState(() {
                        isSwitchedOn = false;
                        if (!widget.device.needSlider!) {
                          widget.device.setToFalse();
                          widget.device.value = false;
                        } else {
                          //store the last turned on value
                          // set the api value to 0 and store the last turned on value
                          widget.device.setToZero();
                        }
                      });
                    },
                  ),
                  const Text('Off'),
                  Expanded(
                    flex: 2,
                    child: Image.asset(
                      getImagePath(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              if (widget.device.needSlider! == true)
                Container(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      sliderBar(),
                      Center(
                        child: Text(
                          'Intensity: ${(widget.device.value).round()}%',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                )
              else
                const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Slider sliderBar() {
    return Slider(
      value: ((double.parse(widget.device.value.toString())) / 100),
      min: 0.0,
      max: 1.0,
      divisions: 100,
      label: "${(widget.device.value).toInt()}",
      onChanged: (double newValue) {
        setState(() => widget.device.value = (newValue * 100).toInt());
        if (widget.device.value > 0) {
          isSwitchedOn = true;
          intensity = widget.device.value;
          widget.device.sendCurrentValue();
        } else {
          isSwitchedOn = false;
          widget.device.setToZero();
        }
      },
    );
  }

  String getImagePath() {
    if (widget.device.propertiesMap != null &&
        widget.device.propertiesMap?['deviceRole'] == 'Light') {
      return isSwitchedOn!
          ? 'images/icons/light100.png'
          : 'images/icons/light0.png';
    } else if (widget.device.propertiesMap != null &&
        widget.device.propertiesMap?['deviceRole'] == 'BlindsWithPositioning') {
      return isSwitchedOn!
          ? 'images/icons/drzwi100.png'
          : 'images/icons/drzwi0.png';
    } else if (widget.device.propertiesMap != null &&
        widget.device.propertiesMap?['deviceRole'] == 'OpeningSensor') {
      return isSwitchedOn!
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
}
