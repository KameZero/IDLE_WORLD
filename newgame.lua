function newgame()
  peasants = {
    wood = {amount = 0, quality = 1},
    stone = {amount = 0, quality = 1},
    metal = {amount = 0, quality = 1},
    unob = {amount = 0, quality = 1},
    free = {amount = 0, total = 0}
  }
  resources = {
    wood = {amount = 0, mult = 8},
    stone = {amount = 0, mult = 4},
    metal = {amount = 0, mult = 2},
    unob = {amount = 0, mult = 1},
  }

  player = {level = 1, tileX = 0, tileY = 0, pngnum = 1
  }
  tiles = {}
  cities = {}
  save()
end
