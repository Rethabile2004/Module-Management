//
// Coder                    : Rethabile Eric Siase
// Purpose                  : Integrated fiebase storage for managing(adding, removing and updating) modules
//

import 'package:firebase_flutter/routes/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  if (kIsWeb) {
    Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY']!,
        authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'],
        projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'],
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
        appId: dotenv.env['FIREBASE_APP_ID']!,
        measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'],
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(
    ChangeNotifierProvider(create: (_) => AuthService(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Auth',

      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      debugShowCheckedModeBanner: false,
      initialRoute: RouteManager.loginPage,
      onGenerateRoute: RouteManager.generateRoute,

      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue, // Define primary color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
        ), // Set seed color for themes
        fontFamily: 'LibreFranklin', // Set global font style
        // AppBar Theme - Defines global AppBar design
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueAccent, // Set AppBar background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(
                30,
              ), // Apply curved shape to AppBar bottom
            ),
          ),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'LibreFranklin',
            color: Colors.white, // Set AppBar title text color
          ),
        ),

        // Floating Action Button Theme
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blueAccent, // Set FAB background color
          foregroundColor: Colors.white, // Set FAB text/icon color
        ),

        // Text Button Theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              fontFamily: 'LibreFranklin',
            ),
          ),
        ),

        // Elevated Button Theme - Defines global button styles
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent, // Set button background color
            foregroundColor: Colors.white, // Set button text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Apply rounded corners
            ),
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 20,
            ), // Set button padding
          ),
        ),
      ),
    );
  }
}
