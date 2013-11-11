package cameramic;

import org.haxe.nme.GameActivity;
import org.haxe.nme.HaxeObject;
import org.haxe.extension.Extension;
import android.app.Activity;
import android.os.Environment;
import android.provider.MediaStore;
import android.media.MediaRecorder;
import android.media.MediaPlayer;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import java.io.IOException;
import java.io.File;

class CameraMic extends Extension
{
	static private CameraMic instance;
	
	private static final int CAMERA_PIC_REQUEST = 1337;
	static private Uri imageUri;
    static private String mFileName = null;
    static private MediaRecorder mRecorder = null;
    static private MediaPlayer mPlayer = null;
	static private HaxeObject eventHaxeHandler;
	static private boolean isRegistered;
	
    public static String getAppDirectoryPath()
    {
        return Environment.getExternalStorageDirectory() + "";
    }

    public static void takePhoto(HaxeObject eventHaxeHandler)
    {
		registerExtension();
		Log.i("josu", "takePhoto: " + eventHaxeHandler.toString());
		
		CameraMic.eventHaxeHandler = eventHaxeHandler;
		
		File p15Directory = new File(Environment.getExternalStorageDirectory() + "/images/");
		// have the object build the directory structure, if needed.
		p15Directory.mkdirs();
		// create a File object for the output file
		File file = new File(p15Directory, (java.util.Calendar.getInstance().getTimeInMillis() + ".jpg"));
		if(!file.exists())
		{
			try {
				file.createNewFile();
			} catch (java.io.IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		else
		{
			file.delete();
			try {
				file.createNewFile();
			} catch (java.io.IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		imageUri = Uri.fromFile(file);
		
		Log.i("josu", "mCapturedImageURI: " + imageUri);
		Intent i = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
		
		i.putExtra(MediaStore.EXTRA_OUTPUT, imageUri);
		GameActivity.getInstance().startActivityForResult(i, CAMERA_PIC_REQUEST);
    }
	
	@Override
	public boolean onActivityResult (int requestCode, int resultCode, Intent data)
	{
		super.onActivityResult(requestCode, resultCode, data);
		
		if (resultCode == Activity.RESULT_OK && requestCode == CAMERA_PIC_REQUEST)
		{
			Log.i("josu", "IrudiPath, path: " + imageUri.getPath());
			CameraMic.eventHaxeHandler.call1("cameraPhotoCallback", imageUri.getPath());
		}
		
		return true;
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
	
    public static void registerExtension()
	{
		if (isRegistered) return;
		
		GameActivity.getInstance().registerExtension(CameraMic.getInstance());
		isRegistered = true;
	}
	
	public static CameraMic getInstance()
	{
		if (instance == null)
			instance = new CameraMic();
		
		return instance;
	}
}