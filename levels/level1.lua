-------------------------------------------------------------------------
-- level1.lua
--
-- Berlin - Mario Style Game for the Digital Skills Academy
-- by Conor Gilmer (conor.gilmer@gmail.com)
--
-- 28th of July 2013
--
--CoronaSDK version 2013.1076 (2013.4.3) was used for project.
--Based on the Template given by the DSA from T and G Apps Ltd.
--
-- There are 8 Levels in this game
--
-------------------------------------------------------------------------


--Localise the module. Elimates the need for module package seeall technique.
local M = {}


--This array holds each different screens information. Each screen is 480 pixels wide!
--The movement function in game.lua calls creates each of these screens in turn.
--E.g. blocks/special blocks/obstacles/stars positions...
--You can easily add your own by copying and pasting mine to make the game more interesting!
M = {
	------------------------------------------
	--Screen 1
	------------------------------------------
	{
		--There are 3 different types of block. Select which one you want per block.
		--"breakable" - Are blocks that you can smash
		--"special" - Is a block that a coin will come out of once.
		--"pushable" - A special block you can push around.
		--"plain" - Is a normal block that does nothing.
		blocks = {
			{
				filename = "images/block_green_brick.png",
				type = "breakable",
				widthHeight = {50,50},
				position ={50,160},
			},
			{
				filename = "images/block_green_brick.png",
				type = "breakable",
				widthHeight = {50,50},
				position ={100,160},
			},
			{
				filename = "images/block_green_question.png",
				type = "special",
				widthHeight = {50,50},
				position ={150,160},
			},
			{
				filename = "images/block_green_brick.png",
				type = "breakable",
				widthHeight = {50,50},
				position ={200,160},
			},
			{
				filename = "images/block_green_brick.png",
				type = "breakable",
				widthHeight = {50,50},
				position ={250,160},
			},
		},
                       ladders = {
                        {
                                filename = "images/ladder.png",
                                widthHeight = {40,150},
                                position = {250,270},
                        },
                         
		},

                
          
		--Create the Coins for this screen. Leave blank for none.
		coins = {
		},
		--Create the Spikes for this screen. Leave blank for none.
		spikes = {
		},
		--Create some enemies. Very basic walking. Don't create too close to blocks!
		--To change the enemies you would have to edit the createSections function in game.lua
		--Currently they are set to one imageSheet for animations, you could easily add more for more enemies.
		enemies = {
			{
				widthHeight = {50,48},
				position ={250,276},
				allowedMovement = 180, --How far left-right the enemy can walk.
				speed = -2 --How fast they walk. Start walking left.
			},
		},
		--Create the level end. (flag) Should only have one of these and in the last screen you make.
		flags = {
		},
		--You can add more categories here. Just remember to add them into the
		--creationSections function in the game.lua file.
	},

	-------------------------------------------
	--Screen 2
	-------------------------------------------
	{
		--Create the blocks for this screen. Leave blank for none.
		blocks = {
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={150,276},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={200,276},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={250,276},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={300,276},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={200,226},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={250,226},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={300,226},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={250,176},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={300,176},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={300,126},
			},
		},
                ladders ={},
		--Create the Coins for this screen. Leave blank for none.
		coins = {
			{	
				widthHeight = {30,42},
				position = {150,216},
			},
			{	
				widthHeight = {30,42},
				position = {200,166},
			},
			{	
				widthHeight = {30,42},
				position = {250,116},
			},
			{	
				widthHeight = {30,42},
				position = {300,66},
			},
		},
		--Create the Spikes for this screen. Leave blank for none.
		spikes = {
			{	
				widthHeight = {50,16},
				position = {350,276},
			},	
			{	
				widthHeight = {50,16},
				position = {400,276},
			},	
		},
		--Create some enemies. Very basic walking. Don't create too close to blocks!
		enemies = {
		},
		--Create the level end. (flag) Should only have one of these and in the last screen you make.
		flags = {
		},
	},

	-------------------------------------------
	--Screen 3
	-------------------------------------------
	{
		--Create the blocks for this screen. Leave blank for none.
		blocks = {
			{
				filename = "images/block_green_brick.png",
				type = "breakable",
				widthHeight = {50,50},
				position ={50,160},
			},
			{
				filename = "images/block_green_brick.png",
				type = "breakable",
				widthHeight = {50,50},
				position ={100,160},
			},
			{
				filename = "images/block_green_question.png",
				type = "special",
				widthHeight = {50,50},
				position ={150,160},
			},
			{
				filename = "images/block_green_question.png",
				type = "special",
				widthHeight = {50,50},
				position ={200,160},
			},
			{
				filename = "images/block_green_question.png",
				type = "special",
				widthHeight = {50,50},
				position ={250,160},
			},
			{
				filename = "images/block_push.png",
				type = "pushable",
				widthHeight = {50,50},
				position ={300,260},
			},
			{
				filename = "images/block_push.png",
				type = "pushable",
				widthHeight = {50,50},
				position ={300,200},
			},
		},
                ladders ={},
		--Create the Coins for this screen. Leave blank for none.
		coins = {
		},
		--Create the Spikes for this screen. Leave blank for none.
		spikes = {
		},
		--Create some enemies. Very basic walking. Don't create too close to blocks!
		enemies = {
		},
		--Create the level end. (flag) Should only have one of these and in the last screen you make.
		flags = {
		},
	},


	-------------------------------------------
	--Screen 4
	-------------------------------------------
	{
		--Create the blocks for this screen. Leave blank for none.
		blocks = {
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={150,276},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={250,276},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={350,276},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={450,276},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={150,226},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={250,226},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={350,226},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={450,226},
			},
		},
                ladders ={},
		--Create the Coins for this screen. Leave blank for none.
		coins = {
			{	
				widthHeight = {30,42},
				position = {150,166},
			},
			{	
				widthHeight = {30,42},
				position = {250,166},
			},
			{	
				widthHeight = {30,42},
				position = {350,166},
			},
			{	
				widthHeight = {30,42},
				position = {450,166},
			},
		},
		--Create the Spikes for this screen. Leave blank for none.
		spikes = {
			{	
				widthHeight = {50,16},
				position = {100,276},
			},
			{	
				widthHeight = {50,16},
				position = {200,276},
			},	
			{	
				widthHeight = {50,16},
				position = {300,276},
			},	
			{	
				widthHeight = {50,16},
				position = {400,276},
			},	
		},
		--Create some enemies. Very basic walking. Don't create too close to blocks!
		enemies = {
		},
		--Create the level end. (flag) Should only have one of these and in the last screen you make.
		flags = {
		},
	},

	-------------------------------------------
	--Screen 5
	--This is going to be the last screen for this
	--level, so all i do is make a tree! (end point)
	-------------------------------------------
	{
		--Create the blocks for this screen. Leave blank for none.
		blocks = {

	{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={400,276},
			},

		},

		--Create the Ladders for this screen. Leave blank for none.
                ladders ={
		},
		--Create the Coins for this screen. Leave blank for none.
		coins = {
		},
		--Create the Spikes for this screen. Leave blank for none.
		spikes = {
	{	
				widthHeight = {50,16},
				position = {200,276},
			},	

		},
		--Create some enemies. Very basic walking. Don't create too close to blocks!
		enemies = {
		},
		--Create the level end. (flag) Should only have one of these and in the last screen you make.
		--To edit its appearance and functions you would have to edit the createSection function in the game.lua file.
		flags = {
		},
	}, --  screen 5 ends

	-------------------------------------------
	--Screen 6
	-------------------------------------------
	{
		--Create the blocks for this screen. Leave blank for none.
		blocks = {
	{
				filename = "images/block_push.png",
				type = "pushable",
				widthHeight = {50,50},
				position ={50,270},
			},
			{
				filename = "images/block_push.png",
				type = "pushable",
				widthHeight = {50,50},
				position ={50,210},
			},
			{
				filename = "images/block_push.png",
				type = "pushable",
				widthHeight = {50,50},
				position ={100,250},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={400,276},
			},
			{
				filename = "images/block_grey_plain.png",
				type = "plain",
				widthHeight = {50,50},
				position ={400,226},
			},

		},
		--Create the Ladders for this screen. Leave blank for none.
                ladders ={
		},
		--Create the Coins for this screen. Leave blank for none.
		coins = {
		},
		--Create the Spikes for this screen. Leave blank for none.
		spikes = {
		},
		--Create some enemies. Very basic walking. Don't create too close to blocks!
		enemies = {
		},
		--Create the level end. (flag) Should only have one of these and in the last screen you make.
		flags = {
		},
	}, -- screen six end



	-------------------------------------------
	--Screen 7
	-------------------------------------------
	{
		--Create the blocks for this screen. Leave blank for none.
		blocks = {
		{

	{
				filename = "images/block_push.png",
				type = "pushable",
				widthHeight = {50,50},
				position ={100,250},
			},

				filename = "images/block_green_brick.png",
				type = "breakable",
				widthHeight = {50,50},
				position ={150,160},
			},
			{
				filename = "images/block_green_question.png",
				type = "special",
				widthHeight = {50,50},
				position ={200,160},
			},
		},
		--Create the Ladders for this screen. Leave blank for none.
                ladders ={
		},
		--Create the Coins for this screen. Leave blank for none.
		coins = {
		},
		--Create the Spikes for this screen. Leave blank for none.
		spikes = {
		{	
				widthHeight = {50,16},
				position = {200,276},
			},	
		},
		--Create some enemies. Very basic walking. Don't create too close to blocks!
		enemies = {

			{
				widthHeight = {50,48},
				position ={250,276},
				allowedMovement = 180, --How far left-right the enemy can walk.
				speed = -2 --How fast they walk. Start walking left.
			},
		},
		--Create the level end. (flag) Should only have one of these and in the last screen you make.
		flags = {
		},
	}, -- screen 7 end



	-------------------------------------------
	--Screen 8
	-------------------------------------------
	{
		--Create the blocks for this screen. Leave blank for none.
		blocks = {
		},
		--Create the Ladders for this screen. Leave blank for none.
                ladders ={
		},
		--Create the Coins for this screen. Leave blank for none.
		coins = {
		},
		--Create the Spikes for this screen. Leave blank for none.
		spikes = {
		},
		--Create some enemies. Very basic walking. Don't create too close to blocks!
		enemies = {
		},
		--Create the level end. (bank) Should only have one of these and in the last screen you make.
		flags = {
		{	
				widthHeight = {160,160},
				position = {320,276}, --BottomCenterReferencePoint
			},	


		},
	}, -- screen 8 end





} --all screens


--Set up the screen bounds..
--Limits you going too far left or right. The first one should ALWAYS be 0.
--The second value controls how far right in pixels you can travel. 
--480 = 1 screen, 960 = 2 screens, 1440 = 3 screens, 1920 = 4 screens, 2400 = 5 screens.
--8 screens 3 3840
M.screenBounds = {0,3840}




--Return it all to the game.
return M

