package Core 
{
	import Elements.Resources.ResourceManager;
	import Elements.Species.GenerationManager;
	import Elements.Terrain.MapManager;
	import Elements.Terrain.Tile;
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Patrick McGrath
	 */
	 
	 
	public class GameState extends State
	{
		
		
		private var mapManager:MapManager
		private var resourceManager:ResourceManager;
		private var generationManager:GenerationManager;
		private var player:Player;
		
		private var lifeDisplay:Shape;
		private var airDisplay:Shape;
		private var orgDisplay:TextField;
		private var genDisplay:TextField;
		
		public function GameState() 
		{
			super(this);
			
			mapManager = MapManager.getSingleton();
			resourceManager = ResourceManager.getSingleton();
			generationManager = GenerationManager.getSingleton();
			player = new Player();
			lifeDisplay = new Shape();
			airDisplay = new Shape();
			
			var centerTile:Tile = mapManager.getCurrentMap().getCenterTile();
			player.getHostOrg().x = centerTile.getXCoord() * 32 + 8;
			player.getHostOrg().y = centerTile.getYCoord() * 32 + 8;
			
			lifeDisplay.graphics.beginFill(0xffffff, 1);
			lifeDisplay.graphics.drawRect(0, 0, 1, 1);
			lifeDisplay.graphics.endFill();
			airDisplay.graphics.beginFill(0x00FFFF, 1);
			airDisplay.graphics.drawRect(0, 0, 1, 1);
			airDisplay.graphics.endFill();
			airDisplay.visible = false;
			
			var quickFormat:TextFormat = new TextFormat();
			quickFormat.size = 14;
			quickFormat.bold = true;
			quickFormat.color = 0x000000;
			quickFormat.font = "verdana";
			
			orgDisplay = new TextField();
			orgDisplay.defaultTextFormat = quickFormat;
			orgDisplay.x = 370;
			orgDisplay.y = 10;
			orgDisplay.selectable = false;
			genDisplay = new TextField();
			genDisplay.defaultTextFormat = quickFormat;
			genDisplay.x = 330;
			genDisplay.selectable = false;
			genDisplay.y = 30;
			genDisplay.width += 60;
			
			
			this.addChild(mapManager);
			this.addChild(player);
			this.addChild(lifeDisplay);
			this.addChild(airDisplay);
			this.addChild(orgDisplay);
			this.addChild(genDisplay);
			
			Game.getSingleton().stage.addEventListener(KeyboardEvent.KEY_UP, checkRestart);

		}
		
		public function checkRestart(key:KeyboardEvent):void {
			
			if (key.keyCode == 82) {
				Game.popState();
				MapManager.singleton = null;
				ResourceManager.singleton = null;
				GenerationManager.singleton = null;
				Game.pushState(new GameState());
			}
		}
		
		public override function updateState():void {
			player.updatePlayer();
			
			
			orgDisplay.text = "Number " + GenerationManager.getSingleton().organismCount;
			genDisplay.text = "of Generation #" + GenerationManager.getSingleton().generationCount;
			
			lifeDisplay.width = player.getHostLife() / 5;
			lifeDisplay.x = 240 - (lifeDisplay.width / 2);
			lifeDisplay.y = 10;
			lifeDisplay.height = 30;
			
			airDisplay.width = player.getHostAir() / 5;
			airDisplay.x = 240 - (airDisplay.width / 2);
			airDisplay.y = 50;
			airDisplay.height = 20;
			if (player.getHostAir() < player.getHostMaxAir()) 
				airDisplay.visible = true;
			else airDisplay.visible = false;
		}
		
	}

}