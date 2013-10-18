package cameramic;

import org.haxe.nme.GameActivity;
import org.haxe.nme.HaxeObject;
import android.app.Activity;
import android.os.Environment;
import android.provider.MediaStore;
import android.media.MediaRecorder;
import android.media.MediaPlayer;
import android.net.Uri;
import android.util.Log;
import java.io.IOException;
import java.io.File;

class CameraMic extends Activity
{
    static private String mFileName = null;
    static private MediaRecorder mRecorder = null;
    static private MediaPlayer mPlayer = null;
	static private HaxeObject eventHaxeHandler;
	
    public static String getAppDirectoryPath()
    {
        return Environment.getExternalStorageDirectory() + "";
    }

	public static void startRecordingAudio(HaxeObject eventHaxeHandler)
    {
		CameraMic.eventHaxeHandler = eventHaxeHandler;
		
		File audioDirectory = new File(CameraMic.getAppDirectoryPath() + "/audios/");
		// have the object build the directory structure, if needed.
		audioDirectory.mkdirs();

        
        mRecorder = new MediaRecorder();
        mRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
        mRecorder.setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP);

        mFileName = audioDirectory.getPath() + "/" + java.util.Calendar.getInstance().getTimeInMillis() + ".3gp";
        
        mRecorder.setOutputFile(mFileName);
        mRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);
		
        try {
            mRecorder.prepare();
        } catch (IOException e) {
            Log.e("josu", "prepare() failed");
        }
		
        mRecorder.start();
    }

    public static void stopRecordingAudio()
    {
        mRecorder.stop();
        mRecorder.release();
        mRecorder = null;
		
		CameraMic.eventHaxeHandler.call1("recordAudioCallback", mFileName);
    }
	
    public static void playAudio(String filePath)
	{
		mPlayer = new MediaPlayer();
        try
		{
            mPlayer.setDataSource(filePath);
            mPlayer.prepare();
            mPlayer.start();
        } catch (IOException e) {
            Log.e("josu", "prepare() failed");
        }
	}
	
    public static void stopAudio()
	{
		mPlayer.release();
        mPlayer = null;
	}
}