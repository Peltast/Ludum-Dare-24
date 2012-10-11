package Elements.Resources 
{
	import Elements.Species.Organism;
	import flash.display.Shape;
	/**
	 * ...
	 * @author Patrick McGrath
	 */
	public class DesertResource extends Resource
	{
		
		public function DesertResource(type:int, xCoord:int, yCoord:int ) 
		{
			super(this, type, xCoord, yCoord);
			
			resourceShape.graphics.beginFill(0xC4B029, 1);
			resourceShape.graphics.drawRect(xCoord * 32, yCoord * 32, 8, 8);
			resourceShape.graphics.endFill();
			
			this.x += Math.ceil(Math.random() * 24);
			this.y += Math.ceil(Math.random() * 24);
			
			this.addChild(resourceShape);
		}
		
		override public function updateResource(org:Organism):void 
		{
			
		}
	}

}