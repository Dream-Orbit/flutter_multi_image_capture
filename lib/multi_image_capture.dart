import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

part 'multi_image_capture_state.dart';

class MultiImageCapture extends StatefulWidget {
  // Callback functions for actions in camera view (Mandatory)

  /// Callback called when image is removed from the captured images list
  final Future<bool> Function(File image) onRemoveImage;

  /// Callback called when image is added from to captured images list
  final Future<void> Function(File image)? onAddImage;

  /// Callback called when complete button is clicked
  final Function(List<File> finalImages)? onComplete;

  // UI Attribute variables (Optional)

  /// List of previously captured images which can be passed to add them to newly framing images list
  final List<File> preCapturedImages;

  /// Maximum number of images that are allowed to be clicked and stored in list
  final int maxImages;

  /// Toolbar title text for camera screen
  final String title;

  /// Primary theme Color of the application
  final Color themePrimaryColor;

  /// Secondary theme Color of the application
  final Color themeSecondaryColor;

  /// IconData for the camera toggle button
  final IconData switchCameraButtonIcon;

  /// IconData for the camera capture button
  final IconData captureButtonIcon;

  /// IconData for the done button
  final IconData doneButtonIcon;

  /// IconData for the image delete button
  final IconData removeImageButtonIcon;

  /// BackgroundColor for the delete image button
  final Color removeImageButtonColor;

  /// Size of the delete image button
  final double removeImageButtonSize;

  /// Error message to display when try to capture more than maximum allowed images
  final String imageLimitErrorMessage;

  /// Constructor to initialize camera screen (Note: onRemoveImage, onAddImage, onComplete are mandatory parameters)
  const MultiImageCapture({
    Key? key,
    this.preCapturedImages = const [],
    required this.onRemoveImage,
    required this.onAddImage,
    required this.onComplete,
    this.title = "",
    this.maxImages = 10,
    this.themePrimaryColor = Colors.blue,
    this.themeSecondaryColor = Colors.white,
    this.removeImageButtonColor = Colors.red,
    this.switchCameraButtonIcon = Icons.switch_camera,
    this.captureButtonIcon = Icons.camera,
    this.doneButtonIcon = Icons.send,
    this.removeImageButtonIcon = Icons.close,
    this.removeImageButtonSize = 20,
    this.imageLimitErrorMessage = "Maximum number of images reached. Cannot capture more images",
  }) : super(key: key);

  @override
  State<MultiImageCapture> createState() => _MultiImageCaptureState();
}

