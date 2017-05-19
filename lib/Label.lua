--[[

  Label class
  
  By Phil Garner
  May 2017
  
  
]]--

local Label = {}
Label.__index = Label

function Label:new(id, x, y, theme)
  
  local win = {
      
      props = {
          id = id
          ,resizable = false
          ,width = theme:get("images").Label_med:getWidth()
          ,height = theme:get("images").Label_med:getHeight()
          ,left = x
          ,top = y
          ,opacity = 1
          ,alwaysontop = false
          ,bg_autosize = false  -- If not autosize, then it tiles when the Label exceeds the background image size.
          ,theme = theme
          ,canvas = nil
          ,quad = nil
          
          ,text = ""
          
          ,hidden = false
          
          ,hasFocus = false
          ,downSprite = false
        }
    
    }
  setmetatable(win, Label)
  
  win:render()
  win:load()
  return win
  
end

function Label:set(prop, val)

  self.props[prop] = val
  
  return true
  
end

function Label:get(prop)
    
  if self.props[prop] == nil then
    return false
  end
  
  return self.props[prop]
  
end

function Label:size(w, h)
  self:set("width", w)
  self:set("height", h)
  self:render()
end

-- Master method
function Label:resize()
  self:onresize()
end
-- User defined method.
function Label:onresize()
  
end

-- Master method
function Label:blur()
  self:set("hasFocus", false)
  self:onblur()
end
-- User defined method.
function Label:onblur()
  
end

-- Master method
function Label:focus()
  self:set("hasFocus", true)
  self:onfocus()
end
-- User defined method.
function Label:onfocus()
  
end

-- Master method
function Label:click(x, y, Label, istouch)
  self:onclick(x, y, Label, istouch)
end
-- User defined method.
function Label:onclick(x, y, Label, istouch)
  print(self:get("id"))
  print("click")
end

-- Master method
function Label:load()
  self:onload()
end
-- User defined method.
function Label:onload()
  
end

-- Master method
function Label:unload()
  self:onunload()
end
-- User defined method.
function Label:onunload()
  
end

-- Love2d Hook Methods

function Label:textinput(t)
  
end

function Label:mousepressed(x, y, Label, istouch)

  self:render()
end

function Label:mousemoved(x, y, dx, dy, istouch)
--  print(self:get("id"))
--  print("mousemoved")
end

function Label:mousereleased(x, y, Label, istouch)

  self:render()
end

function Label:update(dt)

end

function Label:keypressed(key, scancode)
  
  print(self:get("id"))
  print(key, scancode)
  
end

function Label:textinput(t)
  
end

function Label:draw(x, y)
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
  love.graphics.print(self:get("text"), self:get("left") + cx + x, self:get("top") + 12 + y + cy)
  love.graphics.setColor(255, 255, 255)
  love.graphics.setScissor(scx, scy, scw, sch)
end

-- Pre-render Label for draw method.  Call this when your Label is dirty.
function Label:render(scale)
  if scale == nil then scale = 1 end
  
  local canv = love.graphics.newCanvas(self:get("width"), self:get("height"))
  local thm = self:get("theme")
  local q = love.graphics.newQuad(
      0
      ,0
      ,self:get("width")
      ,self:get("height")
      ,thm:get("images").Label_med:getWidth()
      ,thm:get("images").Label_med:getHeight()
    )
  
  love.graphics.setCanvas(canv)
 
  love.graphics.setCanvas()
  self:set("canvas", love.graphics.newImage(canv:newImageData()))
  self:set("quad", q)
  
end

return Label