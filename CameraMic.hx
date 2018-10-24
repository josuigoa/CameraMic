package;

#if mobile
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

#if (android && openfl)
import lime.system.JNI;
#end

#if firefoxos
typedef MozActivity = {
	var onsuccess:Void->Void;
	var onerror:Void->Void;
}
#end

class CameraMic
{
	@:isVar public static var appFilesDirectory(get, set):String = "";
	
    private static var cameramic_setappfilesdirectory : Dynamic;
    private static var cameramic_takephoto : Dynamic;
    private static var cameramic_startrecordingaudio : Dynamic;
	private static var cameramic_stoprecordingaudio : Dynamic;
	private static var cameramic_playaudio : Dynamic;
	private static var cameramic_stopaudio : Dynamic;

	/**
	 * Function to push the native camera
	 * @param	haxeObject Java will call the `cameraPhotoCallback` function in this object with the taken photo path
	 * @param	callbackHandler Objective-C will call this function with the taken photo path
	 */
    public static function takePhoto(haxeObject:Dynamic, callbackHandler:Dynamic->?Bool->Void):Void
    {
        initCamera();
        #if android
        cameramic_takephoto(haxeObject);
        #elseif ios
        cameramic_takephoto(callbackHandler);
		#elseif firefoxos
		trace("takePhoto html5");
		var emaitza:MozActivity = untyped __js__("new MozActivity( { name: 'pick', data: { type: ['image/png', 'image/jpg', 'image/jpeg'] }});");
		emaitza.onsuccess = function() { callbackHandler(untyped __js__("this.result.blob")); };
		emaitza.onerror = function() { untyped __js__("alert('Pick onerror funtzioan nago!');"); };
        #end
    }

	/**
	 * Function to push the native microphone
	 * @param	haxeObject Java will call the `recordAudioCallback` function in this object with the recorded audio path
	 * @param	callbackHandler Objective-C will call this function with the recorded audio path
	 */
    public static function startRecordingAudio(haxeObject:Dynamic, callbackHandler:Dynamic->?Bool->Void, removeLastRecording:Bool = false):Void
    {
        initMic();
        #if android
        cameramic_startrecordingaudio(haxeObject, removeLastRecording);
        #elseif ios
        cameramic_startrecordingaudio(callbackHandler);
        #end
    }

	/**
	 * Stop recording native microphone
	 */
    public static function stopRecordingAudio():Void
	{
        initMic();
        #if mobile
        cameramic_stoprecordingaudio();
        #end
	}

	/**
	 * Play audio in native player 
	 * @param	filePath The path of the audio file
	 */
    public static function playAudio(filePath:String):Void
	{
        initPlayer();
        #if mobile
        cameramic_playaudio(filePath);
        #end
	}
	
    public static function stopAudio():Void
	{
        initPlayer();
        #if mobile
        cameramic_stopaudio();
        #end
	}

    private static function initAppDirectoryPath()
    {
        if (cameramic_setappfilesdirectory != null)
            return;

        #if android
        cameramic_setappfilesdirectory = JNI.createStaticMethod("org.haxe.extension.cameramic.CameraMic", "setAppDirectory", "(Ljava/lang/String;)Ljava/lang/String;");
        #elseif ios
        cameramic_setappfilesdirectory = Lib.load ("cameramic", "cameramic_setappfilesdirectory", 1);
        #end
    }

    private static function initCamera()
    {
        if (cameramic_takephoto != null)
            return;
		
        #if android
        cameramic_takephoto = JNI.createStaticMethod("org.haxe.extension.cameramic.CameraMic", "takePhoto", "(Lorg/haxe/lime/HaxeObject;)V");
        #elseif ios
        cameramic_takephoto = Lib.load ("cameramic", "cameramic_takephoto", 1);
        #end
    }
    
    private static function initMic()
    {
        if (cameramic_startrecordingaudio != null && cameramic_stoprecordingaudio != null)
            return;

        #if android
        cameramic_startrecordingaudio = JNI.createStaticMethod("org.haxe.extension.cameramic.CameraMic", "startRecordingAudio", "(Lorg/haxe/lime/HaxeObject;Z)V");
        cameramic_stoprecordingaudio = JNI.createStaticMethod("org.haxe.extension.cameramic.CameraMic", "stopRecordingAudio", "()V");
        #elseif ios
        cameramic_startrecordingaudio = Lib.load ("cameramic", "cameramic_startrecordingaudio", 2);
        cameramic_stoprecordingaudio = Lib.load ("cameramic", "cameramic_stoprecordingaudio", 0);
        #end
    }
	
    private static function initPlayer()
    {
        if (cameramic_playaudio != null && cameramic_stopaudio != null)
            return;

        #if android
        cameramic_playaudio = JNI.createStaticMethod("org.haxe.extension.cameramic.CameraMic", "playAudio", "(Ljava/lang/String;)V");
        cameramic_stopaudio = JNI.createStaticMethod("org.haxe.extension.cameramic.CameraMic", "stopAudio", "()V");
        #elseif ios
        cameramic_playaudio = Lib.load ("cameramic", "cameramic_playaudio", 1);
        cameramic_stopaudio = Lib.load ("cameramic", "cameramic_stopaudio", 0);
        #end
    }
	
	/**
	 * GETTERS & SETTERS
	 */
    public static function get_appFilesDirectory():String
	{
		if (appFilesDirectory != "") return appFilesDirectory;
		
		return appFilesDirectory = "";
	}
	
    public static function set_appFilesDirectory(subdir:String):String
    {
		#if mobile
        initAppDirectoryPath();
		appFilesDirectory = cameramic_setappfilesdirectory(subdir);
		#elseif flash
		appFilesDirectory = subdir;
		#end
		
		return appFilesDirectory;
    }
}
