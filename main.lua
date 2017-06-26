function love.load()
  --setup windows settings
  love.window.setMode(900, 700)
  love.window.setTitle("IDLE_WORLD")
  sw, sh = love.graphics.getDimensions()

  -- load up all of the .lua files we're suing
  require("pointwithinshape")
  require("map")
  require("save")
  require("newgame")
  require("tileUpgrades")
  require("drawMain")
  require("tileCity")



  -- Load up our drawables from assets
  graphics = {}
  graphics.player = love.graphics.newImage('assets/player.png')
  graphics.wood = love.graphics.newImage('assets/wood.png')
  graphics.quit = love.graphics.newImage('assets/quit.jpg')
  graphics.stone = love.graphics.newImage('assets/stone.png')
  graphics.metal = love.graphics.newImage('assets/metal.png')
  graphics.unob = love.graphics.newImage('assets/unob.png')
  graphics.peasant = love.graphics.newImage('assets/peasant.png')
  graphics.up = love.graphics.newImage('assets/up.png')
  graphics.down = love.graphics.newImage('assets/down.png')
  graphics.upgrade = love.graphics.newImage('assets/upgrade.png')
  graphics.upgradedown = love.graphics.newImage('assets/upgrade_down.png')
  graphics.city = love.graphics.newImage('assets/town.png')

  -- Setup UI elements, this will need to be moved to different functions and put in the respective draw files
  buttons = {} --here's where you'll store all your buttons
  buttons["quit"] = buttonnew(0, 0, 100, 30, save, graphics.quit, graphics.quit,1)
  buttons["upgrade"] = buttonnew(25, 470, 190, 45, newCity, graphics.upgrade, graphics.upgradedown, "2", "Chop dat wood boooois")
  buttons["mine"] = buttonnew(25, 470, 190, 45, newCity, graphics.upgrade, graphics.upgradedown, "2", "Chop dat wood boooois")
  buttons["wood"] = buttonnew(sw - 125, 25, 111, 128, resourceClick, graphics.wood, graphics.wood, "wood")
  buttons["stone"] = buttonnew(sw - 125, 163, 111, 128, resourceClick, graphics.stone, graphics.stone, "stone")
  buttons["metal"] = buttonnew(sw - 125, 301, 111, 128, resourceClick, graphics.metal, graphics.metal, "metal")
  buttons["unob"] = buttonnew(sw - 125, 439, 111, 128, resourceClick, graphics.unob, graphics.unob, "unob")
  buttons["peasant"] = buttonnew(sw - 110, 575, 80, 110, newpeasant, graphics.peasant, graphics.peasant)
  buttons["woodup"] = buttonnew(sw - 178, 73, 15, 10, peasantadd, graphics.up, graphics.up, "wood")
  buttons["wooddown"] = buttonnew(sw - 178, 103, 15, 10, peasantsell, graphics.down, graphics.down, "wood")
  buttons["stoneup"] = buttonnew(sw - 178, 211, 15, 10, peasantadd, graphics.up, graphics.up, "stone")
  buttons["stonedown"] = buttonnew(sw - 178, 241, 15, 10, peasantsell, graphics.down, graphics.down, "stone")
  buttons["metalup"] = buttonnew(sw - 178, 349, 15, 10, peasantadd, graphics.up, graphics.up, "metal")
  buttons["metaldown"] = buttonnew(sw - 178, 379, 15, 10, peasantsell, graphics.down, graphics.down, "metal")
  buttons["unobup"] = buttonnew(sw - 178, 487, 15, 10, peasantadd, graphics.up, graphics.up, "unob")
  buttons["unobdown"] = buttonnew(sw - 178, 517, 15, 10, peasantsell, graphics.down, graphics.down, "unob")
  --Organized as:"x", "y", "width", "height", "function to run when clicked", "drawable" ,"Drawable when clicked" ,
  --"arguments for function", "any text that should be on the button"

  --init any variables we need
  autoGatherTime = 0
  autosaveTime = 0

  -- load a save if there is one, start a new game otherwise
  if love.filesystem.exists( "save.dat" ) then
    load()
  else
    newgame()
  end
end

-- here we put in anything we want run when the mouse is DOWN
function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    -- this changes any button that is clicked to change to it's down drawable and move down by 4 pixels giving us a nice click
    for i, v in pairs(buttons) do
      local polygon = {[1] = {x = v.x, y = v.y}, [2] = {x = v.x + v.width, y = v.y}, [3] = {x = v.x + v.width, y = v.y + v.height}, [4] = {x = v.x, y = v.y + v.height}}
      if CrossingsMultiplyTest(polygon, x, y) == true then
        v.image = v.down
        v.y = v.y + 4
        downtile = v
        downshape = polygon
      end
    end
    --This checks for any clicks on the map rather than on buttons
    local mapPoly = {
      [1] = {x = 10, y = 40},
      [2] = {x = 10, y = 440},
      [3] = {x = 510, y = 440},
      [4] = {x = 510, y = 40}
    }
    if CrossingsMultiplyTest(mapPoly, x, y) then
      for i in pairs(mapview) do
        for v in pairs(mapview[i]) do
          local polygon = {
            [1] = {x = mapview[i][v].x, y = mapview[i][v].y + 35},
            [2] = {x = mapview[i][v].x + 60, y = mapview[i][v].y},
            [3] = {x = mapview[i][v].x + 119, y = mapview[i][v].y + 35},
            [4] = {x = mapview[i][v].x + 119, y = mapview[i][v].y + 105},
            [5] = {x = mapview[i][v].x + 60, y = mapview[i][v].y + 139},
            [6] = {x = mapview[i][v].x, y = mapview[i][v].y + 105}
          }
          if CrossingsMultiplyTest(polygon, x, y) == true then

            playerMove(i, v)


          end
        end
      end
    end
  end
end

function playerMove(x, y)
  --this simply moves the player.tileX and player.tile to the coordinates clicked on during the mousedown
  player.tileX = mapview[x][y].tileX
  player.tileY = mapview[x][y].tileY
end

function love.mousereleased(x, y, button, istouch)
  --this does a few thing when the mouse is released. namely bringing any buttons that were clicked back to their default
  --position and drawable
  if downtile then
    downtile.image = downtile.up
    if CrossingsMultiplyTest(downshape, x, y) == true then
      downtile.click()
    end
    if downtile.y then
      downtile.y = downtile.y - 4
    end
  end
  downtile = nil
  downshape = nil
end

function newpeasant()
  peasantcost = 1 + peasants.free.total^2
  if resources.wood.amount >= peasantcost then
    resources.wood.amount = resources.wood.amount - peasantcost
    peasants.free.amount = peasants.free.amount + 1
    peasants.free.total = peasants.free.total + 1
  end
end
function peasantadd(t)
  if peasants.free.amount > 0 then
    peasants[t].amount = peasants[t].amount + 1
    peasants.free.amount = peasants.free.amount - 1
  end
end

function peasantsell(t)
  if peasants[t].amount > 0 then
    peasants.free.amount = peasants.free.amount + 1
    peasants[t].amount = peasants[t].amount - 1
  end
end

function buttonnew(x, y, w, h, f, u, d, a, t)
  local self = {}
  self.x = x
  self.y = y
  self.width = w
  self.height = h
  self.fun = f
  self.image = u
  self.down = d
  self.up = u
  self.arguments = a
  self.click = function()
    if self.fun then
      if self.arguments then
        self.fun(self.arguments)
      else
        self.fun()
      end
    end
  end
  self.text = t
  return self
end

function resourceClick(x)
  resources[x].amount = resources[x].amount + (1 * resources[x].mult * tiles[player.tileX][player.tileY][x] * tileUpgradeTypes[tiles[player.tileX][player.tileY].upgrade.typenum][x])
  player.level = player.level + 1
end

function upgrade()

end

function autoGather()
  for i, v in pairs(resources) do
    v.amount = v.amount + peasants[i].amount * peasants[i].quality * v.mult

  end
  autoGatherTime = 0
end
function love.update(dt)
  autoGatherTime = autoGatherTime + dt
  if autoGatherTime > 1 then
    autoGather()
  end
  autosaveTime = autosaveTime + dt
  if autosaveTime > 15 then
    save ()
  end
end

function love.draw()
  drawMap()

  drawScore()
  love.graphics.print("Free Peasants: "..peasants.free.amount, 620, 650)
  love.graphics.print("Wood Peasants: "..peasants.wood.amount, 620, 86)
  love.graphics.print("Stone Peasants: "..peasants.stone.amount, 620, 224)
  love.graphics.print("Metal Peasants: "..peasants.metal.amount, 620, 362)
  love.graphics.print("Unobtanium Peasants: "..peasants.unob.amount, 580, 500)

  for i, v in pairs(buttons) do

    love.graphics.draw(v.image, v.x, v.y)
    if v.text then
      love.graphics.print(v.text, v.x + 10, v.y + 10)
    end
  end
  drawInfo()

end

function love.keypressed( key )
end
