-------------------------------------------------------------------------
-- game.lua
--
-- Berlin - Mario Style Game for the Digital Skills Academy
-- by Conor Gilmer (conor.gilmer@gmail.com)
--
-- 28th of July 2013
--
--CoronaSDK version 2013.1076 (2013.4.3) was used for project.
--Based on the Template given by the DSA from T and G Apps Ltd.
--
-------------------------------------------------------------------------

--Start off by requiring storyboard and creating a scene.
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()


--Require physics
local physics = require("physics")	
physics.start(); physics.setGravity( 0, 20 ) --Start physics
--physics.setDrawMode( "hybrid" )

--We also require the section definitions.
--These controls positions etc of the Stars and platforms.
local level = require("levels.level"..currentLevel)

--Maths
local _W = display.contentWidth
local _H = display.contentHeight
local mR = math.random 
local mF = math.floor 

--Groups
local firstGroup, objectGroup, enemyGroup, extraGroup

--Sounds
local coinSound, overSound, winSound, jumpSound, laserSound, gotchaSound
local coinChannel, jumpChannel, overChannel, winChannel, laserChannel = 2,3,4,5,7
--Channel vars, used to play sounds, these values change when they are used.

--Game Control Variables
local moveSide = "right" --Changes when we touch the buttons.
local moving = false --Keeps track of us moving or not.
local floorHit = false --Controls animation
local singleJump, doubleJump = false, false
local gameOverCalled = false --Just incase an extra game over call is made.
local distChange, distChange2 = 0, 0 --Keeps track of how far we've gone in regards to the contentBounds.
local gameIsActive = true  --Set to true to start scrolling etc.
local score = levelScore  --Points for killing enemies etc.
local gameT = gameTime
local sectionInt = 1 --Controls the sections being made
--local levelScore = 0 --Reset the levelScore just incase it is still set.
--local level = _G.currentLevel

--BG and display variables.
local bg1, bg2, ground1, ground2, extra1, extra2
local timerText --Displays time




local scoreText --Displays our score
local livesText --Displays lives Left
local bulletsText --counter for bullets 
local levelsText --Display the Level
-- local lives = 3 -- lives is a global
local bullets = 6 --five for level 1 , 4 level2 and 3 for level 3
--Functions Pre-declared
--This is done so runtime listeners can be easily removed/added 
local onCollision, gameLoop

--Player only vars.
local player
local levelspeed = 0 --Will increase when we start running.
local runSpeed = 8 --How fast the background will move when your running top speed.
local movementAllowed = true
local bullet
--Timers and transitions
local moveTimer





--------------------------------------------
-- ***SPRITESHEET SETUP***
-- Animations for the player/enemies
--------------------------------------------
--Player
local options = 
{
	width = 45, height = 62,
	numFrames = 5,
	sheetContentWidth = 225,
	sheetContentHeight = 62
}
--local playerSheet = graphics.newImageSheet( "images/playerSprite.png", options)
local playerSheet = graphics.newImageSheet( "images/berlin5.png", options)

local playerSprite = { 
	{name="run", start=3, count=3, time = 400, loopCount = 0 },
	{name="jump", start=1, count=1, time = 1000, loopCount = 1 },
	{name="stand", start=2, count=1, time = 1000, loopCount = 1 },
        {name="climb", start=1, count=1, time = 1000, loopCount = 2 },

}

--Enemy
local options2 = 
{
	width = 48, height = 45,
	numFrames = 2,
	sheetContentWidth = 96,
	sheetContentHeight = 45
}
local enemySheet = graphics.newImageSheet( "images/berlin.png", options2)
--local enemySheet = graphics.newImageSheet( "images/enemySprite.png", options2)
local enemySprite = { name="run", start=1, count=2, time = 300, loopCount = 0 }




------------------------------------------------
-- *** STORYBOARD SCENE EVENT FUNCTIONS ***
------------------------------------------------
-- Called when the scene's view does not exist:
-- Create all your intial display objects here.
function scene:createScene( event )
	print( "Game: createScene event")
	local screenGroup = self.view
	

	--Create the groups..
	firstGroup = display.newGroup()
	objectGroup = display.newGroup()
	enemyGroup = display.newGroup()
	extraGroup = display.newGroup()
	screenGroup:insert(firstGroup); screenGroup:insert(objectGroup)
	screenGroup:insert(enemyGroup); screenGroup:insert(extraGroup) 

	--Load the sounds.
        -- sounds sourced from www.freeSFX.co.uk
	coinSound = audio.loadSound("sounds/cash_register.mp3") -- collect
	overSound = audio.loadSound("sounds/comedy_trumpet.mp3") -- defeat2
	winSound = audio.loadSound("sounds/enthusiastic_yes.mp3") -- levelclear)

        -- sounds sourced from freesounds.org creative commons licence
        jumpSound = audio.loadSound("sounds/cartoon-jump.mp3") -- Jump.mp3
        laserSound = audio.loadSound("sounds/spaceblaster.mp3") -- HellYeah.ogg
        gotchaSound = audio.loadSound("sounds/blood_splat.mp3") -- HellYeah.ogg

	--------------------------------------------
	-- ***HUD SETUP***
	-- Creates the HUD Bar, Score Text
	--------------------------------------------
	local hudBar = display.newImageRect(extraGroup, "images/clearheader.png", 480,36)
	hudBar.x = _W*0.5; hudBar.y = 14; hudBar.alpha = 0.5

	scoreText = display.newText(extraGroup, "Score: "..score,0,0,"Arial",17)
	scoreText:setReferencePoint(display.CenterLeftReferencePoint); scoreText:setTextColor(50)
	scoreText.x = 6; scoreText.y = 14
        -- Adding new Counters to the top bar
        -- cg added bullets counters
        bullets = bullets - currentLevel --(higher/harder level fewer bullets)
        bulletsText = display.newText(extraGroup, "Bullets: "..bullets,0,0,"Arial",17)
	bulletsText:setReferencePoint(display.CenterRightReferencePoint); bulletsText:setTextColor(50)
	bulletsText.x = (_W/2) -75; bulletsText.y = 14

        -- cg added levels counte
        levelsText = display.newText(extraGroup, "Level: "..currentLevel,0,0,"Arial",17)
	levelsText:setReferencePoint(display.CenterRightReferencePoint); levelsText:setTextColor(50)
	levelsText.x = (_W/2) +25; levelsText.y = 14
        
        -- cg added lives counter
        livesText = display.newText(extraGroup, "Lives: "..lives,0,0,"Arial",17)
	livesText:setReferencePoint(display.CenterRightReferencePoint); livesText:setTextColor(50)
	livesText.x = _W-125; livesText.y = 14

        -- cg added timer clock
        local startTime = os.time()
	local levelTime = 60
	gameT = "00:00"
--	local displayTime = display.newText(levelTime, 0, 0, "Helvetica", 20)
    	timerText = display.newText(extraGroup, "Time: 0", 0, 0, "Arial", 17)
	timerText:setReferencePoint(display.CenterRightReferencePoint); timerText:setTextColor(50)
	timerText.x = _W-30; timerText.y = 14

        local function checkTime(event)
    		local now = os.time()
	        fulltime = now - startTime
        	min = math.floor(fulltime/60)
	        sec = fulltime % 60
        	if sec < 10 then sec = "0"..sec end
		        gameT = min..":"..sec
		        timerText.text = "Time:  "..gameT
		end

    Runtime:addEventListener("enterFrame", checkTime)


	--------------------------------------------
	-- ***CREATE GAME FUNCTION.***
	--Create the scenery and the player/jumpfunction
	--------------------------------------------
	--Jumping function with some control vars.
	local function playerJump( event )
		local t = event.target 

		--Only allow this to occur if we haven't died etc.
		if movementAllowed then
			if event.phase == "began" then
				display.getCurrentStage():setFocus( t, event.id )
				t.isFocus = true; t.alpha = 0.6
				
			elseif t.isFocus then
				if event.phase == "ended" or event.phase == "cancelled" then
					display.getCurrentStage():setFocus( t, nil )
					t.isFocus = false; t.alpha = 1
					
					floorHit = false	
					if doubleJump == false then 
						player:setLinearVelocity( 0, 0 )
						player:applyForce(0,-8, player.x, player.y)
						player:setSequence("jump")
						jumpChannel = audio.play(jumpSound)
					end

					if singleJump == false then singleJump = true 
					else doubleJump = true end
				end
			end

		--If we aren't allowed to move we need to stop the focus.
		--If you dont there is a risk of a crash as the scene changes (if your still pressing the button)
		else
			display.getCurrentStage():setFocus( t, nil )
		end
		return true
	end
        
        
            
        --2nd btn
        ----------------------------------------------------------------
	-- ***CREATE GAME FUNCTION.***
	--Create the scenery and the player/kick/shoot or spit Fn
	----------------------------------------------------------------
	--Kicking/Spitting or Shooting function with some control vars.
	local function playerKick( event )
		local t = event.target 
                
                -- remove bullet as it goes
                local function bulletDisappear(event)
                    display.remove(event)
                    print("bullet disappears")
                end                
                -- Take care of collisions
           

		--Only allow this to occur if we haven't died etc.
		if movementAllowed then
                    if event.phase == "began" then
                        -- cg check there is bullets first
                        if bullets <= 0 then
                            bulletsText.text = "Bullets: OUT"
                            bulletsText:setReferencePoint(display.CenterRightReferencePoint); 
                            bulletsText.x = (_W/2) -60;                      
                        else 
                            print("movement allowed shoot")                  
                            bullets = bullets -1
                            bulletsText.text = "Bullets: "..bullets
                            bulletsText:setReferencePoint(display.CenterRightReferencePoint); 
                            bulletsText.x = (_W/2) -75; 
                            laserChannel = audio.play(laserSound)
                            startx = player.x  - (player.contentWidth /2 )
                            starty = player.y - ( player.contentHeight /2 )
                            --createBullet
                            bullet = display.newImage("images/bullet.png", startx, starty)
                            bullet.name= "bullet"
                 -- local bulletShape = { -16,-28, 16,-28, 16,31, -16,31 }
                            physics.addBody( bullet,  "dynamic", { friction=1, bounce=0, shape=bulletShape} )
                            bullet.trans = transition.to(bullet,{x=_W, y=starty, timer=1000, onComplete=bulletDisappear})
                    --If we aren't allowed to move we need to stop the focus.
		            --If you dont there is a risk of a crash as the scene changes (if your still pressing the button)
                    end
                    end
                else
			display.getCurrentStage():setFocus( t, nil )
		end
                
		return true
	end

	--Create Section function.. Create platforms and enemies etc
	--Using the required level file at the top to create each screen in turn.
	local function createSection()
		local xOffset = 480

		--Get the section we want to create now.
		--Loop through creating everything with the right properties.
		local i
		for i=1, #level[sectionInt]["blocks"] do
			local object = level[sectionInt]["blocks"][i]
			local block = display.newImageRect(objectGroup, object["filename"], object["widthHeight"][1], object["widthHeight"][2])
			block:setReferencePoint(display.BottomCenterReferencePoint);
			block.x = object["position"][1]+xOffset; block.y = object["position"][2]; 
			
			--Change the block properties depending on the type of block
			block.name = "block"; block.type = object["type"]; block.spawned = false
			if block.type == "pushable" then
				physics.addBody( block, "dynamic", { density=0.004, friction=1, bounce=0} );
				block.isFixedRotation = true
			else
				physics.addBody( block, "static", { friction=1, bounce=0} );
			end
		end
		for i=1, #level[sectionInt]["coins"] do
			local object = level[sectionInt]["coins"][i]
			local coin = display.newImageRect(objectGroup, "images/euro.png", 30, 30)
			coin:setReferencePoint(display.BottomCenterReferencePoint);
			coin.x = object["position"][1]+xOffset; coin.y = object["position"][2]; coin.name = "coin"
			physics.addBody( coin, "static", { isSensor = true } )
		end
              --  for i=1, #level[sectionInt]["ladders"] do
		--	local object = level[sectionInt]["ladders"][i]
		--	local ladder = display.newImageRect(objectGroup, "images/flag.png", object["widthHeight"][1], object["widthHeight"][2])
                  --  ladder:setReferencePoint(display.BottomCenterReferencePoint);
		--	ladder.x = object["position"][1]+xOffset; 
		  --      ladder.y = object["position"][2]; ladder.name = "ladder"
		--	physics.addBody(ladder, "static", { isSensor = true } )
		--end
                for i=1, #level[sectionInt]["ladders"] do
            local object = level[sectionInt]["ladders"][i]
            local ladder = display.newImageRect(objectGroup, object["filename"], object["widthHeight"][1], object["widthHeight"][2])
            ladder:setReferencePoint(display.BottomCenterReferencePoint);
            ladder.x = object["position"][1]+xOffset; ladder.y = object["position"][2];
            physics.addBody(ladder, "static", {density=0.004, friction=0.3, bounce=0, isSensor =true} )
            ladder.name = "ladder"
        end
                
                
		for i=1, #level[sectionInt]["spikes"] do
			local object = level[sectionInt]["spikes"][i]
			local spike = display.newImageRect(objectGroup, "images/spikes.png", object["widthHeight"][1], object["widthHeight"][2])
			spike:setReferencePoint(display.BottomCenterReferencePoint);
			spike.x = object["position"][1]+xOffset; 
			spike.y = object["position"][2]; spike.name = "spike"
			physics.addBody( spike, "static", { isSensor = true } )
		end
		for i=1, #level[sectionInt]["enemies"] do
			local object = level[sectionInt]["enemies"][i]
			local enemy = display.newSprite(enemySheet, enemySprite)
			enemy:setReferencePoint(display.BottomCenterReferencePoint);
			enemy.x = object["position"][1]+xOffset; enemy.y = object["position"][2]; 
			enemy.name = "enemy"; enemy.allowedMovement = object["allowedMovement"]
			enemy.speed = object["speed"]; enemy.travelled = 0;
			physics.addBody( enemy, "static", { isSensor = true } )
			enemy:setSequence("stand"); enemy:play()
			enemyGroup:insert(enemy)
		end
		for i=1, #level[sectionInt]["flags"] do
			local object = level[sectionInt]["flags"][i]
			local flag = display.newImageRect(objectGroup, "images/flag.png", object["widthHeight"][1], object["widthHeight"][2])
			flag:setReferencePoint(display.BottomCenterReferencePoint);
			flag.x = object["position"][1]+xOffset; 
			flag.y = object["position"][2]; flag.name = "flag"
			physics.addBody( flag, "static", { isSensor = true } )
		end
	end

	--CreateGame makes all the backgrounds etc.
	--This is also called when we reset the game.
	local function createGame()
		--Background and floor and extras
		bg1 = display.newImageRect(firstGroup, "images/bg1.jpg", 480, 320)
		bg1:setReferencePoint(display.TopLeftReferencePoint); bg1.x = 0; bg1.y = 0
		bg2 = display.newImageRect(firstGroup, "images/bg2.jpg", 480, 320)
		bg2:setReferencePoint(display.TopLeftReferencePoint); bg2.x = 480; bg2.y = 0

		extra1 = display.newImageRect(firstGroup, "images/extra.png", 480, 90)
		extra1:setReferencePoint(display.BottomLeftReferencePoint); extra1.x = 0; extra1.y = _H-40
		extra2 = display.newImageRect(firstGroup, "images/extra2.png", 480, 90)
		extra2:setReferencePoint(display.BottomLeftReferencePoint); extra2.x = 480; extra2.y = _H-40

		ground1 = display.newImageRect(extraGroup, "images/floor.png", 480, 48)
		ground1:setReferencePoint(display.TopLeftReferencePoint); ground1.x = 0; ground1.y = _H-48; ground1.name = "floor"
		physics.addBody( ground1,  "static", { friction=0.1, bounce=0} )
		ground2 = display.newImageRect(extraGroup, "images/floor.png", 480, 48)
		ground2:setReferencePoint(display.TopLeftReferencePoint); ground2.x = 480; ground2.y = _H-48; ground2.name = "floor"
		physics.addBody( ground2,  "static", { friction=0.1, bounce=0} )

		
		--Now create the player sprite!
		player = display.newSprite(playerSheet, playerSprite)
		player:setReferencePoint(display.BottomCenterReferencePoint)
		player.x = 140; player.y = _H*0.7; player.name = "player";
		player:setSequence("stand"); player:play()
		extraGroup:insert(player); 

		local playerShape = { -16,-28, 16,-28, 16,31, -16,31 }
		physics.addBody( player,  "dynamic", { friction=1, bounce=0, shape=playerShape} )	
		player.isFixedRotation = true 	--To stop it rotating when jumping etc
		player.isSleepingAllowed = false --To force it to update and fall off playforms correctly.
   
		--Create a section straight away..
		createSection()
	end
	createGame()



	--------------------------------------------
	-- *** D-PAD Setup ***
	-- Allows you to move and jump, also scrolls the background along.
	--------------------------------------------
	--Move everything function. Moves the level etc.
	local function moveEverything()
		--Check sides and change the level speed accordingly.
		if moveSide == "left" then 
			levelspeed = levelspeed +1
			if levelspeed > runSpeed then levelspeed = runSpeed end
		else
			levelspeed = levelspeed -1
			if levelspeed < -runSpeed then levelspeed = -runSpeed end
		end

	
		--Move backgrounds, called from the checks below this function.
		local function moveBackgrounds()
			--Move the other items and platforms. 
			--If they are far left of the screen we remove them.
			local i
			for i = objectGroup.numChildren,1,-1 do
				local object = objectGroup[i]
				if object ~= nil and object.y ~= nil then
					object:translate( levelspeed, 0)
					if object.x < -480 then  
						display.remove(object); object = nil; 
					end
				end
			end
			--Now move the enemies
			for i = enemyGroup.numChildren,1,-1 do
				local enemy = enemyGroup[i]
				if enemy ~= nil and enemy.y ~= nil then
					enemy:translate( levelspeed, 0)
					if enemy.x < -480 then 
						display.remove(enemy); enemy = nil; 
					end
				end
			end

			--Move the backgrounds...
			--We then check to see if they need to be replaced.
			bg1:translate(levelspeed*0.6,0) 	
			bg2:translate(levelspeed*0.6,0) 
			ground1:translate(levelspeed,0)
			ground2:translate(levelspeed,0) 
			extra1:translate(levelspeed,0)
			extra2:translate(levelspeed,0)
			distChange = distChange - levelspeed --Holds the distance moved.
			distChange2 = distChange2 - levelspeed
			
			if ground1.x <= -480 then ground1.x = ground1.x + 960; extra1.x = extra1.x + 960
			elseif ground1.x >= 480 then ground1.x = ground1.x - 960; extra1.x = extra1.x - 960 end
			if ground2.x <= -480 then ground2.x = ground2.x + 960; extra2.x = extra2.x + 960
			elseif ground2.x >= 480 then ground2.x = ground2.x - 960; extra2.x = extra2.x - 960 end
			if bg1.x <= -480 then bg1.x = bg1.x + 960 
			elseif bg1.x >= 480 then bg1.x = bg1.x - 960 end
			if bg2.x <= -480 then bg2.x = bg2.x + 960 
			elseif bg2.x >= 480 then bg2.x = bg2.x - 960 end

			--If distChange2 is over 480 then create a new section.
			--We dont create them in the opposite direction.
			if distChange2 > 480 then
				sectionInt = sectionInt + 1
				if sectionInt <= #level then createSection() end
				distChange2 = 0
			end
		end


		--Now move everything, but only if its within the level bounds!!
		--If it isn't we only move the player up to the boundary. We also stop the screen
		--from going left. Forcing the player to advance through the game.
		if moveSide == "right" then

			if player.x < _W*0.5 then
				player:translate(-levelspeed,0) 
			elseif distChange >= level.screenBounds[2] then
				if player.x >= _W then player.x = _W
				elseif player.x <= (_W*0.5)-1 then  player.x = _W*0.5; moveBackgrounds()
				else player:translate(-levelspeed,0) end
			else
				moveBackgrounds()
			end

		elseif moveSide == "left" then
			if player.x <= 0 then player.x = 0
			elseif player.x >= _W then player.x = _W-1
                    else player:translate(-levelspeed,0) end
                elseif moveSide == "up" and onaLadder== true then
                --  print("climb up")
                 -- player:setLinearVelocity( 1, 1 )
                --  player.y = player.y + 2
               --   player:applyForce(0,-1, player.x, player.y)
                --  player:setSequence("climb"); player:play()
                --  player.xScale = 1
                 -- player.onaLadder = true
                  player:setSequence("climb"); player:play()
                  player.xScale = 1
		  player.BodyType="kinematic"
                  player.gravityScale = 0
		  player.y = player.y -4
                  player.onaLadder = true

                elseif moveSide == "down" and onaLadder==true then
                  --print("climb down")
                  player:setSequence("climb"); player:play()
                  player.xScale = 1
		  player.BodyType="kinematic"
                  player.gravityScale = 0
		  player.y = player.y + 4
                  player.onaLadder = true
		end
	end

	--Button function. Called from the left and right buttons
	local function moveButton(event)
		local t = event.target 

		--Only allow this to occur if we haven't died etc.
		if movementAllowed then 
			if event.phase == "began" and moving == false then
				display.getCurrentStage():setFocus( t, event.id )
				t.isFocus = true; t.alpha = 0.6
				moving = true

				moveSide = t.dir --Set the side variable.
				moveTimer = timer.performWithDelay(1, moveEverything, 0) --Timer for forcing movement

				--Change the sprite animation depending on the direction.
				player:setSequence("run"); player:play()
				if t.dir == "right" then player.xScale = 1
				else player.xScale = -1 end

			elseif t.isFocus and moving == true then
				if event.phase == "ended" or event.phase == "cancelled" then
					display.getCurrentStage():setFocus( t, nil )
					t.isFocus = false; t.alpha = 1
					moving = false

					--Cancel the timer/reset vars
					if moveTimer then timer.cancel(moveTimer); moveTimer=nil; end
					player:setSequence("stand"); player:play() --Reset the sprite to standing as well.
					levelspeed = 0
				end
			end

		--If we aren't allowed to move we need to stop the focus.
		--If you dont there is a risk of a crash as the scene changes (if your still pressing the button)
		else
			display.getCurrentStage():setFocus( t, nil )
		end
		return true
	end

	--Create the movement buttons.
	local jumpButton = display.newImageRect(extraGroup, "images/jbutton.png", 54, 54)
	jumpButton.x = _W-38; jumpButton.y = _H-24;
	jumpButton:addEventListener("touch", playerJump)

	local leftButton = display.newImageRect(extraGroup, "images/left.png", 54, 54)
	leftButton.x = 28; leftButton.y = _H-24; leftButton.dir = "left"
	leftButton:addEventListener("touch", moveButton)

	local rightButton = display.newImageRect(extraGroup, "images/right.png", 54, 54)
	rightButton.x = leftButton.x+74; rightButton.y = _H-24; rightButton.dir = "right"
	rightButton:addEventListener("touch", moveButton)
        
        local upButton = display.newImageRect(extraGroup, "images/up.png", 50, 50)
	upButton.x = 162; upButton.y = _H-24; upButton.dir = "up"
	upButton:addEventListener("touch", moveButton)

	local downButton = display.newImageRect(extraGroup, "images/down.png", 50, 50)
	downButton.x = upButton.x+74; downButton.y = _H-24; downButton.dir = "down"
	downButton:addEventListener("touch", moveButton)
        
        
        
        local kickButton = display.newImageRect(extraGroup, "images/gbutton.png", 54, 54)
	kickButton.x = _W-110; kickButton.y = _H-24;
	kickButton:addEventListener("touch", playerKick)
        
end


 
-- Called immediately after scene has moved onscreen:
-- Start timers/transitions etc.
function scene:enterScene( event )
	print( "Game: enterScene event" )


	-- Completely remove the previous scene/all scenes.
	-- Handy in this case where we want to keep everything simple.
	storyboard.removeAll()


	--------------------------------------------
	-- ***GAMELOOP Runtime Listener***
	--Controls the movement of the enemies.
	--------------------------------------------
	function gameLoop()
		if gameIsActive == true then
			local i
			for i = enemyGroup.numChildren,1,-1 do
				local enemy = enemyGroup[i]
				if enemy ~= nil and enemy.y ~= nil then
					enemy:translate( enemy.speed, 0)

					--Check to see if the enemy needs to change its direciton.
					enemy.travelled = enemy.travelled + enemy.speed

					if enemy.travelled >= enemy.allowedMovement or enemy.travelled <= -enemy.allowedMovement then
						enemy.speed = -enemy.speed 
						enemy.xScale = -enemy.xScale
						enemy.travelled = 0
					end
				end
			end
		end
	end
	Runtime:addEventListener("enterFrame",gameLoop)


	--------------------------------------------
	-- ***COLLISION FUNCTIONS AND START/STOP***
	--What happens when we get hit essentially
	--------------------------------------------
	--Game over and we died...
	local function gameOver()
		--Play the sound..
		overChannel = audio.play(overSound)
                levelScore = score
		gameTime = gameT
                print (score)
                --- lost a life
                lives = lives -1

		--Stop the gameloop/collision
		gameIsActive = false
		gameOverCalled = true
		movementAllowed = false --Stops the movement buttons from working.
		if moveTimer then timer.cancel(moveTimer); moveTimer = nil; end
                
		--Rotate and make it look like a death animation..
		--After the delay/slow down we show the gameOver screen.
		local function nowEnd()
			--Delay the level change
			timer.performWithDelay(1400, function() storyboard.gotoScene( "gameOver", "slideLeft", 400 )  end, 1)
		end

		--Stop the player and create a weird death animation.
		player:pause()
		player:setLinearVelocity( 0, 0 )
		player:applyForce(0,-4, player.x, player.y)
		local trans = transition.to(player, {time=1000, rotation=90, onComplete=nowEnd})
	end

	--Game won as we got to the tree!!
	local function gameWon()
		--Play the sound..
		winChannel = audio.play(winSound)

		--Stop the gameloop/collision
		gameIsActive = false
		gameOverCalled = true
		movementAllowed = false --Stops the movement buttons from working.
		if moveTimer then timer.cancel(moveTimer); moveTimer = nil; end

		--Change the players animation
		player:setSequence("stand"); player:play()

		--Set the global score variable to what we just got...
		levelScore = score

		--Delay the level change
		timer.performWithDelay(1800, function() storyboard.gotoScene( "gameWon", "slideLeft", 400 )  end, 1)
	end

	--Change Score function.. Handy function for collision.
	local function changeText(amount)
		if amount ~= nil then
			score = score + amount
			scoreText.text = "Score: "..score
			scoreText:setReferencePoint(display.CenterLeftReferencePoint)
			scoreText.x = 6
		end
	end
	--Quick coin creation function. Used in the below collision function
	--when the player hits a special box.
	local function createCoin(x,y)
		--Creation needs to be delayed slightly so the world isn't "Number crunching"
		local function createNow()
			local coin = display.newImageRect(objectGroup, "images/euro.png", 30, 30)
			coin:setReferencePoint(display.BottomCenterReferencePoint);
			coin.x = x; coin.y = y-60; coin.name = "coin"
			physics.addBody( coin, "static", { isSensor = true } )
		end
		timer.performWithDelay(10, createNow, 1)
	end




	--Collision functon. Controls hitting the blocks and coins etc. Also resets the jumping
	function onCollision(event)
            
            
             if event.phase == "ended" then
            local name1 = event.object1.name
            local name2 = event.object2.name

            if name1 == "ladder" or name2 == "ladder" then
                if name1 == "player" or name2 == "player" then
                    onaLadder = false
                    --print("on Ladder = false")
        	    player.gravityScale = 1
                end
            end
        end
             --print("in coll")

		if event.phase == "began" and gameIsActive == true and gameOverCalled == false then
			local name1 = event.object1.name
			local name2 = event.object2.name 
                        
                        
                if name1 == "ladder" or name2 == "ladder" then
                if name1 == "player" or name2 == "player" then
                    onaLadder = true
                 --   print("at Ladder = true")
                end
            end

            print ("incollisison")
            if name1 == "bullet" or name2=="bullet" then
            	if name1=="enemy" or name2 =="enemy" then
            		print("GOTCHA")
            		display.remove(event.object2); event.object2 = nil
                    display.remove(event.object1); event.object1 = nil
                    laserChannel = audio.play(gotchaSound)
                    changeText(-5)
            	end
            end
                                                    
                            
			if name1 == "player" or name2 == "player" then 
				--Hit the floor we reset the jump. Hit a block we run some checks to see
				--what we should actually be doing.
				if name1 == "floor" or name2 == "floor" or name1 == "block" or name2 == "block" then
					--Resets your jump. Only do this if its the floor or top of a block.
					local function resetJump()
						singleJump, doubleJump = false, false
						if floorHit == false then
							floorHit = true
					
							if moving == true then player:setSequence("run") 
							else player:setSequence("stand") end
							player:play()
						end
					end

					--Run some checks to see what we should be doing once we collide with a block.
					--We do different things depending on the block and where we hit it from.
					if name1 == "block" or name2 == "block" then
						--We check to see if it was hit from the bottom. If it was we do different things to it.
						if name1 == "player" then
							--We check to see if it was above or below.
							if player.y < event.object2.y-(event.object2.height*0.5) then 
								resetJump() 

							--If we it was below the box, we also check to make sure the collision was central.
							elseif player.y >= event.object2.y+(event.object2.height*0.5)+1 then
								if player.x > event.object2.x-(event.object2.width*0.5) and player.x < event.object2.x+(event.object2.width*0.5) then
									if event.object2.type == "breakable" then --If its breakable we remove it. You could also play an animation here.
										display.remove(event.object2); event.object2 = nil;
									elseif event.object2.type == "special" then --If its special we spawn a coin on top!!
										if event.object2.spawned == false then 
											event.object2.spawned = true
											createCoin( event.object2.x, event.object2.y)
										end
									end
									changeText(10)
								end
							end
						else
							--We check to see if it was above or below.
							if player.y < event.object1.y-(event.object1.height*0.5) then 
								resetJump() 

							--If we it was below the box, we also check to make sure the collision was central.
							elseif player.y >= event.object1.y+(event.object1.height*0.5)+1 then
								if player.x > event.object1.x-(event.object1.width*0.5) and player.x < event.object1.x+(event.object1.width*0.5) then	
									if event.object1.type == "breakable" then --If its breakable we remove it. You could also play an animation here.
										display.remove(event.object1); event.object1 = nil;
									elseif event.object1.type == "special" then --If its special we spawn a coin on top!!
										if event.object1.spawned == false then 
											event.object1.spawned = true
											createCoin( event.object1.x, event.object1.y)
										end
									end
									changeText(10)
								end
							end
						end 
					--It was the floor so reset the jump now..
					else
						--Else if its the floor just reset.
						resetJump()
					end

				--Picking up coins...
				elseif name1 == "coin" or name2 == "coin" then
					if name1 == "coin" then display.remove(event.object1); event.object1 = nil; 
					else display.remove(event.object2); event.object2 = nil; end
					coinChannel = audio.play(coinSound)
					changeText(50)
					
				--Player hits the spikes
				elseif name1 == "spike" or name2 == "spike" then
					--Kill player...
					gameOver()
                                --Player hits an enemy 
				elseif name1 == "enemy" or name2 == "enemy" then
					--Check to see if we jumped ontop of the enemy.
					if name1 == "enemy" then
						--Check to see if we jumped ontop of the enemy
						if player.y < event.object1.y-(event.object1.height*0.5) then 
							display.remove(event.object1); event.object1 = nil
                                                        coinChannel = audio.play(gotchaSound)
							changeText(10)
						else
							gameOver()  	
						end
					else
						--Check to see if we jumped ontop of the enemy
						if player.y < event.object2.y-(event.object2.height*0.5) then 
							display.remove(event.object2); event.object2 = nil
							changeText(10)
						else
							gameOver()  	
						end
					end

				--Player hits the flag! We end the game and set it to won!
				elseif name1 == "flag" or name2 == "flag" then
					gameWon()
				end
			end
		end
	end
	Runtime:addEventListener("collision",onCollision)
end



-- Called when scene is about to move offscreen:
-- Cancel Timers/Transitions and Runtime Listeners etc.
function scene:exitScene( event )
	print( "Game: exitScene event" )
	
	--Stop our timer
	if moveTimer then timer.cancel(moveTimer); moveTimer = nil; end

	--Stop any loops/listeners from running
	Runtime:removeEventListener( "collision", onCollision )
	Runtime:removeEventListener("enterFrame", gameLoop)

	--Stop any sounds.
	audio.stop(overChannel)
	audio.stop(coinChannel)
	audio.stop(jumpChannel)
	audio.stop(winChannel)
        audio.stop(laserChannel)
    --    audio.stop(gotchaChannel)
end



--Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	print( "Game: destroying view" )
	audio.dispose(winSound); winSound=nil
	audio.dispose(overSound); overSound=nil
	audio.dispose(coinSound); coinSound=nil
	audio.dispose(jumpSound); jumpSound=nil
end




-----------------------------------------------
-- Add the story board event listeners
-----------------------------------------------
scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )



--Return the scene to storyboard.
return scene
