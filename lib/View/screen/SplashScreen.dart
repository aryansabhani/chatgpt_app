
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chatgpt_app/view/screen/AiTab.dart';
import 'package:flutter/material.dart';

class AnimatedSplas extends StatefulWidget {
  const AnimatedSplas({super.key});

  @override
  State<AnimatedSplas> createState() => _AnimatedSplasState();
}

class _AnimatedSplasState extends State<AnimatedSplas> {
  // inquriry_controller controller = Get.put(inquriry_controller());


  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedSplashScreen(
        backgroundColor: Color(0xffF9F9F7),
        splashIconSize: s.height * 0.2,
        splash: Image.asset(
          "asstes/image/img.png",
          fit: BoxFit.fitWidth,
        ),
        nextScreen: AiTab(),
      ),
      backgroundColor: Colors.black,
    );
  }
}
