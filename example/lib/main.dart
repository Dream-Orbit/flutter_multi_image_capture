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
          // Toolbar title for the camera screen
          title: "Camera Capture",

          // Maximum number of images that can be captured at once
          maxImages: 5,

          // Previously captured images can be passed to resume from that point
          preCapturedImages: const [],

          // Custom Theme Colors (By Default app theme colors will be taken)
          themePrimaryColor: Colors.deepPurpleAccent,
          themeSecondaryColor: Colors.white,

          // Icons for the buttons on the camera screen
          switchCameraButtonIcon: Icons.flip_camera_android,
          captureButtonIcon: Icons.camera,
          doneButtonIcon: Icons.done,

          // Design elements for the image delete button
          removeImageButtonIcon: Icons.remove,
          removeImageButtonSize: 21,
          removeImageButtonColor: Colors.amber,

          // Error message when maximum number of image capture is reached
          imageLimitErrorMessage: "You cannot capture more than 5 images at a time",

          //MANDATORY FIELDS

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
