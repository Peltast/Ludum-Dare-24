package Elements.Species 
{
	import Elements.Terrain.MapManager;
	import Elements.Terrain.Tile;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	/**
	 * ...
	 * @author Patrick McGrath
	 */
	public class Organism extends Sprite
	{
		private var organismSprite:Sprite;
		private var orgCollisionSprite:Sprite;
		private var lifeSpan:int;
		private var currentLife:int;
		private var regenRate:int;
		private var collectedResources:Array;
		private var lifeLongitude:int;
		
		private var maxSpeed:Number;
		private var acceleration:Number;
		private var deceleration:Number;
		
		private var jumpStrength:Number;
		private var searchRange:Number;
		private var marshSpeed:Number;
		private var aquaticBreath:int;
		private var aquaticSpeed:Number;
		private var currentAir:Number;
		
		private var goUp:Boolean;
		private var goDown:Boolean;
		private var goLeft:Boolean;
		private var goRight:Boolean;
		private var jumpUp:Boolean;
		private var isStopped:Boolean;
		private var xSpeed:Number;
		private var ySpeed:Number;
		private var zSpeed:Number;
		private var jumpHeight:Number;
		
		private var isDead:Boolean;
		
		public function Organism(orgSprite:Sprite, orgColSprite:Sprite, lifeSpan:int, maxSpeed:Number, acceleration:Number, deceleration:Number, 
									jumpStrength:Number, searchRange:Number, marshSpeed:Number, aquaticBreath:int, 
									aquaticSpeed:Number, regenRate:int) 
		{
			if (orgSprite == null) {
				organismSprite = new Sprite();
				orgCollisionSprite = new Sprite();
				var startShape:Shape = new Shape();
				startShape.graphics.beginFill(0xffffff, 1);
				startShape.graphics.drawRect(0, 0, 16, 16);
				startShape.graphics.endFill();
				organismSprite.addChild(startShape);
				var startShape2:Shape = new Shape();
				startShape2.graphics.beginFill(0xffffff, 1);
				startShape2.graphics.drawRect(0, 0, 16, 16);
				startShape2.graphics.endFill();
				orgCollisionSprite.addChild(startShape2);
			}
			else {
				organismSprite = orgSprite;
				orgCollisionSprite = orgColSprite;
			}
			
			collectedResources = new Array();
			
			this.lifeSpan = lifeSpan;
			this.regenRate = regenRate;
			this.maxSpeed = maxSpeed;
			this.acceleration = acceleration;
			this.deceleration = deceleration;
			this.jumpStrength = jumpStrength;
			this.searchRange = searchRange;
			this.marshSpeed = marshSpeed;
			this.aquaticBreath = aquaticBreath;
			this.aquaticSpeed = aquaticSpeed;
			this.currentAir = aquaticBreath;
			currentLife = lifeSpan;
			isStopped = false;
			isDead = false;
			xSpeed = 0;
			ySpeed = 0;
			zSpeed = 0;
			jumpHeight = 0;
			lifeLongitude = 0;
			
			this.addChild(organismSprite);
		}
		
		public function updateOrganism():void {
			
			if (this.numChildren == 0)
				this.addChild(organismSprite);
			
			updateMotion();
			updateCollision();
			lifeLongitude++;
			currentLife--;
			
			
			if (currentAir == 0) isDead = true;
			if (currentLife <= 0) {
				if (jumpHeight <= .1) isDead = true;
			}
			
		}
		private function updateMotion():void {
			
			if (jumpUp && jumpHeight == 0) {
				zSpeed = jumpStrength;
				jumpHeight += zSpeed;
				organismSprite.y -= zSpeed;
			}
			else if (jumpUp && jumpHeight > 0) {
				zSpeed -= .25;
				jumpHeight += zSpeed;
				organismSprite.y -= zSpeed;
			}
			if (jumpHeight == 0)
				jumpUp = false;
			if (jumpHeight < .1)
				jumpHeight = 0;
			
			if (goUp) { 
				ySpeed -= acceleration;
			}
			else if (!goUp && ySpeed < 0) { 
				ySpeed += deceleration;
			}
			
			if (goDown) {
				ySpeed += acceleration;
			}
			else if (!goDown && ySpeed > 0) { 
				ySpeed -= deceleration;
			}
			
			if (goLeft) {
				xSpeed -= acceleration;
			}
			else if (!goLeft && xSpeed < 0){
				xSpeed += deceleration;
			}
			
			if (goRight) {
				xSpeed += acceleration;
			}
			else if (!goRight && xSpeed > 0) { 
				xSpeed -= deceleration;
			}
			
			if (xSpeed < -maxSpeed) xSpeed = -maxSpeed;
			if (xSpeed > maxSpeed) xSpeed = maxSpeed;
			if (ySpeed < -maxSpeed) ySpeed = -maxSpeed;
			if (ySpeed > maxSpeed) ySpeed = maxSpeed;
			
			if (!goUp && !goDown && ySpeed > 0) ySpeed = 0;
			else if (!goUp && !goDown && ySpeed < 0) ySpeed = 0;
			else if (!goUp && !goDown) ySpeed = 0;
			
			if (!goLeft && !goRight && xSpeed > 0) xSpeed = 0;
			else if (!goLeft && !goRight && xSpeed < 0) xSpeed = 0;
			else if (!goLeft && !goRight) xSpeed = 0;
		}
		private function updateCollision():void {
			
			if (xSpeed == 0 && ySpeed == 0) return;
			
			if (Math.abs(xSpeed) < .1) 
				xSpeed = 0;
			if (Math.abs(ySpeed) < .1) 
				ySpeed = 0;
			if(!isStopped){
				this.x += xSpeed;
				this.y += ySpeed;
			}
			
			var inWater:Boolean = false;
			var hasSlowed:Boolean = false;
			var hasStopped:Boolean = false;
			var collidingTiles:Array = MapManager.getSingleton().getCurrentMap().getCollidingTiles(this);
			var collidingRes:Array = MapManager.getSingleton().getCurrentMap().getCollidingResources(this);
			
			for (var r:int = 0; r < collidingRes.length; r++) {
				MapManager.getSingleton().getCurrentMap().removeResource(collidingRes[r]);
				collectedResources.push(collidingRes[r]);
				
				currentLife += lifeSpan * (regenRate / 100);
			}
			
			for (var i:int = 0; i < collidingTiles.length; i++) {
				
				if (collidingTiles[i].getType() == 3) {
					// Handle aquatic movement
						if(!hasSlowed){
						this.x -= xSpeed;
						this.y -= ySpeed;
						xSpeed = (xSpeed / maxSpeed) * aquaticSpeed;
						ySpeed = (ySpeed / maxSpeed) * aquaticSpeed;
						this.x += xSpeed;
						this.y += ySpeed;
						hasSlowed = true;
					}
					// Handle breathing
					inWater = true;
				}
				if (collidingTiles[i].getType() == 4 && !hasSlowed && isInside(this, collidingTiles[i])) {
					// Handle marsh movement
					this.x -= xSpeed;
					this.y -= ySpeed;
					xSpeed = (xSpeed / maxSpeed) * marshSpeed;
					ySpeed = (ySpeed / maxSpeed) * marshSpeed;
					this.x += xSpeed;
					this.y += ySpeed;
					hasSlowed = true;
				}
				if (collidingTiles[i].isChasm() && isInside(this, collidingTiles[i])) {
					// Handle chasm collision
					if (jumpHeight == 0) {
						// Down we go
						isDead = true;
					}
				}
				if (collidingTiles[i].isCollidable() && !hasStopped) {
					// Handle obstacle collision
					
					this.x -= xSpeed;
					if (isColliding(this, collidingTiles[i])) {
						this.x += xSpeed;
						this.y -= ySpeed;
						if (isColliding(this, collidingTiles[i])) {
							this.x -= xSpeed;
							hasStopped == true;
						}
					}
					
				}
			}
			if (!inWater) {
				if (currentAir < aquaticBreath) currentAir++;
			}
			else {
				if (currentAir > 0) currentAir -= 1;
			}
			
		}
		private function isColliding(org:Organism, tile:Tile):Boolean {
			var tileRect:Rectangle = new Rectangle(tile.getXCoord() * 32, tile.getYCoord() * 32, 32, 32);
			for (var i:int = 0; i < orgCollisionSprite.numChildren; i++) {
				var tempShape:Shape = orgCollisionSprite.getChildAt(i) as Shape;
				
				if (tileRect.intersects(new Rectangle
						(org.x + tempShape.x, org.y + tempShape.y, tempShape.width, tempShape.height)))
					return true;
			}
			return false;
		}
		private function isInside(org:Organism, tile:Tile):Boolean {
			var tileRect:Rectangle = new Rectangle(tile.getXCoord() * 32, tile.getYCoord() * 32, 32, 32);
			var withinRect:Rectangle = new Rectangle
				(org.x + 4, org.y + 14, org.getOrgCollisionSprite().width - 8, org.getOrgCollisionSprite().height - 14);
			
			if (tileRect.containsRect(withinRect)) return true;
			return false;
		}
		
		/*private function chasmFall(event:Event):void {
			if(organismSprite.height>0){
				organismSprite.height -= 1;
				organismSprite.y += 1;
			}
			if (organismSprite.height == 0 || organismSprite.height < 1){
				isDead = true;
				organismSprite.height = 16;
				organismSprite.y -= 16;
			}
		}*/
		
		public function setUp(b:Boolean):void { 
			goUp = b; }
		public function setDown(b:Boolean):void { goDown = b; }
		public function setLeft(b:Boolean):void { goLeft = b; }
		public function setRight(b:Boolean):void { goRight = b; }
		public function setJump(b:Boolean):void { jumpUp = b; }
		public function setStop(b:Boolean):void { isStopped = b; }
		
		public function getCollectedResources():Array { return collectedResources; }
		
		public function getOrgCollisionSprite():Sprite { return orgCollisionSprite; }
		public function getOrgSprite():Sprite { return organismSprite; }
		
		public function getLifeSpan():int { return lifeSpan; }
		public function getCurrentLife():int { return currentLife; }
		public function getMaxSpeed():Number { return maxSpeed; }
		public function getAcceleration():Number { return acceleration; }
		public function getDeceleration():Number { return deceleration; }
		public function getJumpStrength():Number { return jumpStrength; }
		public function getSearchRange():Number { return searchRange; }
		public function getMarshSpeed():Number { return marshSpeed; }
		public function getAquaticBreath():int { return aquaticBreath; }
		public function getAquaticSpeed():Number { return aquaticSpeed; }
		public function getCurrentAir():Number { return currentAir; }
		public function getLongitude():int { return lifeLongitude; }
		public function getRegeneration():int { return regenRate; }
		
		public function isOrgDead():Boolean { return isDead; }
		
	}

}