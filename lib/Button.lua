--[[

  Button class
  
  By Phil Garner
  May 2017
  
  
]]--

local Button = {}
Button.__index = Button

function Button:new(id, x, y, theme)
  
  local win = {
      
      props = {
          id = id
          ,resizable = false
          ,width = theme:get("images").button_med:getWidth()
          ,height = theme:get("images").button_med:getHeight()
          ,left = x
          ,top = y
          ,opacity = 1
          ,alwaysontop = false
          ,bg_autosize = false  -- If not autosize, then it tiles when the Button exceeds the background image size.
          ,theme = theme
          ,canvas = nil
          ,quad = nil
          
          ,text = ""
          
          ,hidden = false
          
          ,hasFocus = false
          ,downSprite = false
        }
    
    }
  setmetatable(win, Button)
  
  win:render()
  return win
  
end

function Button:set(prop, val)

  self.props[prop] = val
  
  return true
  
end

function Button:get(prop)
    
  if self.props[prop] == nil then
    return false
  end
  
  return self.props[prop]
  
end

function Button:size(w, h)
  self:set("width", w)
  self:set("height", h)
  self:render()
end

-- Master method
function Button:resize()
  self:onresize()
end
-- User defined method.
function Button:onresize()
  
end

-- Master method
function Button:blur()
  self:set("hasFocus", false)
  self:onblur()
end
-- User defined method.
function Button:onblur()
  
end

-- Master method
function Button:focus()
  self:set("hasFocus", true)
  self:onfocus()
end
-- User defined method.
function Button:onfocus()
  
end

-- Master method
function Button:click(x, y, button, istouch)
  self:onclick(x, y, button, istouch)
end
-- User defined method.
function Button:onclick(x, y, button, istouch)
  print(self:get("id"))
  print("click")
end

-- Master method
function Button:load()
  self:onload()
end
-- User defined method.
function Button:onload()
  
end

-- Master method
function Button:unload()
  self:onunload()
end
-- User defined method.
function Button:onunload()
  
end

-- Love2d Hook Methods

function Button:textinput(t)
  
  self:set("text", self:get("text") .. t)
  
end

function Button:mousepressed(x, y, button, istouch)
--  print(self:get("id"))
--  print("mousedown")
  self:set("downSprite", true)
  self:render()
end

function Button:mousemoved(x, y, dx, dy, istouch)
--  print(self:get("id"))
--  print("mousemoved")
end

function Button:mousereleased(x, y, button, istouch)
--  print(self:get("id"))
--  print("mouseup")
  self:set("downSprite", false)
  self:render()
end

function Button:update(dt)
  if self:get("downSprite") and not love.mouse.isDown(1) then
    self:set("downSprite", false)
    self:render()
  end
end

function Button:keypressed(key, scancode)
  
  print(self:get("id"))
  print(key, scancode)
  
end

function Button:Button(t)
  
  self:set("text", self:get("text") .. t)
  
end

function Button:draw(x, y)
  if x == nil then x = 0 end
  if y == nil then y = 0 end
  
  --love.graphics.setScissor(self:get("left") + x, self:get("top") + y, self:get("width") - 5, self:get("height") - 5)
  love.graphics.draw(self:get("canvas"), self:get("left") + x, self:get("top") + y)
  love.graphics.setColor(25, 25, 25)
  local fnt = love.graphics.getFont()
  local cx = self:get("width") / 2 - fnt:getWidth(self:get("text")) / 2
  local cy = 0
  if self:get("downSprite") then
    cx = cx + 2
    cy = 2
  end
  love.graphics.print(self:get("text"), self:get("left") + cx + x, self:get("top") + 12 + y + cy)
  love.graphics.setColor(255, 255, 255)
  --love.graphics.setScissor()
end

-- Pre-render Button for draw method.  Call this when your Button is dirty.
function Button:render(scale)
  if scale == nil then scale = 1 end
  
  local canv = love.graphics.newCanvas(self:get("width"), self:get("height"))
  local thm = self:get("theme")
  local q = love.graphics.newQuad(
      0
      ,0
      ,self:get("width")
      ,self:get("height")
      ,thm:get("images").button_med:getWidth()
      ,thm:get("images").button_med:getHeight()
    )
  
  love.graphics.setCanvas(canv)
    if not self:get("downSprite") then
      love.graphics.draw(thm:get("images").button_med, q, 0, 0)
    else
      love.graphics.draw(thm:get("images").button_down_med, q, 0, 0)
    end
  love.graphics.setCanvas()
  self:set("canvas", love.graphics.newImage(canv:newImageData()))
  self:set("quad", q)
  
end

return Button