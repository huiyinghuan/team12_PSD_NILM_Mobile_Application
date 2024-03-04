part of "list_device_lib.dart";

// Assuming that devices is a List<IoT_Device>
List<ExpansionTile> buildExpansionTiles(
    List<dynamic> devices, BuildContext context, Function onTap) {
  return devices.map((device) {
    print(device.propertiesMap);
    String descriptionDevice = device.propertiesMap["userDescription"];
    if (descriptionDevice == "") {
      descriptionDevice = "No description given";
    }
    List<dynamic> categoriesDevice = device.propertiesMap["categories"];
    dynamic valueDevice = device.propertiesMap["value"];
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
    String categoriesString = categoriesDevice
        .join(", "); // Convert list to a single string separated by commas

    return ExpansionTile(
      title: Text(
        device.name, // Replace with your desired title text
        style: TextStyle(fontSize: 18.0), // Customize title text size
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0), // Adjust padding as needed
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
                        // style: TextStyle(
                        //   color: Colors.black,
                        //   fontSize: 14.0,
                        // ),
                      ),
                      TextSpan(
                        text: descriptionDevice + '\n\n',
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
              Align(
                alignment: Alignment.bottomRight,
                child: Switch(
                  // This bool value toggles the switch.
                  value: (valueDevice == 'Off' || valueDevice == 'Unlocked')
                      ? false
                      : true,
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.red,
                  onChanged: (bool value) {
                    onTap(device);
                  },
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditDevicePage(device: device)),
                  );
                },
                child: Text('Edit Device'),
              ),
            ],
          ),
        ),
      ],
    );
  }).toList();
}
