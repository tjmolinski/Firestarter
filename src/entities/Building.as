package entities 
{
	import emitters.FireEmitter;
	import emitters.FireParticle;
	import entities.NewPlayer;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	
	public class Building extends Entity
	{
	    [Embed(source = '../../levels/images/BuildingL.png')]
		private const BUILDING_L:Class;
	    [Embed(source = '../../levels/images/BuildingM.png')]
		private const BUILDING_M:Class;
	    [Embed(source = '../../levels/images/BuildingS.png')]
		private const BUILDING_S:Class;
	    [Embed(source = '../../levels/images/BuildingS2h.png')]
		private const BUILDING_S2_H:Class;
	    [Embed(source = '../../levels/images/BuildingS2v.png')]
		private const BUILDING_S2_V:Class;

		private var lifeTotal : Number = 100.0;
		private var degrader : Number = 0.0;
		private var speed : Number = 50.0;
		private var gravity : Number = 9.8;
		private var vx : Number = 0.0;
		private var vy : Number = 0.0;
		private var time : Number = 0.0;
		private var rotator : Number = 0.0;
		private var fireCnt : int = 0;
		private var fireMax : int = 5;
		//private var emitterList : Array;
		
	    public function Building(x:Number, y:Number, buildingType:String) 
		{
		    type="building";

		    var buildingImage:Image;

		    switch (buildingType) {
		    case "buildingL":
			buildingImage = new Image(BUILDING_L);
			break;
		    case "buildingM":
			buildingImage = new Image(BUILDING_M);
			break;
		    case "buildingS":
			buildingImage = new Image(BUILDING_S);
			break;
		    case "buildingS2h":
			buildingImage = new Image(BUILDING_S2_H);
			break;
		    case "buildingS2v":
			buildingImage = new Image(BUILDING_S2_V);
			break;
		    }
	    
		    graphic = buildingImage;
		    setHitbox(buildingImage.width, buildingImage.height);

		    this.x = x;
		    this.y = y;
		    
		    type = "building";
		    //emitterList = new Array();
		}
		
		override public function update():void
		{
			var match:Match = collide("match", x, y) as Match;
			var fireC:FireChunk = collide("firechunk", x, y) as FireChunk;
			
			if ((match || fireC) && fireCnt < fireMax)
			{
				if (match)
					world.remove(match);
				else
					world.remove(fireC);
					
				var tmp : Entity = world.add(new FireEmitter(x + (Math.random() * this.width), y + (Math.random() * this.height)));
				//emitterList.push(tmp);
				degrader += 0.5;
				fireCnt++;
			}
			
			if (lifeTotal <= 0)
			{
				world.remove(this);
				//for (var i : int = 0; i < emitterList.length; i++)
					//world.remove(emitterList[i]);
				world.add(new FireChunk(x+this.width/2, y+this.height/2, Math.floor(Math.random() * 4)));
			}
			
			lifeTotal -= degrader;
		}
	}
}