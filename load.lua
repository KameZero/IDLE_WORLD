function loadGraphics()

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
end

function loadVars()
  autoGatherTime = 0
  autosaveTime = 0
end

function loadSave()
  if love.filesystem.exists( "save.dat" ) then
    load()
  else
    newgame()
  end
end

function loadUI()

  --set location of UI elements
  infoPanel = {x = 10, y = 500, width = 600, height = 190}
  resourcePanel = {x = sw - 125, y = 25}
  --Load everything from the top bar


  --Load everything from the mapview


  --Load everything from the info panel
  infoButtons = {}
  table.insert(infoButtons, buttonnew(infoPanel.x, infoPanel.y, 190, 45, newCity, graphics.upgrade, graphics.upgradedown, "2", "Chop dat wood boooois", #infoButtons))
  table.insert(infoButtons, buttonnew(infoPanel.x, infoPanel.y, 190, 45, newCity, graphics.upgrade, graphics.upgradedown, "2", "Chop dat wood boooois", #infoButtons))

  -- Load everything from the click area

  resourceButtons = {}
  table.insert(resourceButtons, buttonnew(resourcePanel.x, resourcePanel.y, 111, 128, resourceClick, graphics.wood, graphics.wood, "wood", "", #resourceButtons))
  table.insert(resourceButtons, buttonnew(resourcePanel.x, resourcePanel.y, 111, 128, resourceClick, graphics.stone, graphics.stone, "stone", "", #resourceButtons))
  table.insert(resourceButtons, buttonnew(resourcePanel.x, resourcePanel.y, 111, 128, resourceClick, graphics.metal, graphics.metal, "metal", "", #resourceButtons))
  table.insert(resourceButtons, buttonnew(resourcePanel.x, resourcePanel.y, 111, 128, resourceClick, graphics.unob, graphics.unob, "unob", "", #resourceButtons))
  table.insert(resourceButtons, buttonnew(resourcePanel.x, resourcePanel.y, 111, 128, newpeasant, graphics.peasant, graphics.peasant, "", "", #resourceButtons))
  table.insert(resourceButtons, buttonnew(sw - 178, 73, 15, 10, peasantadd, graphics.up, graphics.up, "wood", "", 0))
  table.insert(resourceButtons, buttonnew(sw - 178, 103, 15, 10, peasantsell, graphics.down, graphics.down, "wood", "", 0))
  table.insert(resourceButtons, buttonnew(sw - 178, 211, 15, 10, peasantadd, graphics.up, graphics.up, "stone", "", 0))
  table.insert(resourceButtons, buttonnew(sw - 178, 241, 15, 10, peasantsell, graphics.down, graphics.down, "stone", "", 0))
  table.insert(resourceButtons, buttonnew(sw - 178, 349, 15, 10, peasantadd, graphics.up, graphics.up, "metal", "", 0))
  table.insert(resourceButtons, buttonnew(sw - 178, 379, 15, 10, peasantsell, graphics.down, graphics.down, "metal", "", 0))
  table.insert(resourceButtons, buttonnew(sw - 178, 487, 15, 10, peasantadd, graphics.up, graphics.up, "unob", "", 0))
  table.insert(resourceButtons, buttonnew(sw - 178, 517, 15, 10, peasantsell, graphics.down, graphics.down, "unob", "", 0))



end
