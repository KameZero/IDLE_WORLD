function save(quit)
  local bitser = require 'bitser'

  local save = {}
  save.player = player
  save.tiles = tiles
  save.peasants = peasants
  save.resources = resources
save.cities=cities
  bitser.dumpLoveFile("save.dat", save)
  if quit == 1 then
    love.event.quit()
  end
end

function load()
  local bitser = require 'bitser'

  local gamedata = bitser.loadLoveFile('save.dat')
  player = gamedata.player
  tiles = gamedata.tiles
  peasants = gamedata.peasants
  resources = gamedata.resources
  cities=gamedata.cities
end
