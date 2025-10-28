import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class TextAnimation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TextAnimationState();
}

class TextAnimationState extends State<TextAnimation> {
  @override


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
