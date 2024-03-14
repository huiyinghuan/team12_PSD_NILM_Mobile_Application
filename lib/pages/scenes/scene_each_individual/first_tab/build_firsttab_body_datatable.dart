// ignore_for_file: non_constant_identifier_names

part of '../../scene_lib.dart';

Future<List<DataRow>> Body_buildDataRows(List<String> tableAttributes, IoT_Scene scene, context, setState) async {
  List<DataRow> dataRows = [];

  for (int i = 0; i < tableAttributes.length; i++) {
    String data_cell = Body_buildDataCellContent(i, scene);
    dataRows.add(DataRow(cells: [
      DataCell(Text(tableAttributes[i])),
      DataCell(
        Text(
          data_cell,
          maxLines: 1,
        ),
        onTap: () async {
          changeDescriptionPromptBox(
              'Edit ${tableAttributes[i]}', data_cell, i, context, scene, setState);
        },
      )
    ]));
  }

  return dataRows;
}

String Body_buildDataCellContent(int columnIndex, IoT_Scene scene) {
  switch (columnIndex) {
    case 0:
      return scene.description!;
    case 1:
      return scene.type!;
    case 2:
      return scene.icon!;
    case 3:
      return scene.mode.toString();
    case 4:
      return scene.enable.toString();
    case 5:
      return DateFormat('HH:mm | dd/MM/yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(scene.created! * 1000),
      );
    case 6:
      return DateFormat('HH:mm | dd/MM/yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(scene.updated! * 1000),
      );
    case 7:
      return scene.content.toString();
    case 8:
      return scene.id.toString();
    default:
      return 'Unknown Column';
  }
}


// for data table edit data custom popup box
Future<void> changeDescriptionPromptBox(String title, String content, int i, BuildContext context, IoT_Scene scene, setState) async {
  String new_desc = '';
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: (i == 0)
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        child: Text('Original: \n$content'),
                      ),
                    ),
                  ),
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('To change:'),
                    ),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'New Description',
                    ),
                    onChanged: (value) {
                      new_desc = value;
                    },
                  ),
                ],
              )
            : Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Original: $content'),
                ),
              ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (i == 0) {
                Future<Response> changeResponse =
                    scene.changeDescription(new_desc);
                changeResponse.then((value) {
                  if (value.statusCode == 204) {
                    scene.description = new_desc;
                    updateScenes(setState);
                  }
                });
              }
              Navigator.of(context).pop();
            },
            child:
                (new_desc == '') ? const Text('OK') : const Text('Confirm'),
          ),
        ],
      );
    },
  );
}
