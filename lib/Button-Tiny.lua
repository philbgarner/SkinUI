--[[

  Button-Tiny class
  
  By Phil Garner
  May 2017
  
  
]]--

local ButtonTiny = {}
ButtonTiny.__index = ButtonTiny

function ButtonTiny:new(id, x, y, theme)
  
  local win = {
      
      props = {
          id = id
          ,resizable = false
          ,width = theme:get("images").button_tiny:getWidth()
          ,height = theme:get("images").button_tiny:getHeight()
          ,left = x
          ,top = y
          ,opacity = 1
          ,alwaysontop = false
          ,bg_autosize = false  -- If not autosize, then it tiles when the ButtonTiny exceeds the background image size.
          ,theme = theme
          ,canvas = nil
          ,quad = nil
          
          ,text = ""
          
          ,hidden = false
          
          ,hasFocus = false
          ,downSprite = false
        }
    
    }
  setmetatable(win, ButtonTiny)
  
  win:render()
  win:load()
  return win
  
end

function ButtonTiny:set(prop, val)

  self.props[prop] = val
  
  return true
  
end

function ButtonTiny:get(prop)
    
  if self.props[prop] == nil then
    return false
  end
  
  return self.props[prop]
  
end

function ButtonTiny:size(w, h)
  self:set("width", w)
  self:set("height", h)
  self:render()
end

-- Master method
function ButtonTiny:resize()
  self:onresize()
end
-- User defined method.
function ButtonTiny:onresize()
  
end

-- Master method
function ButtonTiny:blur()
  self:set("hasFocus", false)
  self:onblur()
end
-- User defined method.
function ButtonTiny:onblur()
  
end

-- Master method
function ButtonTiny:focus()
  self:set("hasFocus", true)
  self:onfocus()
end
-- User defined method.
function ButtonTiny:onfocus()
  
end

-- Master method
function ButtonTiny:click(x, y, button, istouch)
  self:onclick(x, y, button, istouch)
end
-- User defined method.
function ButtonTiny:onclick(x, y, button, istouch)
  print(self:get("id"))
  print("click")
end

-- Master method
function ButtonTiny:load()
  self:onload()
end
-- User defined method.
function ButtonTiny:onload()
  
end

-- Master method
function ButtonTiny:unload()
  self:set("canvas", nil)
  self:onunload()
end
-- User defined method.
function ButtonTiny:onunload()
  
end

-- Love2d Hook Methods

function ButtonTiny:textinput(t)

  
end

function ButtonTiny:mousepressed(x, y, button, istouch)
--  print(self:get("id"))
--  print("mousedown")
  self:set("downSprite", true)
  self:render()
end

function ButtonTiny:mousemoved(x, y, dx, dy, istouch)
--  print(self:get("id"))
--  print("mousemoved")
end

function ButtonTiny:mousereleased(x, y, button, istouch)
--  print(self:get("id"))
--  print("mouseup")
  self:set("downSprite", false)
  self:render()
end

function ButtonTiny:update(dt)
  if self:get("downSprite") and not love.mouse.isDown(1) then
    self:set("downSprite", false)
    self:render()
  end
end

function ButtonTiny:keypressed(key, scancode)
  
  print(self:get("id"))
  print(key, scancode)
  
end

function ButtonTiny:ButtonTiny(t)
  
  self:set("text", self:get("text") .. t)
  
end

-- Master method.
function ButtonTiny:draw(x, y)
  if x == nil then x = 0 end
  if y == nil then y = 0 end
  
  local scx, scy, scw, sch = love.graphics.getScissor( )

  local nw = self:get("width")
  local nh = self:get("height")
  if nw + self:get("left") + x < scw + scx 
      and nh + self:get("top") + y < sch + scy 
  then
    love.graphics.setScissor(self:get("left") + x, self:get("top") + y, nw, nh)
  end
  love.graphics.draw(self:get("canvas"), self:get("left") + x, self:get("top") + y)
  love.graphics.setColor(25, 25, 25)
  local fnt = love.graphics.getFont()
  local cx = self:get("width") / 2 - fnt:getWidth(self:get("text")) / 2
  local cy = 0
  if self:get("downSprite") then
    cx = cx + 2
    cy = 2
  end
  love.graphics.print(self:get("text"), self:get("left") + cx + x, self:get("top") + 8 + y + cy)
  love.graphics.setColor(255, 255, 255)
  love.graphics.setScissor(scx, scy, scw, sch)
  
  self:ondraw(x, y)
end

-- User defined method.
function ButtonTiny:ondraw(x, y)
  
end

-- Pre-render ButtonTiny for draw method.  Call this when your ButtonTiny is dirty.
function ButtonTiny:render(scale)
  if scale == nil then scale = 1 end
  
  local canv = love.graphics.newCanvas(self:get("width"), self:get("height"))
  local thm = self:get("theme")
  local q = love.graphics.newQuad(
      0
      ,0
      ,self:get("width")
      ,self:get("height")
      ,thm:get("images").button_tiny:getWidth()
      ,thm:get("images").button_tiny:getHeight()
    )
  
  love.graphics.setCanvas(canv)
    if not self:get("downSprite") then
      love.graphics.draw(thm:get("images").button_tiny, q, 0, 0)
    else
      love.graphics.draw(thm:get("images").button_down_tiny, q, 0, 0)
    end
  love.graphics.setCanvas()
  self:set("canvas", love.graphics.newImage(canv:newImageData()))
  self:set("quad", q)
  
end

return ButtonTiny