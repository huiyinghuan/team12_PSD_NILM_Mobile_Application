part of 'dashboard_lib.dart';

Widget buildDeviceStatusSection(
    BuildContext context, Function onTap, Function handleLongPress) {
  navigateTo(Widget page) => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => page,
          ));

  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
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
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: displayDevicesOn(snapshot),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_outlined),
                    onPressed: () => {navigateTo(List_Device())},
                  ),
                ],
              ),
              Wrap(
                spacing: 0.0,
                runSpacing: 8.0,
                children: snapshot.data!
                    .map((device) => Padding(
                          padding: const EdgeInsets.only(left: 12.0, top: 12.0),
                          child: IoT_Device_Tile(
                            device: device,
                            onTap: () => onTap(device),
                            onLongPress: () =>
                                handleLongPress(context, device, onTap),
                          ),
                        ))
                    .toList(),
              ),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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

Text displayDevicesOn(AsyncSnapshot snapshot) {
  return Text(
    '${snapshot.data!.where((device) => (checkDeviceValue(device) || device.value == true)).length} DEVICES ON',
    style: GoogleFonts.poppins(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
  );
}
