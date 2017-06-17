--[[

  Container class
  
  Use as a parent for controls which can be scrolled.
  Clips contents.
  
  By Phil Garner
  May 2017
  
  
]]--

local Container = {}
Container.__index = Container

function Container:new(id, x, y, theme)
  
  local win = {
      
      props = {
          id = id
          ,resizable = false
          ,width = theme:get("images").bg_image:getWidth()
          ,height = theme:get("images").bg_image:getHeight()
          ,left = x
          ,top = y
          ,scrollx = 0
          ,scrolly = 0
          ,opacity = 1
          ,alwaysontop = false
          ,bg_autosize = false  -- If not autosize, then it tiles when the Container exceeds the background image size.
          ,theme = theme
          ,canvas = nil
          ,quad = nil
          
          ,windows = {}
          ,window_focusid = ""
          
          ,hidden = false
          
          ,hasFocus = false

        }
    
    }
  setmetatable(win, Container)
  
  win:render()
  return win
  
end

function Container:set(prop, val)

  self.props[prop] = val
  
  return true
  
end

function Container:get(prop)
    
  if self.props[prop] == nil then
    return false
  end
  
  return self.props[prop]
  
end

function Container:find(id) 
  local wnd = self:get("windows")
  for i=1, #wnd do
    if wnd[i]:get("id") == id then
      return i
    end
  end
  
  return false
end

function Container:size(w, h)
  if w <= 0 then w = 1 end
  if h <= 0 then h = 1 end
  self:set("width", w)
  self:set("height", h)
  self:render()
end

-- Master method
function Container:focus()
  self:set("hasFocus", true)
  self:onfocus()
end
-- User defined method.
function Container:onfocus()
  
end

-- Master method
function Container:blur()
  self:set("hasFocus", false)
  self:onblur()
end
-- User defined method.
function Container:onblur()
  
end
  
-- Master method
function Container:resize()
  self:onresize()
end
-- User defined method.
function Container:onresize()
  
end

-- Master method
function Container:click(x, y, button, istouch)
  local wnd = self:get("windows")
  local wx = self:get("left")
  local wy = self:get("top")
  for i=1, #wnd do
    if x >= wnd[i]:get("left") + wx and y >= wnd[i]:get("top") + wy and x <= wnd[i]:get("left") + wnd[i]:get("width") + wx and y <= wnd[i]:get("top") + wnd[i]:get("height") + wy then
      wnd[i]:onclick(x, y, button, istouch)
      return
    end
  end
  
  self:onclick(x, y, button, istouch)

end
-- User defined method.
function Container:onclick(x, y, button, istouch)
--  print(self:get("id"))
--  print("click")
end

-- Master method
function Container:load()
  self:onload()
end
-- User defined method.
function Container:onload()
  
end

-- Master method
function Container:unload()
  self:set("canvas", nil)
  self:onunload()
end
-- User defined method.
function Container:onunload()
  
end

-- Love2d Hook Methods

function Container:mousepressed(x, y, button, istouch)
--  print(self:get("id"))
--  print("mousedown")

end

function Container:mousemoved(x, y, dx, dy, istouch)
--  print(self:get("id"))
--  print("mousemoved")

end

function Container:mousereleased(x, y, button, istouch)
--  print(self:get("id"))
--  print("mouseup")

end

function Container:update(dt)

  local wins = self:get("windows")

  if #wins > 0 then
    for i=#wins, 1, -1 do
      wins[i]:update(dt)
    end
  end
end

function Container:keypressed(key, scancode)
  
  local wins = self:get("windows")

  if #wins > 0 then
    for i=1, #wins do
      if wins[i]:get("hasFocus") then
        wins[i]:keypressed(key, scancode)
        return
      end
    end
  end
  
end

function Container:textinput(t)
  local wins = self:get("windows")

  if #wins > 0 then
    for i=1, #wins do
      if wins[i]:get("hasFocus") then
        wins[i]:textinput(t)
        return
      end
    end
  end
  
end

function Container:draw(x, y)
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

  local wins = self:get("windows")

  if #wins > 0 then
    for i=#wins, 1, -1 do
      wins[i]:draw(self:get("left") + x, self:get("top") + y)
    end
  end
  
  love.graphics.setScissor(scx, scy, scw, sch)
end

-- Pre-render Container for draw method.  Call this when your Container is dirty.
function Container:render(scale)
  if scale == nil then scale = 1 end
  
  local canv = love.graphics.newCanvas(self:get("width"), self:get("height"))
  local thm = self:get("theme")
  local q = love.graphics.newQuad(
      0
      ,0
      ,self:get("width") - thm:get("images").textbox_nw:getWidth() - thm:get("images").textbox_ne:getWidth()
      ,self:get("height") - thm:get("images").textbox_nw:getHeight() - thm:get("images").textbox_ne:getHeight()
      ,thm:get("images").textbox_bg:getWidth() - thm:get("images").textbox_nw:getWidth() - thm:get("images").textbox_ne:getWidth()
      ,thm:get("images").textbox_bg:getHeight() - thm:get("images").textbox_nw:getHeight() - thm:get("images").textbox_ne:getHeight()
    )
  local qnw = love.graphics.newQuad(
      0
      ,0
      ,thm:get("images").textbox_nw:getWidth()
      ,thm:get("images").textbox_nw:getHeight()
      ,thm:get("images").textbox_nw:getWidth()
      ,thm:get("images").textbox_nw:getHeight()
    )
  local qne = love.graphics.newQuad(
      0
      ,0
      ,thm:get("images").textbox_ne:getWidth()
      ,thm:get("images").textbox_ne:getHeight()
      ,thm:get("images").textbox_ne:getWidth()
      ,thm:get("images").textbox_ne:getHeight()
    )
  local qsw = love.graphics.newQuad(
      0
      ,0
      ,thm:get("images").textbox_sw:getWidth()
      ,thm:get("images").textbox_sw:getHeight()
      ,thm:get("images").textbox_sw:getWidth()
      ,thm:get("images").textbox_sw:getHeight()
    )
  local qse = love.graphics.newQuad(
      0
      ,0
      ,thm:get("images").textbox_se:getWidth()
      ,thm:get("images").textbox_se:getHeight()
      ,thm:get("images").textbox_se:getWidth()
      ,thm:get("images").textbox_se:getHeight()
    )
  local be = love.graphics.newQuad(
      0
      ,0
      ,thm:get("images").textbox_se:getWidth()
      ,self:get("height") - thm:get("images").textbox_se:getHeight() - thm:get("images").textbox_se:getHeight()
      ,thm:get("images").textbox_e:getWidth()
      ,thm:get("images").textbox_e:getHeight()
    )
  local bw = love.graphics.newQuad(
      0
      ,0
      ,thm:get("images").textbox_w:getWidth()
      ,self:get("height") - thm:get("images").textbox_se:getHeight() - thm:get("images").textbox_ne:getHeight()
      ,thm:get("images").textbox_w:getWidth()
      ,thm:get("images").textbox_w:getHeight()
    )
  local bs = love.graphics.newQuad(
      0
      ,0
      ,self:get("width") - thm:get("images").textbox_se:getWidth() - thm:get("images").textbox_ne:getWidth()
      ,thm:get("images").textbox_s:getHeight()
      ,thm:get("images").textbox_s:getWidth()
      ,thm:get("images").textbox_s:getHeight()
    )
  local bn = love.graphics.newQuad(
      0
      ,0
      ,self:get("width") - thm:get("images").textbox_se:getWidth() - thm:get("images").textbox_ne:getWidth()
      ,thm:get("images").textbox_n:getHeight()
      ,thm:get("images").textbox_n:getWidth()
      ,thm:get("images").textbox_n:getHeight()
    )
  
  love.graphics.setCanvas(canv)
    love.graphics.draw(thm:get("images").textbox_bg, q, thm:get("images").textbox_nw:getWidth(), thm:get("images").textbox_nw:getHeight())
    
    love.graphics.draw(thm:get("images").textbox_ne, qne, self:get("width") - thm:get("images").textbox_ne:getWidth(), 0)
    love.graphics.draw(thm:get("images").textbox_nw, qnw, 0, 0)
    love.graphics.draw(thm:get("images").textbox_sw, qsw, 0, self:get("height") - thm:get("images").textbox_sw:getHeight())
    love.graphics.draw(thm:get("images").textbox_se, qse, self:get("width") - thm:get("images").textbox_se:getWidth(), self:get("height") - thm:get("images").textbox_se:getHeight())
    
    love.graphics.draw(thm:get("images").textbox_w, bw, 0, thm:get("images").textbox_nw:getHeight())
    love.graphics.draw(thm:get("images").textbox_e, be, self:get("width") - thm:get("images").border_e:getWidth(), thm:get("images").textbox_ne:getHeight())
    love.graphics.draw(thm:get("images").textbox_s, bs, thm:get("images").textbox_sw:getWidth(), self:get("height") - thm:get("images").textbox_s:getHeight())
    love.graphics.draw(thm:get("images").textbox_n, bn, thm:get("images").textbox_nw:getWidth(), 0)
    
  love.graphics.setCanvas()
  self:set("canvas", love.graphics.newImage(canv:newImageData()))
  self:set("quad", q)
  
end

return Container