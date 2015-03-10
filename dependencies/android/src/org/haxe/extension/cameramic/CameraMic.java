package org.haxe.extension.cameramic;

import android.app.Activity;
import android.content.res.AssetManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.os.Environment;
import android.provider.MediaStore;
import android.media.MediaRecorder;
import android.media.MediaPlayer;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import java.io.IOException;
import java.io.File;
import org.haxe.lime.HaxeObject;
import org.haxe.extension.Extension;


/* 
	You can use the Android Extension class in order to hook
	into the Android activity lifecycle. This is not required
	for standard Java code, this is designed for when you need
	deeper integration.
	
	You can access additional references from the Extension class,
	depending on your needs:
	
	- Extension.assetManager (android.content.res.AssetManager)
	- Extension.callbackHandler (android.os.Handler)
	- Extension.mainActivity (android.app.Activity)
	- Extension.mainContext (android.content.Context)
	- Extension.mainView (android.view.View)
	
	You can also make references to static or instance methods
	and properties on Java classes. These classes can be included 
	as single files using <java path="to/File.java" /> within your
	project, or use the full Android Library Project format (such
	as this example) in order to include your own AndroidManifest
	data, additional dependencies, etc.
	
	These are also optional, though this example shows a static
	function for performing a single task, like returning a value
	back to Haxe from Java.
*/
public class CameraMic extends Extension
{
	static private CameraMic instance;
	
	private static final int CAMERA_PIC_REQUEST = 1337;
	static private Uri imageUri;
    static private String mAudioFile = null;
    static private MediaRecorder mRecorder = null;
    static private MediaPlayer mPlayer = null;
	static private HaxeObject haxeObject;
	static private boolean isRegistered;
	static private String appFilesDirectory = "";
	private static String getAppDirectory()
	{
		if(appFilesDirectory == "")
			setAppDirectory("");
		
		return appFilesDirectory;
	}
	
    public static String setAppDirectory(String subdir)
    {
		appFilesDirectory = Environment.getExternalStorageDirectory() + subdir;
		File f = new File(appFilesDirectory);
		if(!f.isDirectory())
			f.mkdirs();
		
		return appFilesDirectory;
    }

    public static void takePhoto(HaxeObject eventHaxeHandler)
    {
		Log.i("josu", "takePhoto: " + eventHaxeHandler.toString());
		
		CameraMic.haxeObject = eventHaxeHandler;
		
		File p15Directory = new File(CameraMic.getAppDirectory() + "/images/");
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
		Extension.mainActivity.startActivityForResult(i, CAMERA_PIC_REQUEST);
    }
	
	
	/**
	 * Called when an activity you launched exits, giving you the requestCode 
	 * you started it with, the resultCode it returned, and any additional data 
	 * from it.
	 */
	public boolean onActivityResult (int requestCode, int resultCode, Intent data)
	{
		super.onActivityResult(requestCode, resultCode, data);
		
		if (resultCode == Activity.RESULT_OK && requestCode == CAMERA_PIC_REQUEST)
		{
			Log.i("josu", "IrudiPath, path: " + imageUri.getPath());
			CameraMic.haxeObject.call1("cameraPhotoCallback", imageUri.getPath());
		}
		
		return true;
	}
	

	public static void startRecordingAudio(HaxeObject eventHaxeHandler, boolean removeLastRecording)
    {
		CameraMic.haxeObject = eventHaxeHandler;
		
		File audioDirectory = new File(CameraMic.getAppDirectory() + "/audios/");
		// have the object build the directory structure, if needed.
		audioDirectory.mkdirs();

        
        mRecorder = new MediaRecorder();
        mRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
        mRecorder.setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP);

        if (removeLastRecording && mAudioFile != null)
        {
        	File audioFile = new File(Extension.mainContext , mAudioFile);
			if (audioFile.exists())
			{
				if (audioFile.delete())
					Log.i('CameraMic', '"' + mAudioFile + '" file correctly deleted.');
				else
					Log.i('CameraMic', 'Couldn\'t delete the file "mAudioFile"');
			}
		}

        mAudioFile = audioDirectory.getPath() + "/" + java.util.Calendar.getInstance().getTimeInMillis() + ".3gp";
        
        mRecorder.setOutputFile(mAudioFile);
        mRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);
		
        try {
            mRecorder.prepare();
        } catch (IOException e) {
            Log.e("CameraMic", "prepare() failed: " + e);
        }
		
        mRecorder.start();
    }

    public static void stopRecordingAudio()
    {
        mRecorder.stop();
        mRecorder.release();
        mRecorder = null;
		
		CameraMic.haxeObject.call1("recordAudioCallback", mAudioFile);
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
            Log.e("CameraMic", "prepare() failed: " + e);
        }
	}
	
    public static void stopAudio()
	{
		mPlayer.release();
        mPlayer = null;
	}

	public static CameraMic getInstance()
	{
		if (instance == null)
			instance = new CameraMic();
		
		return instance;
	}
}