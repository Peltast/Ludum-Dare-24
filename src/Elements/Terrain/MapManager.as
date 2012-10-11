package Elements.Terrain 
{
	import Elements.Resources.ResourceManager;
	import Elements.Species.Organism;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Patrick McGrath
	 */
	public class MapManager extends Sprite
	{
		
		public static var singleton:MapManager;
		
		private var worldSize:int;
		private var mapArray:Array;
		private var currentMap:Map;
		
		private var canyonDensity:int = -1;
		private var jungleDensity:int = -1;
		private var desertDensity:int = -1;
		private var oceanDensity:int = -1;
		private var marshDensity:int = -1;
		
		public static function getSingleton():MapManager {
			if (singleton == null)
				singleton = new MapManager();
			return singleton;
		}
		public function MapManager() 
		{
			mapArray = new Array();
			currentMap = null;
			worldSize = 9;
			var mapSize:int = 15;
			
			// Initiate random variables for world generation.
			
			var percentageRemainder:int = 100;
			
			while (true){
			
				var diRoll:int = Math.ceil(Math.random() * 5) - 1;
				
				if (diRoll == 0 && canyonDensity < 0){
					canyonDensity = Math.ceil(Math.random() * percentageRemainder);
					percentageRemainder -= canyonDensity;
				}
				if (diRoll == 1 && jungleDensity < 0) {
					jungleDensity = Math.ceil(Math.random() * percentageRemainder);
					percentageRemainder -= jungleDensity;
				}
				if (diRoll == 2 && desertDensity < 0) {
					desertDensity = Math.ceil(Math.random() * percentageRemainder);
					percentageRemainder -= desertDensity;
				}
				if (diRoll == 3 && oceanDensity < 0) {
					oceanDensity = Math.ceil(Math.random() * percentageRemainder);
					percentageRemainder -= oceanDensity;
				}
				if (diRoll == 4 && marshDensity < 0) {
					marshDensity = Math.ceil(Math.random() * percentageRemainder);
					percentageRemainder -= marshDensity;
				}
				
				if (canyonDensity >= 0 && jungleDensity >= 0 && desertDensity >= 0 && oceanDensity >= 0 && marshDensity >= 0)
					break;
			}
			
			// Generate maps.
			for (var i:int = 0; i < worldSize; i++) {
				
				var mapRow:Array = new Array();
				
				for (var j:int = 0; j < worldSize; j++) {
					var tempMap:Map = new Map(mapSize, 5, canyonDensity, jungleDensity, desertDensity, oceanDensity, marshDensity);
					mapRow.push(tempMap);
				}
				
				mapArray.push(mapRow);
			}
			
			currentMap = mapArray[4][4];
			this.addChild(currentMap);
		}
		
		public function transitionMap(org:Organism):void {
			
			var newMap:Map;
			
			for (var i:int = 0; i < mapArray.length; i++) {
				for (var j:int = 0; j < mapArray[i].length; j++) {
					
					if (mapArray[i][j] == currentMap) {
						
						if (org.x < 0) {
							if (j != 0) { 
								newMap = mapArray[i][j - 1];
								org.x = 480 - org.getOrgCollisionSprite().width;
							}
							else org.setStop(true);
						}
						else if (org.y < 0) {
							if (i != 0) {
								newMap = mapArray[i - 1][j];
								org.y = 480 - org.getOrgCollisionSprite().height;
							}
							else org.setStop(true);
						}
						else if (org.x > 450) {
							if (j < worldSize-1) {
								newMap = mapArray[i][j + 1];
								org.x = 10;
							}
							else org.setStop(true);
						}
						else if (org.y > 450) {
							if (i < worldSize-1) {
								newMap = mapArray[i + 1][j];
								org.y = 10;
							}
							else org.setStop(true);
						}
					}
					
				}
			}
			
			if (newMap == null) return;
			else {
				this.removeChild(currentMap);
				currentMap = newMap;
				this.addChild(currentMap);
			}
		}
		
		public function setToStart():void {
			this.removeChild(currentMap);
			currentMap = mapArray[4][4];
			this.addChild(currentMap);
		}
		
		public function getCurrentMap():Map { return currentMap;}
		
		public function getMaps(resManager:ResourceManager):Array { return mapArray;}
		
	}

}