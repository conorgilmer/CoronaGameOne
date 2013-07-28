-------------------------------------------------------------------------
-- gameOver.lua
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


--Variables etc we needs
local _W = display.contentWidth --Width and height parameters
local _H = display.contentHeight 



------------------------------------------------
-- *** STORYBOARD SCENE EVENT FUNCTIONS ***
------------------------------------------------
-- Called when the scene's view does not exist:
-- Create all your display objects here.
function scene:createScene( event )
	print( "gameOver: createScene event")
	local screenGroup = self.view
    
	--------
	-- *** Create the background and Restart/Menu Button ***
	--------
        if lives <= 0 then
        --Background image first...
	local bg1 = display.newImageRect( "images/gameOver.jpg", 480,320)
	bg1.x = _W*0.5; bg1.y = _H*0.5
        lives =3 --reset for new game
	screenGroup:insert(bg1)
	local scoreText = display.newText(screenGroup, "You Scored "..levelScore ,0,0,"Arial",19)
	scoreText:setReferencePoint(display.CenterLeftReferencePoint); scoreText:setTextColor(50)
	scoreText.x = (_W/2)-85; scoreText.y = (_H/2)+20

	local timerText = display.newText(screenGroup, "Time: "..gameTime ,0,0,"Arial",19)
	timerText:setReferencePoint(display.CenterLeftReferencePoint); timerText:setTextColor(50)
	timerText.x = (_W/2)-85; timerText.y = (_H/2)+ 40
        
        else
        --Background image first...
	local bg1 = display.newImageRect( "images/gameKilled.jpg", 480,320)
	bg1.x = _W*0.5; bg1.y = _H*0.5
	screenGroup:insert(bg1)
	
	--Restart/Menu button
	local function gotoGame() storyboard.gotoScene( "game", "slideLeft", 400 ) end
	local playGame = display.newRect(0,0, 280, 80)
	playGame.x = _W*0.5; playGame.y = _H*0.66; playGame.alpha = 0.01
	playGame:addEventListener("tap", gotoGame)
	screenGroup:insert(playGame)
         
        -- cg added lives counter
        local livesText = display.newText(screenGroup, "You Have "..lives.. " lives left." ,0,0,"Arial",19)
	livesText:setReferencePoint(display.CenterLeftReferencePoint); livesText:setTextColor(50)
	livesText.x = (_W/2)-85; livesText.y = (_H/2)-55
         -- cg added score counter
        local scoreText = display.newText(screenGroup, "Score: "..levelScore ,0,0,"Arial",19)
	scoreText:setReferencePoint(display.CenterLeftReferencePoint); scoreText:setTextColor(50)
	scoreText.x = (_W/2)-85; scoreText.y = (_H/2)-35

	local timerText = display.newText(screenGroup, "Time: "..gameTime ,0,0,"Arial",19)
	timerText:setReferencePoint(display.CenterLeftReferencePoint); timerText:setTextColor(50)
	timerText.x = (_W/2)-85; timerText.y = (_H/2)-15

        
        end
	
	local function gotoMenu() storyboard.gotoScene( "menu", "slideRight", 400 ) end
	local menu = display.newRect(0,0, 80, 30)
	menu.x = 40; menu.y = _H-24; menu.alpha = 0.01
	menu:addEventListener("tap", gotoMenu)
	screenGroup:insert(menu)
end


-- Called immediately after scene has moved onscreen:
-- Start timers/transitions etc.
function scene:enterScene( event )
	print( "gameOver: enterScene event" )

	-- Completely remove the previous scene/all scenes.
	-- Handy in this case where we want to keep everything simple.
	storyboard.removeAll()
end

-- Called when scene is about to move offscreen:
-- Cancel Timers/Transitions and Runtime Listeners etc.
function scene:exitScene( event )
	print( "gameOver: exitScene event" )
end

--Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	print( "gameOver: destroying view" )
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
