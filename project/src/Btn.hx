package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;

/**
 * ...
 * @author Josu
 */

class Btn extends Sprite
{
	private var _textField:TextField;
	private var _background:Sprite;
	private var X_MARGIN:Int;
	private var Y_MARGIN:Int;
	static public var CLICK:String = "btnClick";
	
	public function new(testuParam:String) 
	{
		super();
		
		X_MARGIN = 10;
		Y_MARGIN = 10;
		
		_textField = new TextField();
		_textField.autoSize = TextFieldAutoSize.LEFT;
		_textField.defaultTextFormat = new TextFormat("arial", 20);
		_textField.text = testuParam;
		_textField.x = X_MARGIN;
		_textField.y = Y_MARGIN;
		_textField.mouseEnabled = _textField.selectable = false;
		
		#if flash
		_textField.mouseWheelEnabled = false;
		#end
		
		_background = new Sprite();
		drawBackground(0xAA0000);
		
		_background.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
		this.addChild(_background);
		this.addChild(_textField);
	}
	
	function drawBackground(col:Int):Void 
	{
		_background.graphics.clear();
		_background.graphics.beginFill(col);
		_background.graphics.drawRect(0, 0, _textField.width + X_MARGIN * 2, _textField.height + Y_MARGIN * 2);
		_background.cacheAsBitmap = true;
	}
	
	private function onTouchBegin(e:TouchEvent):Void
	{
		drawBackground(0x00AA00);
		_background.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
		_background.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
	}

	public function setText(str:String):Void
	{
		_textField.text = str;
	}
	
	private function onTouchEnd(me:TouchEvent):Void 
	{
		drawBackground(0xAA0000);
		_background.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
		_background.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		
		if (this.hasEventListener(Btn.CLICK))
			this.dispatchEvent(new Event(Btn.CLICK));
	}
}