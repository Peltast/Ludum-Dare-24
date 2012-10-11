package Elements.Terrain 
{
	import Elements.Resources.Resource;
	import Elements.Species.Organism;
	import flash.display.Shape;
	import flash.display.Sprite;
	import Elements.Resources.ResourceManager;
	import flash.display.TriangleCulling;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Patrick McGrath
	 */
	public class Map extends Sprite
	{
		private var tileArray:Array;
		private var resourceArray:Array;
		
		public function Map(mapSize:int, environNo:int, canyon:int, jungle:int, desert:int, ocean:int, marsh:int) 
		{
			tileArray = new Array();
			resourceArray = new Array();
			
			
			// Create randomly generated environment centers.
			
			var environmentArray:Array = new Array;
			
			// Create roulette values.
			var canyonRoulette:int = canyon;
			var jungleRoulette:int = canyon + jungle;
			var desertRoulette:int = desert + jungle + canyon;
			var oceanRoulette:int = ocean + desert + jungle + canyon;
			var marshRoulette:int = 0; // not used until later
			
			for (var e:int = 0; e < environNo; e++) {
				
				var roulleteSpin:int = Math.ceil(Math.random() * 100);
				
				while (true) {
					// Randomly generate environment center position.
					var envXCoord:int = Math.ceil(Math.random() * 15) - 1;
					var envYCoord:int = Math.ceil(Math.random() * 15) - 1;
					
					// Iterate through previously generated environment centers.  If they're too close,
					// the while loop will fire again, generating a new position.
					var smallestDistance:int = int.MAX_VALUE;
					for (var c:int = 0; c < environmentArray.length; c++) {
						var tempEnv:EnvironmentNode = environmentArray[c] as EnvironmentNode;
						var distance:int = Math.abs(tempEnv.xCoord - envXCoord) + Math.abs(tempEnv.yCoord - envYCoord);
						
						if (smallestDistance > distance) smallestDistance = distance;
					}
					if (smallestDistance > 3) 
						break;
				}
				
				var newEnvironment:EnvironmentNode = new EnvironmentNode();
				newEnvironment.xCoord = envXCoord;
				newEnvironment.yCoord = envYCoord;
				
				if (roulleteSpin < canyonRoulette) {
					// We spun a canyon environment.
					newEnvironment.envType = 0;
					newEnvironment.radius = 4;
				}
				else if (roulleteSpin >= canyonRoulette && roulleteSpin < jungleRoulette) {
					// We spun a jungle environment.
					newEnvironment.envType = 1;
					newEnvironment.radius = 4;
				}
				else if (roulleteSpin >= jungleRoulette && roulleteSpin < desertRoulette) {
					// We spun a desert environment.
					newEnvironment.envType = 2;
					newEnvironment.radius = 6;
				}
				else if (roulleteSpin >= desertRoulette && roulleteSpin < oceanRoulette) {
					// We spun an ocean environment.
					newEnvironment.envType = 3;
					newEnvironment.radius = 7;
				}
				else if (roulleteSpin >= oceanRoulette) {
					// We spun a marsh environment.
					newEnvironment.envType = 4;
					newEnvironment.radius = 3;
				}
				
				environmentArray.push(newEnvironment);
			}
			
			
			
			// Generate tiles.
			
			for (var i:int = 0; i < mapSize; i++) {
				
				var tileRow:Array = new Array();
				for (var j:int = 0; j < mapSize; j++) {
					
					
					// Here's where the magic happens; we need to decide what terrain type the tile is going to be.
					var newTile:Tile;
					
					// Reset roulette values.
					canyonRoulette = 0;
					jungleRoulette = 0;
					desertRoulette = 0;
					oceanRoulette = 0;
					marshRoulette = 0;
					
					// Loop through all environments
					for (var k:int = 0; k < environmentArray.length; k++) {
						
						var tempEnvironment:EnvironmentNode = environmentArray[k] as EnvironmentNode;
						distance = Math.abs(tempEnvironment.xCoord - j) + Math.abs(tempEnvironment.yCoord - i);
						
						// If the tile is within this environment's radius...
						if (distance <= tempEnvironment.radius) {
							if (tempEnvironment.envType == 0) canyonRoulette = canyon;
							if (tempEnvironment.envType == 1) jungleRoulette = jungle;
							if (tempEnvironment.envType == 2) desertRoulette = desert;
							if (tempEnvironment.envType == 3) oceanRoulette = ocean;
							if (tempEnvironment.envType == 4) marshRoulette = marsh;
						}
					}
					jungleRoulette = jungleRoulette + canyonRoulette;
					desertRoulette = desertRoulette + jungleRoulette;
					oceanRoulette = oceanRoulette + desertRoulette;
					marshRoulette = marshRoulette + oceanRoulette;
					
					roulleteSpin = Math.ceil(Math.random() * marshRoulette);
					
					if (roulleteSpin < canyonRoulette) 
						newTile = new Tile(0, j, i);
					else if (roulleteSpin >= canyonRoulette && roulleteSpin <= jungleRoulette) 
						newTile = new Tile(1, j, i);
					else if (roulleteSpin > jungleRoulette && roulleteSpin <= desertRoulette)
						newTile = new Tile(2, j, i);
					else if (roulleteSpin > desertRoulette && roulleteSpin <= oceanRoulette)
						newTile = new Tile(3, j, i);
					else if (roulleteSpin > oceanRoulette)
						newTile = new Tile(4, j, i);
					
					tileRow.push(newTile);
					this.addChild(newTile);
				}
				
				tileArray.push(tileRow);
			}
		}
		
		
		
		public function updateMap(org:Organism):void {
			
			for (var r:int = 0; r < resourceArray.length; r++) {
				resourceArray[r].updateResource(org);
			}
			
		}
		
		
		public function getCollidingTilesRes(res:Resource):Array {
			
			var collidingTiles:Array = new Array();
			var resRectangle:Rectangle = new Rectangle(res.x + res.getXCoord() * 32, res.y + res.getYCoord() * 32, 8, 8);
			
			for (var y:int = 0; y < tileArray.length; y++) {
				var tempRow:Array = tileArray[y];
				for (var x:int = 0; x < tempRow.length; x++) {
					var tempTile:Tile = tileArray[y][x];
					var tileRect:Rectangle = new Rectangle(x * 32, y * 32, 32, 32);
					
					if (tileRect.intersects(resRectangle))
						collidingTiles.push(tempTile);
				}
			}
			return collidingTiles;
		}
		public function getCollidingTiles(org:Organism):Array {
			
			var collidingTiles:Array = new Array();
			var orgColSprite:Sprite = org.getOrgCollisionSprite();
			
			for (var i:int = 0; i < orgColSprite.numChildren; i++) {
				var tempShape:Shape = orgColSprite.getChildAt(i) as Shape;
				
				for (var y:int = 0; y < tileArray.length; y++) {
					var tempRow:Array = tileArray[y];
					for (var x:int = 0; x < tempRow.length; x++) {
						var tempTile:Tile = tileArray[y][x];
						var tileRect:Rectangle = new Rectangle(x * 32, y * 32, 32, 32);
						
						if (tileRect.intersects(new Rectangle
								(org.x + tempShape.x, org.y + tempShape.y, tempShape.width, tempShape.height)))
							collidingTiles.push(tempTile);
					}
				}
			}
			return collidingTiles;
		}
		public function getCollidingResources(org:Organism):Array {
			
			var collidingRes:Array = new Array();
			var orgColSprite:Sprite = org.getOrgCollisionSprite();
			
			for (var i:int = 0; i < orgColSprite.numChildren; i++) {
				var tempShape:Shape = orgColSprite.getChildAt(i) as Shape;
				
				for (var y:int = 0; y < resourceArray.length; y++) {
					var tempRes:Resource = resourceArray[y] as Resource;
					var resRect:Rectangle = new Rectangle
						(tempRes.getXCoord() * 32 + tempRes.x, tempRes.getYCoord() * 32 + tempRes.y, 8, 8);
					if (resRect.intersects(new Rectangle
							(org.x + tempShape.x, org.y + tempShape.y, tempShape.width, tempShape.height)))
						collidingRes.push(tempRes);
				}
			}
			return collidingRes;
		}
		
		
		public function getTile(xCoord:int, yCoord:int):Tile {
			return tileArray[yCoord][xCoord];
		}
		
		public function getCenterTile():Tile {
			var centerX:int = 7;
			var centerY:int = 7;
			
			while (true) {
				if (!tileArray[centerY][centerX].isCollidable() 
						&& !tileArray[centerY][centerX].isChasm() 
						&& tileArray[centerY][centerX].getType()!= 3)
					return tileArray[centerY][centerX];
				
				centerX++;
				if (centerX >= 15) {
					centerX = 6;
					centerY++;
				}
				if (centerY >= 15) {
					centerY = 1;
					centerX = 1;
				}
			}
			return null;
		}
		
		
		public function removeResource(oldResource:Resource):void {
			resourceArray.splice(resourceArray.indexOf(oldResource), 1);
			this.removeChild(oldResource);
		}
		public function addResource(resManager:ResourceManager, newResource:Resource):void { 
			resourceArray.push(newResource);
			this.addChild(newResource);
		}
		public function clearResources(resManager:ResourceManager):void {
			for (var i:int = 0; i < resourceArray.length; i++) {
				this.removeChild(resourceArray[i]);
			}
			resourceArray = new Array();
		}
		
	}

}

class EnvironmentNode {
	
	public var envType:int;
	public var radius:int;
	public var xCoord:int;
	public var yCoord:int;
	
}