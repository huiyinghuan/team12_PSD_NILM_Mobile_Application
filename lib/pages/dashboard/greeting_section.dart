part of 'dashboard_lib.dart';

Widget buildGreetingSection(BuildContext context) {
  return Container(
    child: ListTile(
      leading: CircleAvatar(child: Icon(Icons.person)),
      title: Row(
        children: [
          Expanded(
            child: FutureBuilder<String?>(
              future: UserPreferences.getString('username'),
              builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                    children: [
                      RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Hi, ',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.deepOrange[800],
                            ),
                          ),
                          TextSpan(
                            text: '${snapshot.data} 👋',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.deepOrange[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Welcome Back', // You can change this text
                      style: GoogleFonts.poppins(
                      fontSize: 12, // Smaller font size for the subtitle
                      fontWeight: FontWeight.w400,
                      color: Colors.black, // Subdued color for the subtitle
                        ),
                      ),
                    ],
                  );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    {
                      return Text('Error: ${snapshot.error}');
                    }
                  }
                },
              ),
            ),
            IconButton(
              onPressed: () async {
                await signUserOut(context);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
