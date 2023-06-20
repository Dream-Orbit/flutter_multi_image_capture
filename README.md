# Flutter Multi Image Capture

Multi Image Capture is a Flutter package which can be used to capture multiple images from camera and get the list of images in return.
   
### Add Flutter Dependency
Add the following packages under dependencies section
``` Dart
  flutter_multi_image_capture: {latest version number : ex 1.0.0}
```
Run `Flutter Pub Get` 

### Basic Implementation
Use the below code to initialie the Multi Image Capture camera screen
```
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
```

_Note: onRemoveImage(), onAddImage() and onComplete() are the Mandatory Parameters_

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
<img src="https://github.com/Dream-Orbit/flutter_multi_image_capture/blob/main/images/Screenshot_3.jpg"  width="23%" height="12%">  <img src="https://github.com/Dream-Orbit/flutter_multi_image_capture/blob/main/images/Screenshot_4.jpg"  width="23%" height="12%">
<img src="https://github.com/Dream-Orbit/flutter_multi_image_capture/blob/main/images/Screenshot_1.jpg"  width="23%" height="12%">  <img src="https://github.com/Dream-Orbit/flutter_multi_image_capture/blob/main/images/Screenshot_2.jpg"  width="23%" height="12%">  

Screenshot 1 and Screenshot 2 implemented without any optional parameters. Screenshot 3 and Screenshot 4 implemented with all optional parameters
