package Elements.Species 
{
	import Elements.Resources.Resource;
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Patrick McGrath
	 */
	public class GenerationManager 
	{
		public static var singleton:GenerationManager;
		
		private var pastGeneration:Array;
		private var currentGeneration:Array;
		private var generationSize:int;
		
		private var crossoverRate:Number;
		private var mutationRate:Number;
		private var variance:Number;
		
		public var generationCount:int;
		public var organismCount:int;
		
		public static function getSingleton():GenerationManager {
			if (singleton == null)
				singleton = new GenerationManager();
			return singleton;
		}
		public function GenerationManager() 
		{
			pastGeneration = new Array();
			currentGeneration = new Array();
			
			generationSize = 10;
			crossoverRate = 0;
			mutationRate = 0;
			variance = 0.1;
			
			generationCount = 1;
			organismCount = 1;
			
			createNewGeneration();
		}
		
		
		public function createNewGeneration():void {
			if (pastGeneration.length == 0) {
				// Start from scratch.
				
				var defLifespan:int = 200;
				var defSpeed:Number = 1;
				var defAcc:Number = .25;
				var defDec:Number = .25;
				var defJump:Number = 3.5;
				var defSearch:Number = 50;
				var defMarshSpd:Number = .75;
				var defWaterBreath:int = 200;
				var defWaterSpd:Number = .75;
				var defRegen:int = 30;
				
				for (var i:int = 0; i < generationSize; i++) {
					
				/*	var newLifeSpan:int = defLifespan + (((Math.random() * (2 * variance )) - variance) * defLifespan);
					var newSpeed:Number = defSpeed + (((Math.random() * (2 * variance )) - variance) * defSpeed);
					var newAcc:Number = defAcc + (((Math.random() * (2 * variance )) - variance) * defAcc);
					var newDec:Number =  defDec + (((Math.random() * (2 * variance )) - variance) * defDec);
					var newJump:Number =  defJump + (((Math.random() * (2 * variance )) - variance) * defJump);
					var newSearch:Number =  defSearch + (((Math.random() * (2 * variance )) - variance) * defSearch);
					var newMarshSpd:Number = defMarshSpd + (((Math.random() * (2 * variance )) - variance) * defMarshSpd);
					var newWaterBreath:int =  defWaterBreath + (((Math.random() * (2 * variance )) - variance) * defWaterBreath);
					var newWaterSpd:Number = defWaterSpd + (((Math.random() * (2 * variance )) - variance) * defWaterSpd);
					var newRegen:int = defRegen + (((Math.random() * (2 * variance )) - variance) * defRegen);
					*/
					var newOrganism:Organism = new Organism
						(null, null, defLifespan, defSpeed, defAcc, defDec, defJump, 
						defSearch, defMarshSpd, defWaterBreath, defWaterSpd, defRegen);
					
					currentGeneration.push(newOrganism);
				}
				
			}
			else {
				// Use past generation to generate new generation.
				
				var rouletteValues:Array = new Array();
				var totalRoulette:int = 0;
				for (var p:int = 0; p < pastGeneration.length; p++) {
					var tempRouVal:int = 0;
					tempRouVal += pastGeneration[p].getLongitude() / 60;
					tempRouVal += pastGeneration[p].getCollectedResources().length;
					rouletteValues.push(tempRouVal + totalRoulette);
					
					totalRoulette += tempRouVal;
				}
				
				for (var g:int = 0; g < (generationSize); g++) {
					
					var parentA:Organism = spinRoulette(rouletteValues, totalRoulette, pastGeneration);
					while (true) {
						var parentB:Organism = spinRoulette(rouletteValues, totalRoulette, pastGeneration);
						if (parentA != parentB) break;
					}
					
					if (Math.random() >= .5) {
						var childOrgSprite:Sprite = parentA.getOrgSprite()
						var childOrgColSprite:Sprite = parentA.getOrgCollisionSprite();
					}
					else {
						childOrgSprite = parentB.getOrgSprite();
						childOrgColSprite = parentB.getOrgCollisionSprite();
					}
					
					if (Math.random() >= .5) var childLifespan:int = parentA.getLifeSpan();
					else childLifespan = parentB.getLifeSpan();
					if (Math.random() >= .5) var childSpeed:int = parentA.getMaxSpeed();
					else childSpeed = parentB.getMaxSpeed();
					if (Math.random() >= .5) var childAcc:Number = parentA.getAcceleration();
					else childAcc = parentB.getAcceleration()
					if (Math.random() >= .5) var childDec:Number = parentA.getDeceleration();
					else childDec = parentB.getDeceleration();
					if (Math.random() >= .5) var childSearch:Number = parentA.getSearchRange();
					else childSearch = parentB.getSearchRange();
					if (Math.random() >= .5) var childJump:Number = parentA.getJumpStrength();
					else childJump = parentB.getJumpStrength();
					if (Math.random() >= .5) var childMarshSpd:Number = parentA.getMarshSpeed();
					else childMarshSpd = parentB.getMarshSpeed();
					if (Math.random() >= .5) var childWaterBreath:int = parentA.getAquaticBreath();
					else childWaterBreath = parentB.getAquaticBreath();
					if (Math.random() >= .5) var childWaterSpd:Number = parentA.getAquaticSpeed();
					else childWaterSpd = parentB.getAquaticSpeed();
					if (Math.random() >= .5) var childRegen:int = parentA.getRegeneration();
					else childRegen = parentB.getRegeneration();
					
					var canyonCount:int = 0;
					var jungleCount:int = 0;
					var desertCount:int = 0;
					var oceanCount:int = 0;
					var marshCount:int = 0;
					
					for (var a:int = 0; a < parentA.getCollectedResources().length; a++) {
						var tempRes:Resource = parentA.getCollectedResources()[a];
						if (tempRes.getType() == 0 && Math.random() >= .5) {
							// Canyon
							childJump += .5;
							childLifespan += 35;
							canyonCount++;
						}
						if (tempRes.getType() == 1 && Math.random() >= .5) {
							// Jungle
							childSpeed += .1;
							childAcc += .05;
							childLifespan += 20;
							jungleCount++;
						}
						if (tempRes.getType() == 2 && Math.random() >= .5) {
							//Desert
							childRegen += 5;
							childLifespan += 35;
							desertCount++;
						}
						if (tempRes.getType() == 3 && Math.random() >= .5) {
							//Ocean
							childWaterBreath += 5;
							childWaterSpd += .025;
							childLifespan += 20;
							oceanCount++;
						}
						if (tempRes.getType() == 4 && Math.random() >= .5) {
							// Marsh
							childSearch += 10;
							childLifespan += 20;
							marshCount++;
						}
					}
					for (var b:int = 0; b < parentB.getCollectedResources().length; b++) {
						tempRes = parentB.getCollectedResources()[b];
						if (tempRes.getType() == 0 && Math.random() >= .5) {
							// Canyon
							childJump += .5;
							childLifespan += 25;
							canyonCount++;
						}
						if (tempRes.getType() == 1 && Math.random() >= .5) {
							// Jungle
							childSpeed += .1;
							childAcc += .05;
							childLifespan += 20;
							jungleCount++;
						}
						if (tempRes.getType() == 2 && Math.random() >= .5) {
							//Desert
							childRegen += 5;
							childLifespan += 35;
							desertCount++;
						}
						if (tempRes.getType() == 3 && Math.random() >= .5) {
							//Ocean
							childWaterBreath += 5;
							childWaterSpd += .025;
							childLifespan += 20;
							oceanCount++;
						}
						if (tempRes.getType() == 4 && Math.random() >= .5) {
							// Marsh
							childSearch += 10;
							childLifespan += 20;
							marshCount++;
						}
					}
					
					// Change appearance
					if (canyonCount >= 1) {
						var canyonShape:Shape = new Shape();
						canyonShape.graphics.beginFill(0xFFDC17, 1);
						canyonShape.graphics.drawRect((Math.random() * 18) - 2, (Math.random() * 18) - 3, 5, 5);
						canyonShape.graphics.endFill();
						childOrgSprite.addChild(canyonShape);
					}
					if (jungleCount >= 1) {
						var jungleShape:Shape = new Shape();
						jungleShape.graphics.beginFill(0x1CFF21, 1);
						jungleShape.graphics.drawRect((Math.random() * 18) - 2, (Math.random() * 18) - 3, 5, 5);
						jungleShape.graphics.endFill();
						childOrgSprite.addChild(jungleShape);
					}
					if (desertCount >= 1) {
						var desertShape:Shape = new Shape();
						desertShape.graphics.beginFill(0xC4B029, 1);
						desertShape.graphics.drawRect((Math.random() * 18) - 2, (Math.random() * 18) - 3, 5, 5);
						desertShape.graphics.endFill();
						childOrgSprite.addChild(desertShape);
					}
					if (oceanCount >= 1) {
						var oceanShape:Shape = new Shape();
						oceanShape.graphics.beginFill(0x8AADFF, 1);
						oceanShape.graphics.drawRect((Math.random() * 18) - 2, (Math.random() * 18) - 3, 5, 5);
						oceanShape.graphics.endFill();
						childOrgSprite.addChild(oceanShape);
					}
					if (marshCount >= 1) {
						var marshShape:Shape = new Shape();
						marshShape.graphics.beginFill(0x96FFE0, 1);
						marshShape.graphics.drawRect((Math.random() * 18) - 2, (Math.random() * 18) - 3, 5, 5);
						marshShape.graphics.endFill();
						childOrgSprite.addChild(marshShape);
					}
					
					var childOrganism:Organism = new Organism(childOrgSprite, childOrgColSprite,
							childLifespan, childSpeed, childAcc, childDec, childJump, childSearch, childMarshSpd,
							childWaterBreath, childWaterSpd, childRegen);
					currentGeneration.push(childOrganism);
					
				}
				
				pastGeneration = new Array();
			}
		}
		private function spinRoulette(rouletteVals:Array, totalRoulette:int, orgs:Array):Organism {
			var rouletteSpin:int = Math.ceil(Math.random() * totalRoulette);
			for (var s:int = 0; s < rouletteVals.length; s++) {
				if (rouletteSpin <= rouletteVals[s])
					return orgs[s];				
			}
			return null;
		}
		
		public function addDeadOrganism(org:Organism):void {
			pastGeneration.push(org);
		}
		
		public function getNextOrganism():Organism {
			if (currentGeneration.length != 0) {
				organismCount++;
				return currentGeneration.pop();
			}
			else {
				organismCount = 1;
				generationCount++;
				createNewGeneration();
				return currentGeneration.pop();
			}
		}
		
		
	}

}