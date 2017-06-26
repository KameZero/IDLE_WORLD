function love.load()
  love.window.setMode(900, 700)
  love.window.setTitle("IDLE_WORLD")

  require("pointwithinshape")
  require("map")
  require("save")
  require("newgame")
  require("tileUpgrades")
  require("drawMain")

  sw, sh = love.graphics.getDimensions()
  -- Load all them sick graphics boooooooooooooooooi
  woodpng = love.graphics.newImage('assets/wood.png')
  quitjpg = love.graphics.newImage('assets/quit.jpg')
  quitjpg = love.graphics.newImage('assets/quit.jpg')
  stonepng = love.graphics.newImage('assets/stone.png')
  metalpng = love.graphics.newImage('assets/metal.png')
  unobpng = love.graphics.newImage('assets/unob.png')
  peasantpng = love.graphics.newImage('assets/peasant.png')
  uppng = love.graphics.newImage('assets/up.png')
  downpng = love.graphics.newImage('assets/down.png')
  upgradepng = love.graphics.newImage('assets/upgrade.png')
  upgradedownpng = love.graphics.newImage('assets/upgrade_down.png')

  -- Load up dat UI elements
  buttons = {} --here's where you'll store all your buttons
  buttons["quit"] = buttonnew(0, 0, 100, 30, love.event.quit, quitjpg, quitjpg)
  buttons["upgrade"] = buttonnew(25, 470, 190, 45, buildUpgrade, upgradepng, upgradedownpng, "2", "Chop dat wood boooois")
  buttons["wood"] = buttonnew(sw - 125, 25, 111, 128, resourceClick, woodpng, woodpng, "wood")
  buttons["stone"] = buttonnew(sw - 125, 163, 111, 128, resourceClick, stonepng, stonepng, "stone")
  buttons["metal"] = buttonnew(sw - 125, 301, 111, 128, resourceClick, metalpng, metalpng, "metal")
  buttons["unob"] = buttonnew(sw - 125, 439, 111, 128, resourceClick, unobpng, unobpng, "unob")
  buttons["peasant"] = buttonnew(sw - 110, 575, 80, 110, newpeasant, peasantpng, peasantpng)
  buttons["woodup"] = buttonnew(sw - 178, 73, 15, 10, peasantadd, uppng, uppng, "wood")
  buttons["wooddown"] = buttonnew(sw - 178, 103, 15, 10, peasantsell, downpng, downpng, "wood")
  buttons["stoneup"] = buttonnew(sw - 178, 211, 15, 10, peasantadd, uppng, uppng, "stone")
  buttons["stonedown"] = buttonnew(sw - 178, 241, 15, 10, peasantsell, downpng, downpng, "stone")
  buttons["metalup"] = buttonnew(sw - 178, 349, 15, 10, peasantadd, uppng, uppng, "metal")
  buttons["metaldown"] = buttonnew(sw - 178, 379, 15, 10, peasantsell, downpng, downpng, "metal")
  buttons["unobup"] = buttonnew(sw - 178, 487, 15, 10, peasantadd, uppng, uppng, "unob")
  buttons["unobdown"] = buttonnew(sw - 178, 517, 15, 10, peasantsell, downpng, downpng, "unob")
  --I organized this way: "x", "y", "width", "height", "function to run when clicked", "drawable" , "arguments in a table or nil"

  autoGatherTime = 0
  autosaveTime = 0
  if love.filesystem.exists( "save.dat" ) then
    load()
  else
    newgame()
  end
end

function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    for i, v in pairs(buttons) do
      local polygon = {[1] = {x = v.x, y = v.y}, [2] = {x = v.x + v.width, y = v.y}, [3] = {x = v.x + v.width, y = v.y + v.height}, [4] = {x = v.x, y = v.y + v.height}}
      if CrossingsMultiplyTest(polygon, x, y) == true then
        v.image = v.down
        v.y = v.y + 4
        downtile = v
        downshape = polygon
      end
    end
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
print(x,y,mapview[x][y].tileX,mapview[x][y].tileY,player.tileX,player.tileY)
  player.tileX = tostring(mapview[x][y].tileX)
  player.tileY = tostring(mapview[x][y].tileY)
end

function love.mousereleased(x, y, button, istouch)
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
    --    save ()
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
