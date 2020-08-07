import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:spring_button/spring_button.dart';
import 'package:image_sequence_animator/image_sequence_animator.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ImageSequenceAnimatorState imageSequenceAnimator;
  bool wasPlaying = false;
  Color color1 = Colors.greenAccent;
  Color color2 = Colors.indigo;
  String loopText = "Start Loop";
  String boomerangText = "Start Boomerang";

  void onReadyToPlay(ImageSequenceAnimatorState _imageSequenceAnimator) {
    imageSequenceAnimator = _imageSequenceAnimator;
  }

  void onPlaying(ImageSequenceAnimatorState _imageSequenceAnimator) {
    setState(() {});
  }

  Widget row(String text, Color color) {
    return Padding(
      padding: EdgeInsets.all(3.125),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.5,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.all(25),
              child: ImageSequenceAnimator(
                "assets/images/side",
                "side_",
                0,
                0,
                "jpg",
                60,
                isAutoPlay: false,
                color: null,
                onReadyToPlay: onReadyToPlay,
                onPlaying: onPlaying,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: CupertinoSlider(
                    value: imageSequenceAnimator == null ? 0.0 : imageSequenceAnimator.animationController.value,
                    min: imageSequenceAnimator == null ? 0.0 : imageSequenceAnimator.animationController.lowerBound,
                    max: imageSequenceAnimator == null ? 100.0 : imageSequenceAnimator.animationController.upperBound,
                    onChangeStart: (double value) {
                      wasPlaying = imageSequenceAnimator.animationController.isAnimating;
                      imageSequenceAnimator.pause();
                    },
                    onChanged: (double value) {
                      imageSequenceAnimator.skip(value);
                    },
                    onChangeEnd: (double value) {
                      if (wasPlaying) imageSequenceAnimator.play();
                    },
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      imageSequenceAnimator == null ? "0.0" : ((imageSequenceAnimator.currentTime.floor()).toString() + "/" + (imageSequenceAnimator.totalTime.floor()).toString()),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: SpringButton(
                    SpringButtonType.OnlyScale,
                    row(
                      loopText,
                      Colors.cyan,
                    ),
                    useCache: false,
                    onTap: () {
                      setState(() {
                        loopText = imageSequenceAnimator.isLooping ? "Start Loop" : "Stop Loop";
                        boomerangText = "Start Boomerang";
                        imageSequenceAnimator.setIsLooping(!imageSequenceAnimator.isLooping);
                      });
                    },
                  ),
                ),
                Expanded(
                  child: SpringButton(
                    SpringButtonType.OnlyScale,
                    row(
                      boomerangText,
                      Colors.deepPurpleAccent,
                    ),
                    useCache: false,
                    onTap: () {
                      setState(() {
                        loopText = "Start Loop";
                        boomerangText = imageSequenceAnimator.isBoomerang ? "Start Boomerang" : "Stop Boomerang";
                        imageSequenceAnimator.setIsBoomerang(!imageSequenceAnimator.isBoomerang);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SpringButton(
              SpringButtonType.OnlyScale,
              row(
                "Change Colour",
                Colors.redAccent,
              ),
              useCache: false,
              onTap: () {
                imageSequenceAnimator.changeColor(imageSequenceAnimator.color == color1 ? color2 : color1);
              },
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: SpringButton(
                    SpringButtonType.OnlyScale,
                    row(
                      "Play/Pause",
                      Colors.deepOrangeAccent,
                    ),
                    useCache: false,
                    onTap: () {
                      setState(() {
                        imageSequenceAnimator.animationController.isAnimating ? imageSequenceAnimator.pause() : imageSequenceAnimator.play();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: SpringButton(
                    SpringButtonType.OnlyScale,
                    row(
                      "Stop",
                      Colors.green,
                    ),
                    useCache: false,
                    onTap: () {
                      imageSequenceAnimator.stop();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: SpringButton(
                    SpringButtonType.OnlyScale,
                    row(
                      "Restart",
                      Colors.teal,
                    ),
                    useCache: false,
                    onTap: () {
                      imageSequenceAnimator.restart();
                    },
                  ),
                ),
                Expanded(
                  child: SpringButton(
                    SpringButtonType.OnlyScale,
                    row(
                      "Rewind",
                      Colors.indigoAccent,
                    ),
                    useCache: false,
                    onTap: () {
                      imageSequenceAnimator.rewind();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}