part of '../scene_lib.dart';

FloatingActionButton buildAddSceneFloatingButton(BuildContext context, updateScenes){
  return FloatingActionButton(
    onPressed: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          String name = '';
          String description = '';

          IoT_Device selectedDevice = IoT_Device(
            name: '',
            URL: '',
            credentials: '',
            id: 0,
            needSlider: false,
            value: 0,
            propertiesMap: {},
            roomId: 0,
          );
          late var buttonpressed = (selectedDevice.id == null || name == '' || description == '');
          return AlertDialog(
            title: const Text('New Scene'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    description = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                FutureBuilder<List<IoT_Device>>(
                  future: devices,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<IoT_Device> devices = snapshot.data!;
                      return DropdownButtonFormField<IoT_Device>(
                        decoration: const InputDecoration(
                          labelText: 'Select a device',
                          hintText: 'Choose a device',
                        ),
                        items: [
                          const DropdownMenuItem<IoT_Device>(
                            value: null,
                            child: Text('Choose a Main device'),
                          ),
                          ...devices.map((IoT_Device device) {
                            return DropdownMenuItem<IoT_Device>(
                              value: device,
                              child: Text(device.name!),
                            );
                          }),
                        ],
                        onChanged: (IoT_Device? select) {
                          // Handle selected device
                          if (select != null) {
                            selectedDevice = select;
                          }
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Text('Error loading devices');
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
            actions: <Widget>[
              buildButton('Cancel', (){Navigator.of(context).pop();}),
              buildButton('Save', () {
                if (buttonpressed) {
                  Navigator.of(context).pop();
                  return;
                }
                var action = (selectedDevice.value.runtimeType == bool)
                    ? "close"
                    : "turnOff";
                // Add logic to save the new scene with the provided name and description
                IoT_Scene.post_new_scene(
                  name,
                  description,
                  "[{\"conditions\":{\"operator\":\"all\",\"conditions\":[]},\"actions\":[{\"group\":\"device\",\"type\":\"single\",\"id\":${selectedDevice.id},\"action\":\"$action\",\"args\":[]}]}]",
                  'scene',
                  auth!,
                  VarHeader.BASEURL,
                ).then((response) {
                  updateScenes();
                });
                Navigator.of(context).pop();
              }),
            ],
          );
        },
      );
    },
    child: const Icon(Icons.add),
  );
}

ElevatedButton buildButton(String text, Function onPressed) {
  return ElevatedButton(
    onPressed: () {
      onPressed();
    },
    child: Text(text),
  );
}
