package Elements.Resources 
{
	import Elements.Terrain.Map;
	import Elements.Terrain.MapManager;
	import Elements.Terrain.Tile;
	/**
	 * ...
	 * @author Patrick McGrath
	 */
	public class ResourceManager 
	{
		public static var singleton:ResourceManager;
		
		public static function getSingleton():ResourceManager {
			if (singleton == null)
				singleton = new ResourceManager();
			return singleton;
		}
		
		public function ResourceManager() 
		{
			generateResources(23);
		}
		
		public function generateResources(abundance:int):void {
			
			var mapArray:Array = MapManager.getSingleton().getMaps(this);
			var newResourceArray:Array;
			
			for (var i:int = 0; i < mapArray.length; i++) {
				var tempMapRow:Array = mapArray[i];
				
				for (var j:int = 0; j < tempMapRow.length; j++) {
					var tempMap:Map = tempMapRow[j];
					
					tempMap.clearResources(this);
					newResourceArray = new Array();
					
					for (var k:int = 0; k < abundance; k++) {
						
						var e:Boolean = true;
						while (e) {
							// Get random tile from map.
							var resXCoord:int = Math.ceil(Math.random() * 15) - 1;
							var resYCoord:int = Math.ceil(Math.random() * 15) - 1;
							var homeTile:Tile = tempMap.getTile(resXCoord, resYCoord);
							
							for (var c:int = 0; c < newResourceArray.length; c++) {
								// Check to make sure a resource hasn't been placed here before, and isn't on a chasm/obstacle.
								var tempRes:Resource = newResourceArray[c] as Resource;
								if ((tempRes.getXCoord() != resXCoord || tempRes.getYCoord() != resYCoord)
									&& !homeTile.isChasm() && !homeTile.isCollidable())
									e = false;
							}
							if (newResourceArray.length == 0 && !homeTile.isChasm() && !homeTile.isCollidable()) 
								e = false;
						}
						
						if (homeTile.getType() == 0) {
							//Canyon
							tempMap.addResource(this, new CanyonResource(0, resXCoord, resYCoord));
						}
						if (homeTile.getType() == 1) {
							//Jungle
							tempMap.addResource(this, new JungleResource(1, resXCoord, resYCoord));
						}
						if (homeTile.getType() == 2) {
							//Desert
							var diRoll:int = Math.ceil(Math.random() * 10);
							if(diRoll<=3)
								tempMap.addResource(this, new DesertResource(2, resXCoord, resYCoord));
						}
						if (homeTile.getType() == 3) {
							//Ocean
							tempMap.addResource(this, new OceanResource(3, resXCoord, resYCoord));
						}
						if (homeTile.getType() == 4) {
							//Marsh
							tempMap.addResource(this, new MarshResource(4, resXCoord, resYCoord));
						}
					}
					
				}
			}
		}
		
	}

}