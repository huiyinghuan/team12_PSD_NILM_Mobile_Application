part of 'dashboard_lib.dart';

Widget buildSceneSection(BuildContext context, Function onTap) {
  return FutureBuilder<List<IoT_Scene>>(
    future: allScenes,
    builder: (context, snapshot) {
      if (snapshot.hasData &&
          snapshot.connectionState == ConnectionState.done) {
        return Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align children to the start
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14.0, top: 12.0),
              child: Text(
                'Scenes',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Wrap(
              spacing: 0.0,
              runSpacing: 8.0,
              children: snapshot.data!
                  .mapIndexed((index, scene) => Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 12.0),
                        child: IoT_Scene_Tile(
                          scene: scene,
                          onTap: () => onTap(scene),
                          count: index + 1,
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
          'Failed to load energy consumption',
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
        );
      }
    },
  );
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E e) f) sync* {
    var index = 0;
    for (final element in this) {
      yield f(index, element);
      index++;
    }
  }
}

Wrap buildSceneList(AsyncSnapshot snapshot, Function onTap) {
  return Wrap(
    spacing: 10,
    children: <Widget>[
      Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return IoT_Scene_Tile(
                  scene: snapshot.data![index],
                  onTap: () => onTap,
                  count: index + 1);
            },
          ),
        ],
      ),
    ],
  );
}

Widget buildSceneCard(IoT_Scene scene, navigateTo) {
  int count = 3;
  String devices = 'Lights; Fan';
  return SizedBox(
    width: 150, // Adjust the width to make it smaller
    height: 150, // Set the height to match the width for a 1:1 aspect ratio
    child: GestureDetector(
      onTap: () {
        // Handle the tap event here
        navigateTo(eachScene(scene: scene));
      },
      child: Card(
        color: const Color.fromRGBO(0, 69, 107, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage(
                  scene.icon != null
                      ? 'images/icons/${scene.icon}.png'
                      : 'images/icons/scene.png',
                ),
                width: 80,
                height: 80,
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '$count',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(110, 241, 110, 1),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const TextSpan(
                      text: ' · ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(255, 255, 255, 1),
                        letterSpacing: 1.0,
                      ),
                    ),
                    TextSpan(
                      text: '${scene.name}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(255, 255, 255, 1),
                        letterSpacing: 1.0,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                devices,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Iterable<Column> buildSceneCards(List<IoT_Scene> scenes, navigateTo) {
  return scenes.map((scene) {
    return Column(
      children: [
        buildSceneCard(scene, navigateTo),
      ],
    );
  });
}
