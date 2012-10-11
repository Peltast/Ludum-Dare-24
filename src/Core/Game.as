package Core 
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Patrick McGrath
	 */
	public class Game extends Sprite
	{
		private static var singleton:Game;
		
		private static var stateStack:Stack;
		
		public static function getSingleton():Game {
			if (singleton == null)
				singleton = new Game();
			return singleton;
		}
		
		
		public function Game() 
		{
			this.addEventListener(Event.ENTER_FRAME, updateGame);
		}
		
		
		public function updateGame(event:Event):void {
			
			if (stateStack == null) {
				stateStack = new Stack();
				pushState(new MenuState());
			}
			
			var currentState:State = peekState() as State;
			currentState.updateState();
			
		}
		
		
		public static function pushState(state:State):void {
			if (!stateStack.isEmpty())
				singleton.removeChild(stateStack.peek());
			stateStack.push(state);
			singleton.addChild(state);
		}
		
		public static function popState():State {
			if (stateStack.isEmpty()) return null;
			
			singleton.removeChild(stateStack.peek());
			stateStack.pop();
			
			if (stateStack.isEmpty()) return null;
			singleton.addChild(stateStack.peek());
			return stateStack.peek() as State;
		}
		
		public static function peekState():State {
			if (stateStack.isEmpty()) return null;
			
			return stateStack.peek() as State;
		}
		
	}

}