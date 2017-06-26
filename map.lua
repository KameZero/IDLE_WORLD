tileTypes = {
  {name = "Desert", png = love.graphics.newImage('assets/sand_07.png'), wood = 0.25, stone = 1, metal = 2, unob = 0.1},
  {name = "Rocky Forest", png = love.graphics.newImage('assets/grass_16.png'), wood = 1, stone = 1, metal = 0.5, unob = 0.1}
}



function newTile(x, y, w, h, d, mx, my)
  local self = {}
  self.typenum = love.math.random(1, #tileTypes)
  local type = tileTypes[self.typenum]
  self.wood = love.math.random(1, 3) * type.wood
  self.stone = love.math.random(1, 3) * type.stone
  self.metal = love.math.random(1, 3) * type.metal
  self.unob = love.math.random(1, 3) * type.unob
  self.upgrade = {typenum = 1}
  return self
end

function drawMap()

end
