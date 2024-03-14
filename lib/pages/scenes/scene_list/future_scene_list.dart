part of '../scene_lib.dart';

// a container that holds the list of scenes
ListView buildFutureSceneList(navigateTo, sceneOnOff) {
  return ListView(
      children: <Widget>[
        Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: FutureBuilder<List<IoT_Scene>>(
          future: scenes,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: [
                      ...buildEachRow(context, snapshot.data!, navigateTo, sceneOnOff),
                      const SizedBox(height: 100), // Add a margin spacer
                    ],
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFD36E2F),
              ),
            );
          },
        ),
      )
    ],
  );
}

// Assuming that scenes is a List<IoT_Scene>
Iterable<Card> buildEachRow(BuildContext context, List<IoT_Scene> scenes, navigateTo, sceneOnOff) {
  return scenes.map((scene) {
    bool enableScene = scene.enable;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
            color: AppColors.primary2, width: 2), // Add orange outline
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: ExpansionTile(
            title: buildImageAndTitle(scene),
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 10, 0, 0), // Adjust padding as needed
                    child: buildSceneInfo(scene, enableScene, navigateTo), // Replace with your desired row widget
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: buildButtonAndSwitch(context, scene, enableScene, navigateTo, sceneOnOff)
                  ),
                ],
              )
            ],
          )),
    );
  }).toList();
}
