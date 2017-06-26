function save()
  local bitser = require 'bitser'

  local save = {}
  save.player = player
  save.tiles = tiles
  save.peasants = peasants
  save.resources = resources

  bitser.dumpLoveFile("save.dat", save)
end

function load()
  local bitser = require 'bitser'

  local gamedata = bitser.loadLoveFile('save.dat')
  player = gamedata.player
  tiles = gamedata.tiles
  peasants = gamedata.peasants
  resources = gamedata.resources
end
