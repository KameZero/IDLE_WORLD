function love.load()
  --setup windows settings
  love.window.setMode(900, 700)
  love.window.setTitle("IDLE_WORLD")
  sw, sh = love.graphics.getDimensions()

  -- load up all of the .lua files we're using
  require("pointwithinshape")
  require("map")
  require("save")
  require("newgame")
  require("tileUpgrades")
  require("drawMain")
  require("tileCity")
  require("ui")
  require("load")

  loadGraphics()
  loadUI()
  loadVars()
  loadSave()
end

-- here we put in anything we want run when the mouse is DOWN
function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    -- this changes any button that is clicked to change to it's down drawable and move down by 4 pixels giving us a nice click
    for i, v in pairs(infoButtons) do
      testButton(i,v,x,y)
    end
    for i, v in pairs(resourceButtons) do
      testButton(i,v,x,y)
    end
    --This checks for any clicks on the map rather than on buttons
    local mapPoly = {
      [1] = {x = 10, y = 40},
      [2] = {x = 10, y = 490},
      [3] = {x = 610, y = 490},
      [4] = {x = 610, y = 40}
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

function buttonnew(x, y, w, h, f, u, d, a, t,uin)
  local self = {}
  self.x = x+5
  self.y = y + 5 + ((h + 10) * uin)
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
  drawInfo()

  love.graphics.print("Free Peasants: "..peasants.free.amount, 620, 650)
  love.graphics.print("Wood Peasants: "..peasants.wood.amount, 620, 86)
  love.graphics.print("Stone Peasants: "..peasants.stone.amount, 620, 224)
  love.graphics.print("Metal Peasants: "..peasants.metal.amount, 620, 362)
  love.graphics.print("Unobtanium Peasants: "..peasants.unob.amount, 580, 500)

  for i, v in pairs(resourceButtons) do

    love.graphics.draw(v.image, v.x, v.y)
    if v.text then
      love.graphics.print(v.text, v.x + 10, v.y + 10)
    end
  end

end

function love.keypressed( key )
end
