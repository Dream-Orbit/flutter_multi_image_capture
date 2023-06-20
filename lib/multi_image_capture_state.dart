part of 'multi_image_capture.dart';

class _MultiImageCaptureState extends State<MultiImageCapture> {
  /// Flag to switch between primary and secondary camera
  bool isPrimaryOn = true;

  /// List of captured images
  final List<File> capturedImages = [];

  /// Controller to access all camera related operational methods
  CameraController? _cameraController;

  /// List of available cameras
  final List<CameraDescription> _availableCameras = [];

  /// Flag to indicate loading state of camera
  bool _camerasLoading = true;

  /// Horizontal scroller for showing captured images
  final ScrollController _imagesScrollController = ScrollController();

  /// A replacement temporary file to replace with Image on capture
  final File _dummyImageFile = File('');

  @override
  void initState() {
    ///Initialize rear camera (Primary camera) and add pre captured images to list
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

      ///Main UI widget tree
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

  /// Using camera package to generate and show camera view
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
                        if(capturedImages.contains(_dummyImageFile)) {
                          captureImage(context);
                        }
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
                        onPressed: () {
                          widget.onComplete?.call(capturedImages).then((v){
                            Navigator.of(context).pop();
                          });
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

  /// Build list of images pane to show captured images list
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
                      border: Border.all(color: widget.themePrimaryColor, width: 1.5),
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

  /// Capture image and add images to list and images pane
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

  /// Remove image from list and images pane
  Future<void> removeImageFile(File file) async {
    bool isRemoved = await widget.onRemoveImage(file);
    if (isRemoved) capturedImages.remove(file);
    setState(() {});
  }

  /// Initialize Primary Camera
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

  /// Initialize Secondary Camera
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
