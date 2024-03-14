part of '../../scene_lib.dart';

FutureBuilder<List<IoT_Device>> contentBodyDevices(List actions, IoT_Scene scene, setState, List<bool> isallowedSceneActions) {
  return FutureBuilder<List<IoT_Device>>(
    future:
        devicesInScene, // listing of all devicesInScene for that scene
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
              return bodyAllDeviceRow(actions, index, snapshot, context, scene, setState, isallowedSceneActions);
            } else {
              // Render the additional row
              return bodyAddDeviceRow(index, context, scene, setState, isallowedSceneActions);
            }
          },
        );
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Text(
          'Failed to load devicesInScene',
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
        );
      }
    },
  );
}
