package Core 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Patrick McGrath
	 */
	public class State extends Sprite
	{
		private var stateName:String;
		
		public function State(state:State) 
		{
			if (state != this)
				throw new Error("State classes are meant to be used as abstract classes.");
			
		}
		
		public function updateState():void {
			
		}
		
	}

}