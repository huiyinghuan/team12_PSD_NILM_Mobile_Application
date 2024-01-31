part of 'dashboard_lib.dart';

Widget buildSceneSection(BuildContext context) {
  // For now, using static data and cards
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Scene',
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: <Widget>[
            Column(
              children: [
                buildSceneCard(
                    'Kitchen', 'Lights; Fan', '3', 'images/kitchen.png'),
              ],
            ),
            Column(
              children: [
                buildSceneCard('Bedroom', 'ALL', '4', 'images/bedroom.png'),
              ],
            ),
            // Add more columns as needed
          ],
        ),
      ],
    ),
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
