package Elements.Resources 
{
	import Elements.Species.Organism;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Patrick McGrath
	 */
	public class Resource extends Sprite
	{
		private var type:int;
		protected var xCoord:int;
		protected var yCoord:int;
		protected var resourceShape:Shape;
		
		public function Resource(resource:Resource, type:int, xCoord:int, yCoord:int) 
		{
			if (resource != this) throw new Error("Resource is meant to be used as an abstract class.");
			this.type = type;
			this.xCoord = xCoord;
			this.yCoord = yCoord;
			resourceShape = new Shape();
			
		}
		
		public function updateResource(org:Organism):void {
			
		}
		
		public function getType():int { return type; }
		public function getXCoord():int { return xCoord; }
		public function getYCoord():int { return yCoord; }
		
	}

}