package Elements.Resources 
{
	import Elements.Species.Organism;
	import Elements.Terrain.MapManager;
	import Elements.Terrain.Tile;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Patrick McGrath
	 */
	public class JungleResource extends Resource
	{
		
		public function JungleResource(type:int, xCoord:int, yCoord:int) 
		{
			super(this, type, xCoord, yCoord);
			
			resourceShape.graphics.beginFill(0x1CFF21, 1);
			resourceShape.graphics.drawRect(xCoord * 32, yCoord * 32, 8, 8);
			resourceShape.graphics.endFill();
			
			this.x += Math.ceil(Math.random() * 24);
			this.y += Math.ceil(Math.random() * 24);
			
			this.addChild(resourceShape);
		}
		
		override public function updateResource(org:Organism):void 
		{
			var currentX:int = (xCoord * 32) + this.x;
			var currentY:int = (yCoord * 32) + this.y;
			var distance:int = Math.abs(org.x - currentX) + Math.abs(org.y - currentY);
			
			if (distance < 100) {
				
				var xSpeed:Number = 0;
				var ySpeed:Number = 0;
				
				if (org.x > currentX)
					xSpeed -= .5;
				else if (org.x < currentX)
					xSpeed += .5;
					
				if (org.y > currentY)
					ySpeed -= .5;
				else if (org.y > currentY)
					ySpeed += .5;
					
				this.x += xSpeed;
				this.y += ySpeed;
				var collidingTiles:Array = MapManager.getSingleton().getCurrentMap().getCollidingTilesRes(this);
				
				for (var i:int = 0; i < collidingTiles.length; i++) {
					if (collidingTiles[i].isCollidable() || collidingTiles[i].isChasm() || collidingTiles[i].getType() == 3) {
						this.x -= xSpeed;
						if (isColliding(collidingTiles[i])) {
							this.x += xSpeed;
							this.y -= ySpeed;
							if (isColliding(collidingTiles[i])) {
								this.x -= xSpeed;
							}
						}
					}
				}
			}
		}
		
		
		private function isColliding(tile:Tile):Boolean {
			var tileRect:Rectangle = new Rectangle(tile.getXCoord() * 32, tile.getYCoord() * 32, 32, 32);
			var resRectangle:Rectangle = new Rectangle(this.x + yCoord * 32, this.y + yCoord * 32, 8, 8);
			
			if (tileRect.intersects(resRectangle))
				return true;
			return false;
		}
		
	}
	

}