CameraMic
=========

Camera &amp; Microphone OpenFL native extension

Features:
 * Native camera view to take a photo.
 * Native microphone access to record audio.
 * Recorded audio playback.


There is not any error handling yet. I know this is no a perfect way to do it, but at least it works for me! It would be great you help me doing it better.

To try the project, you must set CameraMic haxelib with this command:

> haxelib dev CameraMic path/to/CameraMic


Android
-------
Android version works fine ~~hacking GameActivity for the camera (the GameActivity file is in the test project). When OpenFL 1.1 is released, I hope I will do it cleaner.~~ using the new OpenFL 1.1 Extension class

iOS
---
In the iOS version, the camera view pushes and takes the photo. Otherwise it seems it records audio correctly, but I can´t play it back, so I can't know if it is ok.

License
---
This software is released under the MIT License
