package android;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSave;
import flixel.math.FlxPoint;

import android.FlxVirtualPad;
import android.Hitbox;

class Config {
	var save:FlxSave;

	public function new() {
		save = new FlxSave();
		save.bind("saveconrtol");
	}

	public function getcontrolmode():Int {
		if (save.data.buttonsmode != null) 
			return save.data.buttonsmode[0];
		return 0;
	}

	public function setcontrolmode(mode:Int = 0):Int {
		if (save.data.buttonsmode == null) save.data.buttonsmode = new Array();
		save.data.buttonsmode[0] = mode;
		save.flush();

		return save.data.buttonsmode[0];
	}

	public function savecustom(_pad:FlxVirtualPad) {
		if (save.data.buttons == null)
		{
			save.data.buttons = new Array();

			for (buttons in _pad)
			{
				save.data.buttons.push(FlxPoint.get(buttons.x, buttons.y));
			}
		}
		else
		{
			var tempCount:Int = 0;
			for (buttons in _pad)
			{
				save.data.buttons[tempCount] = FlxPoint.get(buttons.x, buttons.y);
				tempCount++;
			}
		}
		save.flush();
	}

	public function loadcustom(_pad:FlxVirtualPad):FlxVirtualPad {
		if (save.data.buttons == null) 
			return _pad;
		var tempCount:Int = 0;

		for(buttons in _pad) {
			buttons.x = save.data.buttons[tempCount].x;
			buttons.y = save.data.buttons[tempCount].y;
			tempCount++;
		}	
		return _pad;
	}
}

class AndroidControls extends FlxSpriteGroup
{
	public var mode:ControlsGroup = HITBOX;

	public var _hitbox:Hitbox;
	public var _virtualPad:FlxVirtualPad;

	var config:Config;

	public function new() 
	{
		super();
		
		config = new Config();

		mode = getModeFromNumber(config.getcontrolmode());

		switch (mode)
		{
			case VIRTUALPAD_RIGHT:
				initControler(0);
			case VIRTUALPAD_LEFT:
				initControler(1);
                        case VIRTUALPAD_CUSTOM:
 				initControler(2);                               
			case DUO:
				initControler(3);
			case HITBOX:
				initControler(4);
			case KEYBOARD:
				// do nothing
		}
	}

	function initControler(vpadMode:Int) 
	{
		switch (vpadMode)
		{
			case 0:
				_virtualPad = new FlxVirtualPad(RIGHT_FULL, NONE);	
				_virtualPad.alpha = 0.75;
				add(_virtualPad);						
			case 1:
				_virtualPad = new FlxVirtualPad(FULL, NONE);
				_virtualPad.alpha = 0.75;
				add(_virtualPad);			
			case 2:
				_virtualPad = new FlxVirtualPad(FULL, NONE);
				_virtualPad = config.loadcustom(_virtualPad);
				_virtualPad.alpha = 0.75;
				add(_virtualPad);	
			case 3:
				_virtualPad = new FlxVirtualPad(DUO, NONE);
				_virtualPad.alpha = 0.75;
				add(_virtualPad);		
			case 4:
				_hitbox = new Hitbox();
				add(_hitbox);		
			default:
				_virtualPad = new FlxVirtualPad(RIGHT_FULL, NONE);	
				_virtualPad.alpha = 0.75;
				add(_virtualPad);					
		}
	}


	public static function getModeFromNumber(modeNum:Int):ControlsGroup {
		return switch (modeNum)
		{
			case 0: 
				VIRTUALPAD_RIGHT;
			case 1: 
				VIRTUALPAD_LEFT;
			case 2: 
				VIRTUALPAD_CUSTOM;
			case 3: 
				DUO;
			case 4:	
				HITBOX;
			case 5: 
				KEYBOARD;
			default: 
				VIRTUALPAD_RIGHT;
		}
	}
}

enum ControlsGroup {
	VIRTUALPAD_RIGHT;
	VIRTUALPAD_LEFT;
        VIRTUALPAD_CUSTOM;
        DUO;
	HITBOX;
	KEYBOARD;
}
