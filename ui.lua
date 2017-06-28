function testButton(i,v,x,y)
  local polygon = {[1] = {x = v.x, y = v.y}, [2] = {x = v.x + v.width, y = v.y}, [3] = {x = v.x + v.width, y = v.y + v.height}, [4] = {x = v.x, y = v.y + v.height}}
  if CrossingsMultiplyTest(polygon, x, y) == true then
    v.image = v.down
    v.y = v.y + 4
    downtile = v
    downshape = polygon
  end
end
