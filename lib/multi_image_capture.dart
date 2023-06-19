import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

part 'multi_image_capture_state.dart';

class MultiImageCapture extends StatefulWidget {
  /// Callback functions for actions in camera view (Mandatory)
  final Future<bool> Function(File image) onRemoveImage;
  final Future<void> Function(File image)? onAddImage;
  final Function(List<File> finalImages)? onComplete;

  /// UI Attribute variables (Optional)
  final List<File> preCapturedImages;
  final int maxImages;
  final String title;
  final Color themePrimaryColor;
  final Color themeSecondaryColor;
  final IconData switchCameraButtonIcon;
  final IconData captureButtonIcon;
  final IconData doneButtonIcon;
  final IconData removeImageButtonIcon;
  final Color removeImageButtonColor;
  final double removeImageButtonSize;
  final String imageLimitErrorMessage;

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

