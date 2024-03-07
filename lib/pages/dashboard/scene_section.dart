part of 'dashboard_lib.dart';

Widget buildSceneSection(BuildContext context) {
  navigateTo(Widget page) => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => page,
        ));
  // For now, using static data and cards
  return 
  FutureBuilder<List<IoT_Scene>>(
        future: scenes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Scene',
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          direction: Axis.horizontal,
                          spacing: 10,
                          children: <Widget>[
                            ...buildSceneCards(snapshot.data!, navigateTo)
                            // Add more columns as needed
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(
          child: CircularProgressIndicator(
            color: Color(0xFFD36E2F),
          ),
        );
      },
    );
}

Widget buildSceneCard(IoT_Scene scene, navigateTo) {
  int count = 3;
  String devices = 'Lights; Fan';
  return SizedBox(
    width: 150, // Adjust the width to make it smaller
    height: 150, // Set the height to match the width for a 1:1 aspect ratio
    child: 
    GestureDetector(
      onTap: () {
        // Handle the tap event here
        navigateTo(eachScene(scene: scene));
      },
      child: Card(
        color: Color.fromRGBO(0, 69, 107, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage(scene.icon != null
                      ? 'images/icons/${scene.icon}.png'
                      : 'images/icons/scene.png',),
                width: 80,
                height: 80,
              ),
              SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '$count',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(110, 241, 110, 1),
                        letterSpacing: 1.0,
                      ),
                    ),
                    TextSpan(
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
                      style: TextStyle(
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

Iterable<Column> buildSceneCards(List<IoT_Scene> scenes, navigateTo){
  return scenes.map((scene) {
      return Column(
        children: [
          buildSceneCard(scene, navigateTo),
        ],
      );
  });
}