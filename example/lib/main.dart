import 'dart:io';

import 'package:flutter/material.dart';
import 'package:multi_image_capture/multi_image_capture.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MultiImageCapture(
          title: "Camera Capture",
          /*maxImages: 5,
          preCapturedImages: [],

          themePrimaryColor: Colors.deepPurpleAccent,
          themeSecondaryColor: Colors.white,

          switchCameraButtonIcon: Icons.flip_camera_android,
          captureButtonIcon: Icons.camera,
          doneButtonIcon: Icons.done,

          removeImageButtonIcon: Icons.remove,
          removeImageButtonSize: 21,
          removeImageButtonColor: Colors.amber,

          imageLimitErrorMessage: "You cannot capture more than 5 images at a time",*/

          onRemoveImage: (File image) async {
            /*
            * Can Show confirmation dialog here before returning to remove image
            * Return true; will remove image from list
            * Return false; will keep the image unchanged
          */

            return true;
          },
          onAddImage: (image) async {
            //perform any action after capturing each image
          },

          onComplete: (List<File> finalImages) {},

        )
    );
  }
}
