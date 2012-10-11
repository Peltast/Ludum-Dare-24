package Core 
{
	import Elements.Resources.ResourceManager;
	import Elements.Species.GenerationManager;
	import Elements.Species.Organism;
	import Elements.Terrain.MapManager;
	import Elements.Terrain.Tile;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	/**
	 * ...
	 * @author Patrick McGrath
	 */
	public class Player extends Sprite
	{
		private var hostOrganism:Organism;
		private var currentAir:Number;
		
		public function Player() 
		{
			
			hostOrganism = GenerationManager.getSingleton().getNextOrganism();
			currentAir = hostOrganism.getAquaticBreath();
			this.addChild(hostOrganism);
			
			Game.getSingleton().stage.addEventListener(KeyboardEvent.KEY_DOWN, movePlayer);
			Game.getSingleton().stage.addEventListener(KeyboardEvent.KEY_UP, stopPlayer);
		}
		
		public function updatePlayer():void {
			
			if (MapManager.getSingleton().getCurrentMap() != null)
				MapManager.getSingleton().getCurrentMap().updateMap(hostOrganism);
			
			hostOrganism.updateOrganism();
			currentAir = hostOrganism.getCurrentAir();
			
			if (hostOrganism.x < 0 || hostOrganism.y < 0 || 
						hostOrganism.x > 480 - hostOrganism.getOrgCollisionSprite().width || 
						hostOrganism.y > 480 - hostOrganism.getOrgCollisionSprite().height) {
				MapManager.getSingleton().transitionMap(hostOrganism);
			}
			
			if (hostOrganism.isOrgDead()) {
				// Remove this organism and create another one at spawn point.
				this.removeChild(hostOrganism);
				GenerationManager.getSingleton().addDeadOrganism(hostOrganism);
				
				// We'll call the GA manager here for the next org's info
				hostOrganism = GenerationManager.getSingleton().getNextOrganism();
				
				this.addChild(hostOrganism);
				MapManager.getSingleton().setToStart();
				var spawnPoint:Tile = MapManager.getSingleton().getCurrentMap().getCenterTile();
				hostOrganism.x = spawnPoint.getXCoord() * 32 + 8;
				hostOrganism.y = spawnPoint.getYCoord() * 32 + 8;
				
				ResourceManager.getSingleton().generateResources(15);
			}
			
		}
		
		
		private function movePlayer(moveEvent:KeyboardEvent):void {	
			
			if (moveEvent.keyCode == 87)	// UP
				hostOrganism.setUp(true);
			if (moveEvent.keyCode == 83)	// DOWN
				hostOrganism.setDown(true);
			if (moveEvent.keyCode == 65)	// LEFT
				hostOrganism.setLeft(true);
			if (moveEvent.keyCode == 68)	// RIGHT
				hostOrganism.setRight(true);
			
			if (moveEvent.keyCode == 32)	// JUMP
				hostOrganism.setJump(true);
		}	
		
		private function stopPlayer(moveEvent:KeyboardEvent):void {
			if (moveEvent.keyCode == 87)	// UP
				hostOrganism.setUp(false);
			if (moveEvent.keyCode == 83)	// DOWN
				hostOrganism.setDown(false);
			if (moveEvent.keyCode == 65)	// LEFT
				hostOrganism.setLeft(false);
			if (moveEvent.keyCode == 68)	// RIGHT
				hostOrganism.setRight(false);
		}
		
		public function getHostOrg():Organism { return hostOrganism; }
		public function getHostLife():Number { return hostOrganism.getCurrentLife(); }
		public function getHostMaxAir():Number { return hostOrganism.getAquaticBreath(); }
		public function getHostAir():Number { return currentAir; }
		
	}

}