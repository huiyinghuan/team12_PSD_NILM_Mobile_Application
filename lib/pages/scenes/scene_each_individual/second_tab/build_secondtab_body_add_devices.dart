part of '../../scene_lib.dart';

ListTile Body_addDeviceRow(int index, BuildContext context, IoT_Scene scene, setState, List<bool> isAllowed_Scene_Actions) {
  var selectedDeviceInDropdown;
  late var isEmpty = false;
  return ListTile(
    tileColor: AppColors.primary5,
    title: const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Add New Device',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 8), // Add some spacing between the text and icon
        Icon(Icons.add_circle_rounded, color: AppColors.secondary5),
      ],
    ),
    onTap: () {
      // Show the prompt dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add New Device'),
            content: FutureBuilder<List<IoT_Device>>(
              future: devices,
              builder: (context, devicesSnapshot) {
                if (devicesSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (devicesSnapshot.hasError) {
                  return const Text('Error loading devices');
                } else {
                  return FutureBuilder<List<IoT_Device>>(
                    future: devices_in_scene,
                    builder: (context, sceneSnapshot) {
                      if (sceneSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      } else if (sceneSnapshot.hasError) {
                        return const Text('Error loading scene devices');
                      } else {
                        // Filter out devices that are already in scene
                        final List<IoT_Device> filteredDevices =
                            devicesSnapshot.data!
                                .where((device) => !sceneSnapshot.data!.any(
                                    (sceneDevice) =>
                                        sceneDevice.id == device.id))
                                .toList();

                        if (filteredDevices.isEmpty) {
                          isEmpty = true;
                          return const Center(
                            heightFactor: 3,
                            child: Text(
                              'No devices left to add',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        }

                        return DropdownButtonFormField<IoT_Device>(
                          hint: const Text('Select a device'),
                          items: filteredDevices.map((device) {
                            return DropdownMenuItem<IoT_Device>(
                              value: device,
                              child: Text(device.name!),
                            );
                          }).toList(),
                          onChanged: (IoT_Device? selectedDevice) {
                            // Handle selected device
                            selectedDeviceInDropdown = selectedDevice;
                          },
                        );
                      }
                    },
                  );
                }
              },
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      if (selectedDeviceInDropdown != null) {
                        // Add the selected device to the scene
                        Future<Response> changeResponse =
                            scene.add_devices_into_action(
                                selectedDeviceInDropdown);
                        changeResponse.then((value) {
                          if (value.statusCode == 204) {
                            updateScenes(setState);
                            Navigator.pop(context); // Close the dialog
                            isAllowed_Scene_Actions.add(false);
                            addSceneActionDevices(selectedDeviceInDropdown.id, setState);
                          }
                        });
                      } else {
                        Navigator.pop(context); // Close the dialog
                      }
                    });
                  },
                  child:
                      (isEmpty) ? const Text('Dismiss') : const Text('Add')),
            ],
          );
        },
      );
    },
  );
}
