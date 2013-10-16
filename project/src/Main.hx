package ;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.Lib;
import sys.FileSystem;

/**
 * ...
 * @author Josu Igoa
 */

class Main extends Sprite 
{
	var inited:Bool;
	private var _cameraBtn:Btn;
	private var _recBtn:Btn;
	private var _playBtn:Btn;
	private var _stopBtn:Btn;

	private var _isRecording:Bool;
	var _audioPath:String;
	/* ENTRY POINT */
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() 
	{
		if (inited) return;
		inited = true;

		// (your code here)
		_cameraBtn = new Btn("CAMERA");
		_cameraBtn.addEventListener(Btn.CLICK, onCameraClick);
		_cameraBtn.x = (Lib.current.stage.stageWidth - _cameraBtn.width) * .5;
		_cameraBtn.y = Lib.current.stage.stageHeight * .2;
		
		_isRecording = false;
		_recBtn = new Btn("REC");
		_recBtn.addEventListener(Btn.CLICK, onRecClick);
		_recBtn.x = (Lib.current.stage.stageWidth - _recBtn.width) * .5;
		_recBtn.y = Lib.current.stage.stageHeight * .4;
		
		_stopBtn = new Btn("STOP");
		_stopBtn.addEventListener(Btn.CLICK, onStopClick);
		_stopBtn.x = (Lib.current.stage.stageWidth - _stopBtn.width) * .5;
		_stopBtn.y = Lib.current.stage.stageHeight * .6;
		
		_playBtn = new Btn("PLAY");
		_playBtn.addEventListener(Btn.CLICK, onPlayClick);
		_playBtn.x = (Lib.current.stage.stageWidth - _playBtn.width) * .5;
		_playBtn.y = Lib.current.stage.stageHeight * .8;
		_playBtn.alpha = .5;
		
		// Stage:
		// stage.stageWidth x stage.stageHeight @ stage.dpiScale
		
		// Assets:
		// nme.Assets.getBitmapData("img/assetname.jpg");
		this.addChild(_cameraBtn);
		this.addChild(_recBtn);
		this.addChild(_stopBtn);
		this.addChild(_playBtn);
	}
	
	private function onCameraClick(e:Event):Void
	{
		CameraMic.getPhoto(this, cameraPhotoCallback);
	}
	
	private function onRecClick(e:Event):Void 
	{
		CameraMic.startRecordingAudio(this, recordAudioCallback);
	}
	
	private function onStopClick(e:Event):Void 
	{
		CameraMic.stopRecordingAudio();
	}
	
	private function onPlayClick(e:Event):Void 
	{
		CameraMic.playAudio(_audioPath);
	}
	
	public function cameraPhotoCallback(photoPath:String, ?remove):Void
	{
		var input:BitmapData = BitmapData.load(photoPath);

		if (input.width > 0)
		{
			var output:BitmapData = new BitmapData(Std.int(this.width * .95), Std.int(this.height * .7 * .9), true, 0x0000000);
			var scaleFactorX:Float = output.width / input.width;
			var scaleFactorY:Float = output.height / input.height;
			var matrix:Matrix = new Matrix();
			matrix.scale(scaleFactorX, scaleFactorY);
			output.draw(input, matrix, null, null, null, true);
			var bitmap:Bitmap = new Bitmap(output);
			addChild(bitmap);
		}
	}

	public function recordAudioCallback(audioPath:String, ?remove):Void
	{
		_audioPath = audioPath;
		
		if (_audioPath != null && FileSystem.exists(_audioPath))
		{
			_playBtn.alpha = 1;
			if(!_playBtn.hasEventListener(Btn.CLICK))
				_playBtn.addEventListener(Btn.CLICK, onPlayClick);
		}
		else
		{
			_playBtn.alpha = .5;
			if(_playBtn.hasEventListener(Btn.CLICK))
				_playBtn.removeEventListener(Btn.CLICK, onPlayClick);
		}
	}

	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
