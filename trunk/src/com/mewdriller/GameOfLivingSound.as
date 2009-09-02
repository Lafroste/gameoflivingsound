package com.mewdriller
{
	import com.bit101.components.PushButton;
	import com.mewdriller.control.Controller;
	import com.mewdriller.view.SoundSquare;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * 
	 * 
	 * @author amiller
	 * @version 1.0
	 */
	public final class GameOfLivingSound extends Sprite 
	{
		public static const BOARD_SIZE:int = 16;
		
		private var _controller:Controller = Controller.getInstance();
		private var _beat:Timer = new Timer(msPerSquare);
		
		/**
		 * Number of ms between beats.
		 */
		public static function get msPerSquare():Number { return 2000 / BOARD_SIZE; }
		
		public var clearButton:PushButton;
		public var playButton:PushButton;
		public var stopButton:PushButton;
		
		public function GameOfLivingSound():void 
		{
			if (stage) onAddedToStage();
			else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			drawSquares();
			addButtons();
			
			_beat.addEventListener(TimerEvent.TIMER, onBeatTick, false, 0, true);
		}
		
		private function onBeatTick(e:TimerEvent):void 
		{
			// Play the appropriate column of tones.
			_controller.playColumn((_beat.currentCount - 1) % 16);
		}
		
		private function addButtons():void 
		{
			// Add the clear, play, and stop buttons:
			
			playButton = new PushButton(this, 0, 0, "Play", onPlayClick);
			stopButton = new PushButton(this, playButton.getBounds(this).right + 10, 0, "Stop", onStopClick);
			clearButton = new PushButton(this, stopButton.getBounds(this).right + 10, 0, "Clear", onClearClick);
		}
		
		private function onPlayClick(e:MouseEvent):void 
		{
			_beat.start();
		}
		
		private function onStopClick(e:MouseEvent):void 
		{
			_beat.reset();
		}
		
		private function onClearClick(e:MouseEvent):void 
		{
			_controller.clearBoard();
		}
		
		private function drawSquares():void 
		{
			var square:SoundSquare, i:int, ii:int;
			
			for (i = 0; i < BOARD_SIZE; i++) 
			{
				for (ii = 0; ii < BOARD_SIZE; ii++) 
				{
					square = new SoundSquare(i, ii);					
					square.x = SoundSquare.SIZE * ii;
					square.y = SoundSquare.SIZE * i + SoundSquare.SIZE + 10;
					addChild(square);
				}
			}
		}
	}
}