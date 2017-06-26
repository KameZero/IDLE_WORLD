function newCity()
  local x = player.tileX
  local y = player.tileY
  if tiles[x][y].city == nil then
    local name = "test"..love.math.random(1, 3)
    cities[name] = {x = x, y = y}
    tiles[x][y].city = {name = name}
  end
end

function drawCity(name)
  love.graphics.draw(graphics.city, x, y, r, sx, sy, ox, oy, kx, ky)
end
