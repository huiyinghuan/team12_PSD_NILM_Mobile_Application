part of '../../scene_lib.dart';

FutureBuilder<List<IoT_Device>> contentBodyDevices(List actions, IoT_Scene scene, setState, List<bool> isAllowed_Scene_Actions) {
  return FutureBuilder<List<IoT_Device>>(
    future:
        devices_in_scene, // listing of all devices_in_scene for that scene
    builder:
        (BuildContext context, AsyncSnapshot<List<IoT_Device>> snapshot) {
      if (snapshot.hasData) {
        // If the Future has completed successfully, build the ListView.
        // List<IoT_Device> deviceList = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount:
              snapshot.data!.length + 1, // Add 1 for the additional row
          itemBuilder: (BuildContext context, int index) {
            if (index != snapshot.data!.length) {
              return Body_allDeviceRow(actions, index, snapshot, context, scene, setState, isAllowed_Scene_Actions);
            } else {
              // Render the additional row
              return Body_addDeviceRow(index, context, scene, setState, isAllowed_Scene_Actions);
            }
          },
        );
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Text(
          'Failed to load devices_in_scene',
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
        );
      }
    },
  );
}
