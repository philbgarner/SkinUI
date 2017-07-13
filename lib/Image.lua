--[[

  Image class
  
  By Phil Garner
  May 2017
  
  
]]--

local Image = {}
Image.__index = Image

function Image:new(id, x, y, theme)
  
  local win = {
      
      props = {
          id = id
          ,resizable = false
          ,width = 1
          ,height = 1
          ,left = x
          ,top = y
          ,opacity = 1
          ,alwaysontop = false
          ,bg_autosize = false  -- If not autosize, then it tiles when the Image exceeds the background image size.
          ,theme = theme
          ,canvas = nil
          
          ,image = nil
          
          ,text = ""

          ,fontColr = {255, 255, 255, 255}
          
          ,hidden = false
          
          ,font = love.graphics.getFont()
          
          ,hasFocus = false
          ,downSprite = false
        }
    
    }
  setmetatable(win, Image)
  
  win:render()
  win:load()
  return win
  
end

function Image:set(prop, val)
  if prop ~= "image" then
    self.props[prop] = val
  else
    if type(val) == "string" then
      self.props[prop] = love.graphics.newImage(val)
      self:set("width", self.props[prop]:getWidth())
      self:set("height", self.props[prop]:getHeight())
      self:render(1)
    elseif type(val) == "userdata" then
      self.props[prop] = val
      self:set("width", self.props[prop]:getWidth())
      self:set("height", self.props[prop]:getHeight())
      self:render(1)
    end
  end
  
  return true
  
end

function Image:get(prop)
    
  if self.props[prop] == nil then
    return false
  end
  
  return self.props[prop]
  
end

function Image:size(w, h)
  self:set("width", w)
  self:set("height", h)
  self:render()
end

-- Master method
function Image:resize()
  self:onresize()
end
-- User defined method.
function Image:onresize()
  
end

-- Master method
function Image:blur()
  self:set("hasFocus", false)
  self:onblur()
end
-- User defined method.
function Image:onblur()
  
end

-- Master method
function Image:focus()
  self:set("hasFocus", true)
  self:onfocus()
end
-- User defined method.
function Image:onfocus()
  
end

-- Master method
function Image:click(x, y, Image, istouch)
  self:onclick(x, y, Image, istouch)
end
-- User defined method.
function Image:onclick(x, y, Image, istouch)
  print(self:get("id"))
  print("click")
end

-- Master method
function Image:load()
  self:onload()
end
-- User defined method.
function Image:onload()
  
end

-- Master method
function Image:unload()
  self:set("image", nil)
  self:set("canvas", nil)
  self:onunload()
end
-- User defined method.
function Image:onunload()
  
end

-- Love2d Hook Methods

function Image:textinput(t)
  
end

function Image:mousepressed(x, y, Image, istouch)

  self:render()
end

function Image:mousemoved(x, y, dx, dy, istouch)
--  print(self:get("id"))
--  print("mousemoved")
end

function Image:mousereleased(x, y, Image, istouch)

  self:render()
end

function Image:update(dt)

end

function Image:keypressed(key, scancode)
  
  print(self:get("id"))
  print(key, scancode)
  
end

function Image:textinput(t)
  
end

function Image:draw(x, y)
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
  local colr = self:get("fontColr")
  love.graphics.setColor(colr[1], colr[2], colr[3], colr[4])
  love.graphics.print(self:get("text"), self:get("left") + x, self:get("top") + y)
  love.graphics.setColor(255, 255, 255)
  love.graphics.setScissor(scx, scy, scw, sch)
end

-- Pre-render Image for draw method.  Call this when your Image is dirty.
function Image:render(scale)
  if scale == nil then scale = 1 end
  
  local canv = love.graphics.newCanvas(self:get("width"), self:get("height"))
  local thm = self:get("theme")

  
  love.graphics.setCanvas(canv)
  
    local img = self:get("image")
    if img ~= nil and img ~= false then
      love.graphics.draw(img, 0, 0)
    end
    
  love.graphics.setCanvas()
  self:set("canvas", love.graphics.newImage(canv:newImageData()))

  
end

return Image