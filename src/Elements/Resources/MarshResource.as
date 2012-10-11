package Elements.Resources 
{
	import Elements.Species.Organism;
	import flash.display.Shape;
	/**
	 * ...
	 * @author Patrick McGrath
	 */
	public class MarshResource extends Resource
	{
		
		public function MarshResource(type:int, xCoord:int, yCoord:int) 
		{
			super(this, type, xCoord, yCoord);
			
			resourceShape.graphics.beginFill(0x96FFE0, 1);
			resourceShape.graphics.drawRect(xCoord * 32, yCoord * 32, 8, 8);
			resourceShape.graphics.endFill();
			
			this.x += Math.ceil(Math.random() * 24);
			this.y += Math.ceil(Math.random() * 24);
			resourceShape.alpha = 0;
			
			this.addChild(resourceShape);
		}
		
		override public function updateResource(org:Organism):void 
		{
			var searchRadius:Number = org.getSearchRange();
			var distance:int = Math.abs(org.x - (this.x + (32 * xCoord))) + Math.abs(org.y - (this.y+ (32 * yCoord)));
			
			if (distance < searchRadius) {
				resourceShape.alpha = 1 - (distance / searchRadius);
			}
			
		}
	}

}