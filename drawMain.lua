function drawScore()
  love.graphics.rectangle("line", scorePanel.x, scorePanel.y, scorePanel.width, scorePanel.height, 10, 10)
  for i, v in pairs(topButtons) do
    love.graphics.draw(v.image, v.x, v.y)
    if v.text then
      love.graphics.print(v.text, v.x + 10, v.y + 5)
    end
  end
  love.graphics.print("Wood: "..resources.wood.amount, 150, 10)
  love.graphics.print("Stone: "..resources.stone.amount, 250, 10)
  love.graphics.print("Metal: "..resources.metal.amount, 350, 10)
  love.graphics.print("Unobtanium: "..resources.unob.amount, 450, 10)
  love.graphics.print("Level: "..player.level, 650, 10)
end

function drawMap()
  local function hexStencil()
    love.graphics.rectangle("fill", 10, 40, 600, 450, 10, 10)
  end
  love.graphics.rectangle("line", 10, 40, 600, 450, 10, 10)
  love.graphics.stencil(hexStencil, "replace", 1)
  love.graphics.setStencilTest("greater", 0)

  mapview = {}
  for i = -3, 4 do
    mapview[i] = {}
  end

  for i = 0, 5 do
    mapview[ - 3][i - 2] = {x = -330 + (i * 60), y = (-58 + i * 104)}
    mapview[ - 2][i - 2] = {x = -210 + (i * 60), y = (-58 + i * 104)}
    mapview[ - 1][i - 2] = {x = -90 + (i * 60), y = (-58 + i * 104)}
    mapview[0][i - 2] = {x = 30 + (i * 60), y = (-58 + i * 104)}
    mapview[1][i - 2] = {x = 150 + (i * 60), y = (-58 + i * 104)}
    mapview[2][i - 2] = {x = 270 + (i * 60), y = (-58 + i * 104)}
    mapview[3][i - 2] = {x = 390 + (i * 60), y = (-58 + i * 104)}
    mapview[4][i - 2] = {x = 510 + (i * 60), y = (-58 + i * 104)}

  end

  for y in pairs(mapview) do
    for z in pairs(mapview[y]) do
      i = player.tileX + y
      v = player.tileY + z
      if tiles[i] == nil then
        tiles[i] = {}
      end
      if tiles[i][v] == nil then
        tiles[i][v] = newTile()
      end
      mapview[y][z].tileX = i
      mapview[y][z].tileY = v
      love.graphics.draw(tileTypes[tiles[i][v].typenum].png, mapview[y][z].x, mapview[y][z].y)

    end
  end
  love.graphics.setColor( 0, 0, 255)
  for i in pairs(mapview) do
    for v in pairs(mapview[i]) do
      local x = tonumber(i)
      local y = tonumber(v)
      if - 1 <= x and x <= 1 then
        if math.max(-1, - x-1) <= y and y <= math.min(1, - x + 1) then


          love.graphics.line(mapview[i][v].x, mapview[i][v].y + 35, mapview[i][v].x + 60, mapview[i][v].y, mapview[i][v].x + 119, mapview[i][v].y + 35, mapview[i][v].x + 119, mapview[i][v].y + 105, mapview[i][v].x + 60, mapview[i][v].y + 139, mapview[i][v].x, mapview[i][v].y + 105, mapview[i][v].x, mapview[i][v].y + 35)
        end
      end
    end
  end
love.graphics.setColor(255, 255, 255 )
  for y in pairs(mapview) do
    for z in pairs(mapview[y]) do
      local i = mapview[y][z].tileX
      local v = mapview[y][z].tileY
      if tiles[i][v].upgrade.typenum ~= 1 then
        love.graphics.draw(tileUpgradeTypes[tiles[i][v].upgrade.typenum].png, mapview[y][z].x + tiles[i][v].upgrade.x, mapview[y][z].y + tiles[i][v].upgrade.y)
      end
      if tiles[i][v].city then
        love.graphics.draw(graphics.city, mapview[y][z].x, mapview[y][z].y + 15)
      end
    end
  end
  love.graphics.draw(playerModels[player.pngnum].png, mapview[0][0].x + 30, mapview[0][0].y + 20, 0, .75, .75)

  -- Only allow rendering on pixels which have a stencil value greater than 0.
  love.graphics.setStencilTest()
end

function drawInfo()

  local tileinfo = {
    {text = "Tile Type: ", var = tileTypes[tiles[player.tileX][player.tileY].typenum].name},
    {text = "Tile location: ", var = player.tileX..","..player.tileY},
    {text = "Tile Wood: ", var = tiles[player.tileX][player.tileY].wood * tileUpgradeTypes[tiles[player.tileX][player.tileY].upgrade.typenum].wood * resources.wood.mult},
    {text = "Tile Stone: ", var = tiles[player.tileX][player.tileY].stone * tileUpgradeTypes[tiles[player.tileX][player.tileY].upgrade.typenum].stone * resources.stone.mult},
    {text = "Tile Metal: ", var = tiles[player.tileX][player.tileY].metal * tileUpgradeTypes[tiles[player.tileX][player.tileY].upgrade.typenum].metal * resources.metal.mult},
    {text = "Tile Unobtanium: ", var = tiles[player.tileX][player.tileY].unob * tileUpgradeTypes[tiles[player.tileX][player.tileY].upgrade.typenum].unob * resources.unob.mult},
  }
  local mod = -1
  for i = 1, #tileinfo do
    local v = tileinfo[i]
    mod = mod + 1
    love.graphics.print(v.text..v.var, infoPanel.x + infoPanel.width * 0.5 + 10, infoPanel.y + (15 * mod) + 5)
  end
  for i, v in pairs(infoButtons) do
    love.graphics.draw(v.image, v.x, v.y)
    if v.text then
      love.graphics.print(v.text, v.x + 10, v.y + 5)
    end
  end
  love.graphics.rectangle("line", infoPanel.x, infoPanel.y, infoPanel.width, infoPanel.height, 10, 10)

end
