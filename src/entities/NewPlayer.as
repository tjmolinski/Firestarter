package entities
{
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.FP;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;
    import net.flashpunk.graphics.Spritemap;

    import entities.Match;
	
    public class NewPlayer extends Entity
    {
	[Embed(source = '../../levels/images/PlayerSprites.png')]
	    private const PLAYER:Class;
	public var sprPlayer:Spritemap = new Spritemap(PLAYER, 16, 16);
	private var img:Image = Image.createCircle(8, 0xFFFFFF);
	private var speed : Number = 150.0;
	private var diagMov : Boolean = true;
	private var lastlastKey : int = 0;
	public var direction : String = "RIGHT";
	public var vx : Number = 0.0;
	public var vy : Number = 0.0;
		
	public function NewPlayer(x:int, y:int)
	{
	    this.x = x;
	    this.y = y;
	    graphic = sprPlayer;
			
	    sprPlayer.add("stand", [0], 1);
	    sprPlayer.add("runRight", [1, 2, 3, 2, 1], 10);
	    sprPlayer.add("runLeft", [6, 5, 4, 5, 6], 10);
	    setHitbox(img.width-3, img.height-3);
	    this.originX -= 2;
	    type = "player";
	}

	override public function update():void
	{
	    //////////////////////////////////////////////////////////////////
	    //Keep camera within
	    if (x > -FP.screen.width/2 && x < FP.screen.width)
		world.camera.x = x - FP.screen.width/2;
	    if (y > -FP.screen.height/2 && y < FP.screen.height)
		world.camera.y = y - FP.screen.height/2;
			
	    if (y < -FP.screen.height/2 + 10)
		world.camera.y = -FP.screen.height;
	    else if (y > FP.screen.height - 10)
		world.camera.y = FP.screen.height / 2;
				
	    if (x < -FP.screen.width/2 + 10)
		world.camera.x = -FP.screen.width;
	    else if (x > FP.screen.width - 10)
		world.camera.x = FP.screen.width/2;
	    //////////////////////////////////////////////////////////////////
				
	    //Set diagMov to true for diagonal movement

	    var xSpeed:Number = 0;
	    var ySpeed:Number = 0;
	    if (diagMov)
		{
		    if (Input.check(Key.LEFT)) { 
			vx = -speed;
		    }
		    else if (Input.check(Key.RIGHT)) { 
			vx = speed;
		    }
		    else {
			vx = 0;
		    }
		    if (Input.check(Key.UP)) { 
			vy = -speed;
		    }
		    else if (Input.check(Key.DOWN)) { 
			vy = speed;
		    }
		    else {
			vy = 0;
		    }
		    
		    xSpeed = vx * FP.elapsed;
		    ySpeed = vy * FP.elapsed;
		}
	    else {
		//Create a match when hitting space bar
		if (Input.pressed(Key.SPACE))
		    world.add(new Match(x+img.width/2, y+img.height/2, this));
				
		if (Input.check(Key.UP) || Input.check(Key.DOWN) || Input.check(Key.LEFT) || Input.check(Key.RIGHT))
		    switch(Key.name(lastlastKey))
			{
			case "LEFT":
			    direction = "LEFT";
			    vx = -speed;
			    vy = 0.0;
			    break;
			case "RIGHT":
			    direction = "RIGHT";
			    vx = speed;
			    vy = 0.0;
			    break;
			case "DOWN":
			    direction = "DOWN";
			    vx = 0.0;
			    vy = speed;
			    break;
			case "UP":
			    direction = "UP";
			    vx = 0.0;
			    vy = -speed;
			    break;	
			}
		else {
		    sprPlayer.play("stand");
		    vx = 0.0, vy = 0.0; //Clear the velocitys if not moving
		}
					
		//Save the key before space so we don't stop moving when hitting space
		if(Input.lastKey != Key.SPACE)
		    lastlastKey = Input.lastKey;
				
		//Apply the velocities
		// x += vx * FP.elapsed;
		// y += vy * FP.elapsed;
		xSpeed = vx * FP.elapsed;
		ySpeed = vy * FP.elapsed;
	    }

	    if (vx > 0 || vy > 0) { sprPlayer.play("runRight"); }
	    else if (vx < 0 || vy < 0) { sprPlayer.play("runLeft"); }
	    else { sprPlayer.play("stand"); }

	    // pixel-perfect horizontal collision
	    for (var i:int = 0; i < Math.abs(xSpeed); i+=1) {
		if (!collide("building", x+FP.sign(xSpeed), y)) {
		    x += FP.sign(xSpeed);
		}
	    }

	    // pixel-perfect vertical collision
	    for (var j:int = 0; j < Math.abs(ySpeed); j+=1) {
		if (!collide("building", x, y+FP.sign(ySpeed))) {
		    y += FP.sign(ySpeed);
		}
	    }
	}
    }
}
