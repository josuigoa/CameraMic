CameraMic
=========

Camera &amp; Microphone OpenFL native extension

Features:
 * Native camera view to take a photo.
 * Native microphone access to record audio.
 * Recorded audio playback.


I know this is no a perfect way to do it, but at least it works for me! It would be great you help me doing it better.


Android
-------
Android version works fine hacking GameActivity for the camera (the GameActivity file is in the test project). When OpenFL 1.1 is released, I hope I will do it cleaner.

iOS
---
In the iOS version, the camera view pushes and takes the photo. But when I get the BitmapData with Haxe, it loads with strange colours, I don't know if it the taken photo or the loading process. And it seems it records audio correctly, but I can´t play it back, so I can't know if it is ok.
