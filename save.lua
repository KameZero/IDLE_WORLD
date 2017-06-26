function save(quit)
  local bitser = require 'bitser'
  local save = {}

  save.player = player
  save.peasants = peasants
  save.resources = resources
  save.cities = cities
  bitser.dumpLoveFile("save.dat", save)
  bitser.dumpLoveFile("tiles.dat", tiles)

  save = nil
  if quit == 1 then
    love.event.quit()
  end
end

function load()
  local bitser = require 'bitser'

  local gamedata = bitser.loadLoveFile('save.dat')
  player = gamedata.player
  tiles = bitser.loadLoveFile("tiles.dat", save)
  peasants = gamedata.peasants
  resources = gamedata.resources
  cities = gamedata.cities
  gamedata = nil
end
