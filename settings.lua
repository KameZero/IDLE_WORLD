function drawSettings()
  love.graphics.rectangle("fill", settingsPanel.x, settingsPanel.y, settingsPanel.width, settingsPanel.height, 10, 10)

  for i, v in pairs(settingsButtons) do
    love.graphics.draw(v.image, v.x, v.y)
    if v.text then
      love.graphics.print(v.text, v.x + 10, v.y + 10)
    end
  end
end
