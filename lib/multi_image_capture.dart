import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class MultiImageCapture extends StatefulWidget {
  final Future<bool> Function(File image) onRemoveImage;
  final Future<void> Function(File image)? onAddImage;
  final Function(List<File> finalImages)? onComplete;

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
    this.imageLimitErrorMessage =
    "Maximum number of images reached. Cannot capture more images",
  }) : super(key: key);

  @override
  State<MultiImageCapture> createState() => _MultiImageCaptureState();
}

class _MultiImageCaptureState extends State<MultiImageCapture> {
  bool isPrimaryOn = true;
  final List<File> capturedImages = [];
  CameraController? _cameraController;
  final List<CameraDescription> _availableCameras = [];
  bool _camerasLoading = true;
  final ScrollController _imagesScrollController = ScrollController();
  final File _dummyImageFile = File('');

  @override
  void initState() {
    capturedImages.addAll(widget.preCapturedImages);
    initPrimaryCamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _cameraController?.dispose();
        widget.onComplete?.call(capturedImages.toList());
        _cameraController?.setFlashMode(FlashMode.off);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: widget.themePrimaryColor,
          elevation: 0,
          title: Text(
            widget.title,
            style: TextStyle(color: widget.themeSecondaryColor),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: widget.themeSecondaryColor),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Stack(children: [
          _buildCameraPreview(context),
          Positioned(
            top: 0,
            left: 0,
            child: _buildCapturedImagesPane(context),
          ),
        ]),
      ),
    );
  }

  Widget _buildCameraPreview(BuildContext context) {
    if (_camerasLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_availableCameras.isEmpty) {
      return const Center(
          child: Text("No Available Cameras",
              style: TextStyle(color: Colors.black)));
    } else {
      return SizedBox.expand(
        child: CameraPreview(
          _cameraController!,
          child: Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          _cameraController!.setFlashMode(FlashMode.off);
                          if (isPrimaryOn) {
                            initSecondaryCamera();
                          } else {
                            initPrimaryCamera();
                          }
                          isPrimaryOn = !isPrimaryOn;
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                          backgroundColor: widget.themePrimaryColor,
                          // foregroundColor: Colors.red, // <-- Splash color
                        ),
                        child: Icon(widget.switchCameraButtonIcon,
                            color: widget.themeSecondaryColor),
                      )),
                  Flexible(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          capturedImages.contains(_dummyImageFile)
                              ? null
                              : captureImage(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: widget.themePrimaryColor,
                          //foregroundColor: Colors.red, // <-- Splash color
                        ),
                        child: Icon(widget.captureButtonIcon,
                            color: widget.themeSecondaryColor),
                      )),
                  Flexible(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () async {
                          await widget.onComplete?.call(capturedImages);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                          backgroundColor: widget.themePrimaryColor,
                          //foregroundColor: Colors.red, // <-- Splash color
                        ),
                        child: Icon(widget.doneButtonIcon,
                            color: widget.themeSecondaryColor),
                      )),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildCapturedImagesPane(BuildContext context) {
    return ClipRect(
      child: Container(
        height: 120,
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: ListView.builder(
          controller: _imagesScrollController,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var imageFile = capturedImages.elementAt(index);

            bool isDummy = imageFile == _dummyImageFile;

            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: widget.themePrimaryColor, width: 1.5),
                    ),
                    child: isDummy
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: Center(child: CircularProgressIndicator()),
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        capturedImages.elementAt(index),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -10,
                    right: -10,
                    child: GestureDetector(
                        onTap: () {
                          removeImageFile(capturedImages.elementAt(index));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: widget.removeImageButtonColor,
                          ),
                          child: Icon(widget.removeImageButtonIcon,
                              color: widget.themeSecondaryColor,
                              size: widget.removeImageButtonSize),
                        )),
                  )
                ],
              ),
            );
          },
          itemCount: capturedImages.length,
          padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
        ),
      ),
    );
  }

  Future<void> captureImage(BuildContext context) async {
    if (capturedImages.length >= widget.maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(widget.imageLimitErrorMessage),
      ));
      return;
    }
    capturedImages.add(_dummyImageFile);
    setState(() {});
    var xFile = await _cameraController!.takePicture();
    File imgFile = File(xFile.path);
    widget.onAddImage?.call(imgFile);
    capturedImages.remove(_dummyImageFile);
    capturedImages.add(imgFile);
    setState(() {});
    _imagesScrollController.animateTo(
      _imagesScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    _cameraController!.setFlashMode(FlashMode.off);
  }

  Future<void> removeImageFile(File file) async {
    bool isRemoved = await widget.onRemoveImage(file);
    if (isRemoved) capturedImages.remove(file);
    setState(() {});
  }

  Future<void> initPrimaryCamera() async {
    _availableCameras.addAll(await availableCameras());
    if (_availableCameras.isNotEmpty) {
      _cameraController =
          CameraController(_availableCameras.first, ResolutionPreset.max);
      await _cameraController!.initialize();
      _cameraController!.setFlashMode(FlashMode.off);
    }
    _camerasLoading = false;
    setState(() {});
  }

  Future<void> initSecondaryCamera() async {
    _availableCameras.addAll(await availableCameras());
    _camerasLoading = false;
    if (_availableCameras.length > 1) {
      _cameraController = CameraController(
          _availableCameras.elementAt(1), ResolutionPreset.max);
      await _cameraController!.initialize();
      _cameraController!.setFlashMode(FlashMode.off);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _imagesScrollController.dispose();
    super.dispose();
  }
}
