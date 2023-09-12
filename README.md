# Flutter Multi Image Capture

Multi Image Capture is a Flutter package which can be used to capture multiple images from camera and get the list of images in return.
   
### Add Flutter Dependency
Add the following packages under dependencies section
``` Dart
  multi_image_capture: {latest version number : ex 1.0.2}
```
Run `Flutter Pub Get` 

### Basic Implementation
Use the below code to initialise the Multi Image Capture camera screen.
```
    Navigator.of(context).push(
        MultiImageCapture(
            title: "Camera Capture",
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
    
            onComplete: (List<File> finalImages) {
                
            },
        )
    )
```

_Note: onRemoveImage(), onAddImage() and onComplete() are the Mandatory Parameters. MultiImageCapture() can be separately put into Stateful or stateless class as given in example. Otherwise tt need to use Navigator.of().push() or if you are using GetX get.to() to push it as a screen as given in above code snippet_

### Additional Attributes (Optional Parameters)
```
    // Toolbar title for the camera screen
    title: "Camera Capture",
    
    // Maximum number of images that can be captured at once
    maxImages: 5,
    
    // Previously captured images can be passed to resume from that point
    preCapturedImages: [],

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
```

## License

```
BSD 3-Clause License
```
Read the [LICENSE](LICENSE) file for details.

## Changelog

Refer to the [Changelog](CHANGELOG.md) to get all release notes.