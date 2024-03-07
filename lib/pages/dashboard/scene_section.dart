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
        return Center(child: CircularProgressIndicator());
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

Widget buildSceneCard(
    String title, String devices, String count, String imagePath) {
  return Card(
    color: Color.fromRGBO(0, 69, 107, 1),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Icon(Icons.kitchen, size: 40), // Change to appropriate icon
          Image(
            image: AssetImage(imagePath),
            width: 52.10625,
            height: 53.12625,
          ),

          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: '$count',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(255, 255, 255, 1),
                      letterSpacing: 1.0,
                    )),
                TextSpan(
                    text: ' · ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(217, 217, 217, 1),
                    )),
                TextSpan(
                    text: '$title',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(255, 255, 255, 1),
                      letterSpacing: 1.0,
                    )),
              ],
            ),
          ),
          Text(
            devices,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    ),
  );
}
