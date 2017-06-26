tileUpgradeTypes = {
  {name = "None", png = nil, wood = 1, stone = 1, metal = 1, unob = 1},
  {name = "Mine", png = love.graphics.newImage('assets/mine.png'), wood = .5, stone = 1, metal = 4, unob = 1.1, cost={wood=1000,stone=1000,metal=1000}},
}


function buildUpgrade(type)
  if tiles[player.tileX][player.tileY].upgrade.typenum == 1 and resources.wood.amount >= tileUpgradeTypes["2"].cost.wood then
    tiles[player.tileX][player.tileY].upgrade = {x = love.math.random(5, 60), y = love.math.random(1, 40) + 25, type}
    resources.wood.amount = resources.wood.amount - 1000
    resources.stone.amount = resources.stone.amount - 1000
    resources.metal.amount = resources.metal.amount - 1000
  end
end
