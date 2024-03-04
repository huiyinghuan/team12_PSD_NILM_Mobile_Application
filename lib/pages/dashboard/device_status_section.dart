part of 'dashboard_lib.dart';

Widget buildDeviceStatusSection(
    BuildContext context, Function onTap, Function handleLongPress) {
  final navigateTo =
      (Widget page) => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => page,
          ));

  return Container(
    color: Colors.grey[200],
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: FutureBuilder<List<IoT_Device>>(
      future: devices,
      builder:
          (BuildContext context, AsyncSnapshot<List<IoT_Device>> snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    '${snapshot.data!.where((device) => (checkDeviceValue(device) || device.value == true)).length} DEVICES ON',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4), // Add spacing between text and icon
                  Container(
                    child: IconButton(
                      icon: const Icon(Icons.add_circle_outline_outlined),
                      onPressed: () => {navigateTo(ListDevice())},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: snapshot.data!
                    .map((device) => IoT_Device_Tile(
                          device: device,
                          onTap: () => onTap(device),
                          onLongPress: device.needSlider!
                              ? () => handleLongPress(context, device)
                              : null,
                        ))
                    .toList(),
              ),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Text(
            'Failed to load devices',
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
          );
        }
      },
    ),
  );
}

// void adjustDeviceSlider(IoT_Device device, BuildContext context) {
//   final navigateTo =
//       (Widget page) => Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => page,
//           ));
//   navigateTo(ListDevice());
// }
