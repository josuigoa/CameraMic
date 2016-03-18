CameraMic
=========

Camera &amp; Microphone OpenFL native extension (for Android & iOS)

Features:
 * Native camera view to take a photo.
 * Native microphone access to record audio.
 * Recorded audio playback.


There is not any error handling yet. I know this is no a perfect way to do it, but at least it works for me! It would be great you help me doing it better.

Installation
------------
Install the repository code using `haxelib git`:

`haxelib git CameraMic https://github.com/josuigoa/CameraMic.git`


Android
-------
Android version works fine ~~hacking GameActivity for the camera (the GameActivity file is in the test project). When OpenFL 1.1 is released, I hope I will do it cleaner.~~ using the new OpenFL 1.1 Extension class

iOS
---
In the iOS version, the camera view pushes and takes the photo. Otherwise it seems it records audio correctly, but I can´t play it back, so I can't know if it is ok.

TODO
---
 * Move the images from the camera roll instead of copying


License
---
This software is released under the MIT License
