package com.mewdriller.sound 
{
	import com.noteflight.standingwave2.elements.AudioDescriptor;
	import com.noteflight.standingwave2.elements.IAudioSource;
	import com.noteflight.standingwave2.filters.EnvelopeFilter;
	import com.noteflight.standingwave2.sources.SineSource;
	import com.noteflight.standingwave2.utils.AudioUtils;
	import flash.errors.IllegalOperationError;
	
	/**
	 * Singleton manager for the tones used within the Game of Living Sound.
	 * 
	 * @author amiller
	 * @version 1.0
	 */
	public class ToneManager 
	{
		private static var _instance:ToneManager;
		
		/**
		 * Gets a reference to the singleton ToneManager.
		 * @return	The singleton reference to the ToneManager.
		 */
		public static function getInstance():ToneManager 
		{
			if (_instance == null) _instance = new ToneManager();
			return _instance;
		}
		
		/**
		 * Converts a given note number to it's equivalent frequency.
		 * @param	note	The note number to convert.
		 * @return	The equivalent frequency of the given note number.
		 */
		public static function noteToFrequency(note:uint):Number
		{
			if (note > 127) note = 127;
			return 440 * Math.pow(2, (note - 69) / 12);
		}
		
		private const ATTACK_TIME:Number = 0.02;
		private const DECAY_TIME:Number = 0.00;
		private const SUSTAIN:Number = 1.00;
		private const HOLD_TIME:Number = 0.10;
		private const RELEASE_TIME:Number = 0.10;
		
		private var _notes:Array = [92, 90, 88, 85, 83, 81, 78, 76, 74, 71, 69, 67, 64, 62, 60, 57];		
		private var _tones:Vector.<IAudioSource> = new Vector.<IAudioSource>();
		
		/**
		 * Constructs a ToneManager.
		 * @private
		 */
		public function ToneManager() 
		{
			if (_instance != null) 
				throw new IllegalOperationError("Use ToneManager.getInstance() instead.");
			else
				initialize();
		}
		
		/**
		 * Initializes the ToneManager, caches the tones used in the app.
		 * @private
		 */
		private function initialize():void 
		{
			var i:int, check:int = _notes.length, source:IAudioSource, ad:AudioDescriptor = new AudioDescriptor();
			
			// For each tone of the board:
			for (i = 0; i < check; i++) 
			{
				// Create the sine tone from this note.
				source = new SineSource(ad, 1, noteToFrequency(_notes[i]));
				
				// Wrap the sine tone in an ADSR envelope.
				source = new EnvelopeFilter(source, ATTACK_TIME, DECAY_TIME, SUSTAIN, HOLD_TIME, RELEASE_TIME);
				
				// Cache the tones used in the matrix.
				_tones[i] = source;
			}
		}
		
		/**
		 * Gets the appropriate tone for a given row.
		 * @param	row	The number (0-16) of the row.
		 * @return	The ADSR enveloped sine tone for the given row.
		 */
		public function getToneByRow(row:int):IAudioSource 
		{
			return _tones[row].clone();
		}
		
	}
	
}