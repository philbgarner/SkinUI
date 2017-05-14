
skinui = require "lib.SkinUI"
win1 = nil

bgimage = love.graphics.newImage("bgimage.png")

function love.load()
  
  skinui:load()
  skinui:add(skinui.Window:new("win1", 25, 25, skinui.theme))
  local text1 = skinui.Textinput:new("text1", 25, 25, skinui.theme)
  skinui:addChild("win1", text1)
  
  local btnOK = skinui.Button:new("btnOK", 25, 70, skinui.theme)
  function btnOK:onclick()
    text1:set("text", "OK button was clicked!")
  end
  btnOK:set("text", "OK")
  skinui:addChild("win1", btnOK)

  local textbox1 = skinui.Container:new("textbox1", 25, 115, skinui.theme)
  textbox1:size(550, 125)
  skinui:addChild("win1", textbox1)

  skinui:get("win1"):size(725, 250)
end

function love.draw()
  
  love.graphics.draw(bgimage, 0, 0)
  skinui:draw()
  
end

function love.textinput(t)
  
  skinui:textinput(t)
  
end

function love.keypressed(key, scancode)
  
  skinui:keypressed(key, scancode)
  
end

function love.mousereleased(x, y, button, istouch)
  
  skinui:mousereleased(x, y, button, istouch)
  
end

function love.mousepressed(x, y, button, istouch)
  
  skinui:mousepressed(x, y, button, istouch)
  
end

function love.mousemoved(x, y, dx, dy, istouch)
  
  skinui:mousemoved(x, y, dx, dy, istouch)
  
end

function love.update(dt)
  
  skinui:update(dt)
  
end
