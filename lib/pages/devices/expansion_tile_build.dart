part of "list_device_lib.dart";

// Function to build a list of device cards with ExpansionTiles
List<Card> buildExpansionTiles(
    List<dynamic> devices, BuildContext context, Function onTap) {
  return devices.map((device) {
    String descriptionDevice =
        device.propertiesMap["userDescription"] ?? "No description given";
    List<dynamic> categoriesDevice = device.propertiesMap["categories"];
    dynamic valueDevice = device.propertiesMap["value"];

    // Conversion logic for different device types
    if (categoriesDevice.contains("blinds")) {
      valueDevice = 'Open ${valueDevice.toString()}%';
    } else if (categoriesDevice.contains("security")) {
      valueDevice = valueDevice ? 'Locked' : 'Unlocked';
    } else {
      valueDevice = (valueDevice == 99 || valueDevice == true) ? 'On' : 'Off';
    }
    String categoriesString = categoriesDevice.join(", ");

    return Card(
      elevation: 0,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
            color: AppColors.primary2, width: 2), // Add orange outline
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ExpansionTile(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 20, 5),
                child: Image(
                  image: AssetImage( getImagePath(device)),
                  width: 52.10625,
                  height: 53.12625,
                ),
              ),
              Text(
                device.name,
                style: GoogleFonts.poppins(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Device details
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                          fontSize: 16.0, color: Colors.black),
                      children: [
                        TextSpan(
                            text: 'Status: ',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary2)),
                        TextSpan(
                          text: '$valueDevice\n\n',
                          style: GoogleFonts.poppins(
                              color: (valueDevice == 'Off' ||
                                      valueDevice == 'Unlocked')
                                  ? Colors.red
                                  : Colors.green),
                        ),
                        TextSpan(
                            text: 'Description: ',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary2)),
                        TextSpan(text: '$descriptionDevice\n\n'),
                        TextSpan(
                            text: 'Category: ',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary2)),
                        TextSpan(text: categoriesString),
                      ],
                    ),
                  ),
                  SizedBox(height: 10), // Space between details and controls
                  // Controls at the bottom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditDevicePage(
                                      device: device,
                                      onTap: onTap,
                                    )),
                          );
                        },
                        child: Text('Edit Device'),
                        style: ElevatedButton.styleFrom(
                            // primary: AppColors.secondary2, // Button color
                            // onPrimary: Colors.white, // Text color
                            ),
                      ),
                      Switch(
                        value:
                            (valueDevice == 'Off' || valueDevice == 'Unlocked')
                                ? false
                                : true,
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.red,
                        onChanged: (bool value) {
                          onTap(device);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }).toList();
}

String getImagePath(IoT_Device device) {
    bool? isSwitchedOn;
    if (device.needSlider!) {
      isSwitchedOn = device.value > 0 ? true : false;
    } else {
      isSwitchedOn = device.value;
    }

    if (device.propertiesMap != null &&
        device.propertiesMap?['deviceRole'] == 'Light') {
      return isSwitchedOn!
          ? 'images/icons/light100.png'
          : 'images/icons/light0.png';
    } else if (device.propertiesMap != null &&
        device.propertiesMap?['deviceRole'] == 'BlindsWithPositioning') {
      return isSwitchedOn!
          ? 'images/icons/drzwi100.png'
          : 'images/icons/drzwi0.png';
    } else if (device.propertiesMap != null &&
        device.propertiesMap?['deviceRole'] == 'OpeningSensor') {
      return isSwitchedOn!
          ? 'images/icons/roleta_wew100.png'
          : 'images/icons/roleta_wew0.png';
    } else if (device.propertiesMap != null &&
        device.propertiesMap?['deviceRole'] == 'Other') {
      return 'images/icons/czujnik_ruchu0.png';
    } else {
      // If there is no deviceRole, return the default image
      return 'images/l3homeation.png';
    }
  }
