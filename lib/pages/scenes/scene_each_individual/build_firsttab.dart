part of '../scene_lib.dart';

SingleChildScrollView buildFirstTab(BuildContext context, IoT_Scene scene, setState, List<String> tableAttributes) {
  return SingleChildScrollView(
    child: Padding(
      // make scrollable below.
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: Column(
        // column got 2 children. 1 top row and 1 bottom datatable
        children: [
          contentTopRow(context, scene, setState),
          Center(child: contentBody(tableAttributes, scene, setState, context)),
        ],
      ),
    ),
  );
}