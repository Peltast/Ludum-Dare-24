package Core 
{
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Patrick McGrath
	 */
	public class MenuState extends State
	{
		public var bg:Shape;
		public var playButton:TextField;
		public var instruction1:TextField;
		public var instruction2:TextField;
		
		public function MenuState() 
		{
			super(this);
			
			bg = new Shape();
			bg.graphics.beginFill(0x000000, 1);
			bg.graphics.drawRect(0, 0, 480, 480);
			bg.graphics.endFill();
			
			var titleFormat:TextFormat = new TextFormat();
			titleFormat.size = 30;
			titleFormat.bold = true;
			titleFormat.color = 0xffffff;
			titleFormat.font = "verdana";
			var quickFormat:TextFormat = new TextFormat();
			quickFormat.size = 14;
			quickFormat.bold = true;
			quickFormat.color = 0xffffff;
			quickFormat.font = "verdana";
			
			playButton = new TextField();
			playButton.defaultTextFormat = titleFormat;
			playButton.selectable = false;
			playButton.text = "CLICK HERE TO PLAY";
			playButton.border = true;
			playButton.borderColor = 0xffffff;
			playButton.x = 80;
			playButton.y = 90;
			playButton.height = 50;
			playButton.width = 380;
			
			instruction1 = new TextField();
			instruction1.selectable = false;
			instruction1.defaultTextFormat = quickFormat;
			instruction1.text = " WASD to move, SPACEBAR to jump ";
			instruction1.x = 120;
			instruction1.y = 200;
			instruction1.width = 300;
			
			instruction2 = new TextField();
			instruction2.selectable = false;
			instruction2.defaultTextFormat = quickFormat;
			instruction2.text = " R to restart game ";
			instruction2.x = 150;
			instruction2.y = 300;
			instruction2.width = 300;
			
			
			this.addChild(bg);
			this.addChild(playButton);
			this.addChild(instruction1);
			this.addChild(instruction2);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, checkPlay);
		}
		
		override public function updateState():void 
		{
			
		}
		
		public function checkPlay(mouse:MouseEvent):void {
			
			var playRect:Rectangle = new Rectangle(playButton.x, playButton.y, playButton.width, playButton.height);
			if (playRect.containsPoint(new Point(mouse.stageX, mouse.stageY))) {
				Game.popState();
				Game.pushState(new GameState());
			}
		}
		
	}

}