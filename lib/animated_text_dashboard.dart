import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AnimatedGreetingText extends StatelessWidget {
  final String username;

  const AnimatedGreetingText({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterText('Hello, $username!'),
        TypewriterText('Aloha, $username!'),
        TypewriterText('Bonjour, $username!'),
        TypewriterText('Ohayo, $username!'),
        TypewriterText('Howdy!'),
        TypewriterText('Good day!'),
      ],
      repeatForever: true,
      pause: const Duration(milliseconds: 1000),
    );
  }
}

class TypewriterText extends TypewriterAnimatedText {
  TypewriterText(String text) : super(
    text,
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    speed: const Duration(milliseconds: 100),
  );
}
