import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:news_app/screens/home_screen.dart';

class TextAnimation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TextAnimationState();
}

class TextAnimationState extends State<TextAnimation> {
  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   Future.delayed(Duration(seconds: 3), () {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => HomeScreen()),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedTextKit(
          isRepeatingAnimation: false,
          animatedTexts: [
            TyperAnimatedText(
              'NewsNuts',
              textStyle: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
              speed: Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }
}
