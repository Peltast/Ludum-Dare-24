package Elements.Terrain 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Patrick McGrath
	 */
	public class Tile extends Sprite
	{
		private var tileType:int;
		private var tileShape:Shape;
		private var chasm:Boolean;
		private var collidable:Boolean;
		
		private var xCoord:int;
		private var yCoord:int;
		
		public function Tile(tileType:int, xCoord:int, yCoord:int) 
		{
			this.tileType = tileType;
			this.xCoord = xCoord;
			this.yCoord = yCoord;
			chasm = false;
			collidable = false;
			
			tileShape = new Shape();
			
			if (tileType == 0){ 
				// Fill with canyon color
				tileShape.graphics.beginFill(0xBFA511, 1);
				var diRoll:int = Math.ceil(Math.random() * 10);
				if (diRoll > 7 && xCoord !=0 && xCoord !=14 && yCoord !=0 && yCoord!= 14) {
					// There is a chance that the tile will be a chasm.
					tileShape.graphics.beginFill(0x000000, 1);
					chasm = true;
				}
				
			}
			
			else if (tileType == 1){
				// Fill with jungle color
				tileShape.graphics.beginFill(0x14A817, 1);
				diRoll = Math.ceil(Math.random() * 10);
				if (diRoll > 7 && xCoord !=0 && xCoord !=14 && yCoord !=0 && yCoord!= 14) {
					// There is a chance that the tile will be impassable thick vegetation.
					tileShape.graphics.beginFill(0x0D5E0F, 1);
					collidable = true;
				}
			}
				
			else if (tileType == 2)	// Fill with desert color
				tileShape.graphics.beginFill(0xEDED9D, 1);
				
			else if (tileType == 3)	// Fill with ocean color
				tileShape.graphics.beginFill(0x1A4BBD, 1);
				
			else if (tileType == 4)	// Fill with marsh color
				tileShape.graphics.beginFill(0x3FAB8B, 1);
			
			tileShape.graphics.drawRect(xCoord * 32, yCoord * 32, 32, 32);
			tileShape.graphics.endFill();
			
			this.addChild(tileShape);
			
		}
		
		public function getXCoord():int { return xCoord; }
		public function getYCoord():int { return yCoord; }
		
		public function isChasm():Boolean { return chasm; }
		public function isCollidable():Boolean { return collidable; }
		public function getType():int { return tileType; }
		
	}

}