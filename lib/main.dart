import 'package:flutter/material.dart';
import 'package:l3homeation/pages/charts/power_graph.dart';
import 'package:l3homeation/pages/devices/listDevice.dart';
import 'package:l3homeation/pages/editDevice/edit_device.dart';
import 'package:l3homeation/pages/rooms/base/rooms.dart';
import 'package:l3homeation/pages/scenes/listScenes.dart';
import 'package:l3homeation/pages/login/auth_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'provider/navigation_provider.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// void main() {
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: 22.0,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 17.0,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 12.0,
    ),
  );

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => NavigationProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "L3Homeation",
          theme: ThemeData(
            primarySwatch: Colors.deepOrange, // Your primary color
            textTheme: GoogleFonts.poppinsTextTheme(textTheme),
            // Other theme properties...
          ),
          home: const AuthPage(),
          // home: Rooms(),
        ),
      );
}



// class MyApp extends StatelessWidget => Scaffold {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: dashboard(),
//     );
//   }
// }
