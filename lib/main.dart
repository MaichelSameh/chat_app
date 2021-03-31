import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/chat_screen.dart';
import 'screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "flutter Demo",
      theme: ThemeData(
          canvasColor: Colors.black,
          primarySwatch: Colors.pink,
          backgroundColor: Colors.pink,
          accentColor: Colors.deepPurple,
          accentColorBrightness: Brightness.dark,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
            textStyle: MaterialStateProperty.all<TextStyle>(
              TextStyle(color: Colors.white),
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ))),
      home: ResponsiveRender(),
    );
  }
}

class ResponsiveRender extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width <= 500)
      return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapShot) {
          // if (snapShot.connectionState == ConnectionState.waiting)
          //   return SplashScreen();
          return snapShot.hasData ? ChatScreen() : AuthScreen();
        },
      );
    else {
      return Scaffold(
        body: Center(
          child: Text("You are not using a mobile"),
        ),
      );
    }
  }
}
