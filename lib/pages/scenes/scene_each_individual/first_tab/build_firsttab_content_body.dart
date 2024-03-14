part of '../../scene_lib.dart';

SingleChildScrollView contentBody(List<String> tableAttributes, IoT_Scene scene, setState, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        // padding for the datatable
        padding: const EdgeInsets.only(top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<List<DataRow>>(
              future: Body_buildDataRows(tableAttributes, scene, context, setState),
              builder: (BuildContext context,
                  AsyncSnapshot<List<DataRow>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return DataTable(
                    horizontalMargin: 20,
                    columns: const [
                      DataColumn(label: Text('')),
                      DataColumn(
                        label: Row(
                          children: [
                            Text('Data Information'),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Icon(Icons.edit),
                            )
                          ],
                        ),
                      )
                    ],
                    rows: snapshot.data!,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }