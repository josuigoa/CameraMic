package;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

class CameraMic
{
    private static var cameramic_getappdirectorypath : Dynamic;
    private static var cameramic_getphoto : Dynamic;
    private static var cameramic_startrecordingaudio : Dynamic;
	private static var cameramic_stoprecordingaudio : Dynamic;
	private static var cameramic_playaudio : Dynamic;
    
    public static function getAppDirectoryPath():String
    {
        initAppDirectoryPath();
        return cameramic_getappdirectorypath();
    }

    public static function getPhoto(haxeObject:Dynamic, callbackHandler:Dynamic->?Bool->Void):Void
    {
        initCamera();
        #if android
        cameramic_getphoto(haxeObject);
        #elseif ios
        cameramic_getphoto(callbackHandler);
        #end
    }

    public static function startRecordingAudio(haxeObject:Dynamic, callbackHandler:Dynamic->?Bool->Void):Void
    {
        initMic();
        #if android
        cameramic_startrecordingaudio(haxeObject);
        #elseif ios
        cameramic_startrecordingaudio(callbackHandler);
        #end
    }

    public static function stopRecordingAudio():Void
	{
        initMic();
        #if mobile
        cameramic_stoprecordingaudio();
        #end
	}

    public static function playAudio(filePath:String):Void
	{
        initPlayer();
        #if mobile
        cameramic_playaudio(filePath);
        #end
	}

    // Some docs about method signatures and examples
    // http://dev.kanngard.net/Permalinks/ID_20050509144235.html
    // https://communities.ca.com/web/ca-wily-global-user-community/wiki/-/wiki/Main/JNI+Signatures;jsessionid=499BBB87921D31A3E2803B8ED3F2FDCB.usilap723?&#p_36
    //
    // Here String doSomething(String) translates to this
    private static function initAppDirectoryPath()
    {
        if (cameramic_getappdirectorypath != null)
            return;

        #if android
        cameramic_getappdirectorypath = openfl.utils.JNI.createStaticMethod("cameramic.CameraMic", "getAppDirectoryPath", "()Ljava/lang/String;");
        #elseif ios
        cameramic_getappdirectorypath = Lib.load ("cameramic", "cameramic_getappdirectorypath", 0);
        #end
    }

    private static function initCamera()
    {
        if (cameramic_getphoto != null)
            return;

        #if android
		trace("getphoto sortzen 0");
        cameramic_getphoto = openfl.utils.JNI.createStaticMethod("org.haxe.nme.GameActivity", "getPhoto", "(Lorg/haxe/nme/HaxeObject;)V");
		trace("getphoto sortzen 1");
        #elseif ios
        cameramic_getphoto = Lib.load ("cameramic", "cameramic_getphoto", 1);
        #end
    }
    
    private static function initMic()
    {
        if (cameramic_startrecordingaudio != null && cameramic_stoprecordingaudio != null)
            return;

        #if android
        cameramic_startrecordingaudio = openfl.utils.JNI.createStaticMethod("cameramic.CameraMic", "startRecordingAudio", "(Lorg/haxe/nme/HaxeObject;)V");
        cameramic_stoprecordingaudio = openfl.utils.JNI.createStaticMethod("cameramic.CameraMic", "stopRecordingAudio", "()V");
        #elseif ios
        cameramic_startrecordingaudio = Lib.load ("cameramic", "cameramic_startrecordingaudio", 1);
        cameramic_stoprecordingaudio = Lib.load ("cameramic", "cameramic_stoprecordingaudio", 0);
        #end
    }
	
    private static function initPlayer()
    {
        //if (cameramic_playaudio != null && cameramic_stopaudio != null)
        if (cameramic_playaudio != null)
            return;

        #if android
        cameramic_playaudio = openfl.utils.JNI.createStaticMethod("cameramic.CameraMic", "playAudio", "(Ljava/lang/String;)V");
        //cameramic_stopaudio = openfl.utils.JNI.createStaticMethod("cameramic.CameraMic", "stopAudio", "()V");
        #elseif ios
        cameramic_playaudio = Lib.load ("cameramic", "cameramic_playaudio", 1);
        //cameramic_stopaudio = Lib.load ("cameramic", "cameramic_stopaudio", 0);
        #end
    }
}