package com.mewdriller.control 
{
	import com.mewdriller.control.event.DynamicEvent;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * 
	 * 
	 * @author amiller
	 * @version 1.0
	 */
	public class Controller extends EventDispatcher
	{
		public static const MODE_DRAG_CLEAR:String = "MODE_DRAG_CLEAR";
		public static const MODE_DRAG_ADD:String = "MODE_DRAG_ADD";
		public static const CLEAR_BOARD:String = "CLEAR_BOARD";
		public static const PLAY_COLUMN:String = "PLAY_COLUMN";
		
		private static var _instance:Controller;
		
		public static function getInstance():Controller 
		{
			if (_instance == null) _instance = new Controller();
			return _instance;
		}
		
		public function Controller() 
		{
			if (_instance != null) throw new IllegalOperationError("Use Controller.getInstance() instead.");
		}
		
		public function startDragClearMode():void 
		{
			dispatchEvent(new Event(MODE_DRAG_CLEAR));
		}
		
		public function startDragAddMode():void 
		{
			dispatchEvent(new Event(MODE_DRAG_ADD));
		}
		
		public function clearBoard():void 
		{
			dispatchEvent(new Event(CLEAR_BOARD));
		}
		
		public function playColumn(col:int):void 
		{
			var e:DynamicEvent = new DynamicEvent(PLAY_COLUMN);
			e.col = col;
			dispatchEvent(e);
		}
	}
}