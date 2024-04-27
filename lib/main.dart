import 'package:chatgpt_app/Controller/ImageController.dart';
import 'package:chatgpt_app/Controller/ThemeController.dart';
import 'package:chatgpt_app/view/screen/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => ImageController()),
      ],child:  MyApp()) );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: AppBarTheme(backgroundColor: Color(0xffEB8A71)),
        brightness: Brightness.light,
        backgroundColor: Color(0xFFF5F5F5), // Light gray background
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black), // Dark text color
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        // primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        backgroundColor: Color(0xFF121212), // Dark gray background
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white), // Light text color
        ),
      ),
      themeMode: Provider.of<ThemeController>(context).isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: AnimatedSplas(),
    );
  }
}
