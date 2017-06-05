--[[

  Window class
  
  By Phil Garner
  May 2017
  
  
]]--

local Window = {}
Window.__index = Window

function Window:new(id, x, y, theme)
  
  local win = {
      
      props = {
          id = id
          ,resizable = false
          ,width = theme:get("images").bg_image:getWidth()
          ,height = theme:get("images").bg_image:getHeight()
          ,left = x
          ,top = y
          ,opacity = 1
          ,alwaysontop = false
          ,bg_autosize = false  -- If not autosize, then it tiles when the window exceeds the background image size.
          ,theme = theme
          ,canvas = nil
          ,quad = nil
          
          ,windows = {}
          ,window_focusid = ""
          
          ,fixed = false
          
          ,hasFocus = false
          
          ,hidden = false
          
          ,resizing_nw = false
          ,resizing_ne = false
          ,resizing_sw = false
          ,resizing_se = false
          ,resizing_e = false
          ,resizing_w = false
          ,resizing_n = false
          ,resizing_s = false
          ,moving = false
        }
    
    }
  setmetatable(win, Window)
  
  win:render()
  return win
  
end

function Window:set(prop, val)

  self.props[prop] = val
  
  return true
  
end

function Window:get(prop)
    
  if self.props[prop] == nil then
    return false
  end
  
  return self.props[prop]
  
end

function Window:find(id) 
  local wnd = self:get("windows")
  for i=1, #wnd do
    if wnd[i]:get("id") == id then
      return i
    end
  end
  
  return false
end

function Window:size(w, h)
  if w <= 0 then w = 1 end
  if h <= 0 then h = 1 end
  self:set("width", w)
  self:set("height", h)
  self:render()
end

-- Master method
function Window:focus()
  if self:get("hidden") then return end
  self:set("hasFocus", true)
  self:onfocus()
end
-- User defined method.
function Window:onfocus()
  
end

-- Master method
function Window:blur()
  if self:get("hidden") then return end
  self:set("hasFocus", false)
  self:onblur()
end
-- User defined method.
function Window:onblur()
  
end
  
-- Master method
function Window:resize()
  self:onresize()
end
-- User defined method.
function Window:onresize()
  
end

-- Master method
function Window:click(x, y, button, istouch)
  if self:get("hidden") then return end
  local wnd = self:get("windows")
  local wx = self:get("left")
  local wy = self:get("top")
  for i=1, #wnd do
    if x >= wnd[i]:get("left") + wx and y >= wnd[i]:get("top") + wy and x <= wnd[i]:get("left") + wnd[i]:get("width") + wx and y <= wnd[i]:get("top") + wnd[i]:get("height") + wy then
      wnd[i]:click(x - wx, y - wy, button, istouch)
      return
    end
  end
  
  self:onclick(x, y, button, istouch)

end
-- User defined method.
function Window:onclick(x, y, button, istouch)
--  print(self:get("id"))
--  print("click")
end

-- Master method
function Window:load()
  self:onload()
end
-- User defined method.
function Window:onload()
  
end

-- Master method
function Window:unload()
  self:onunload()
end
-- User defined method.
function Window:onunload()
  
end

function Window:hide()
  self:set("hidden", true)
end

function Window:show()
  self:set("hidden", false)
end


-- Love2d Hook Methods

function Window:mousepressed(x, y, button, istouch)
  if self:get("hidden") then return end
--  print(self:get("id"))
--  print("mousedown")
  local thm = self:get("theme")
    
  if button == 1 and not self:get("fixed") and not
    (
      self:get("moving") or 
      self:get("resizing_s") or 
      self:get("resizing_n") or 
      self:get("resizing_e") or 
      self:get("resizing_w") or 
      self:get("resizing_nw") or 
      self:get("resizing_ne") or 
      self:get("resizing_sw") or 
      self:get("resizing_se"))
  then
    
    -- TODO: Add check to make sure the mouse is not over top of a child of this window.
    -- If it is over top of one, cancel the move/resize.
    if x >= self:get("left") and y >= self:get("top") and x <= self:get("left") + thm:get("images").corner_nw:getWidth() and y <= self:get("top") + thm:get("images").corner_nw:getHeight() then
      self:set("resizing_nw", true)
    elseif x >= self:get("left") + self:get("width") - thm:get("images").corner_se:getWidth() and y >= self:get("top") + self:get("height") - thm:get("images").corner_se:getHeight() and x <= self:get("left") + self:get("width") and y <= self:get("top") + self:get("height") then
      self:set("resizing_ne", true)
    elseif x >= self:get("left") and y >= self:get("top") + self:get("height") - thm:get("images").corner_sw:getHeight() and x <= self:get("left") + thm:get("images").corner_sw:getWidth() and y <= self:get("top") + self:get("height") then
      self:set("resizing_sw", true)
    elseif x >= self:get("left") + self:get("width") - thm:get("images").corner_ne:getWidth() and y >= self:get("top") and x <= self:get("left") + self:get("width") and y <= self:get("top") + thm:get("images").corner_ne:getHeight() then
      self:set("resizing_se", true)
    elseif x >= self:get("left") and y >= self:get("top") and x <= self:get("left") + thm:get("images").border_w:getWidth() and y <= self:get("top") + self:get("height") then
      self:set("resizing_w", true)
    elseif x >= self:get("left") + self:get("width") - thm:get("images").border_w:getWidth() and y >= self:get("top") and x <= self:get("left") + self:get("width") and y <= self:get("top") + self:get("height") then
      self:set("resizing_e", true)
    elseif x >= self:get("left") and y >= self:get("top") and x <= self:get("left") + self:get("width") and y <= self:get("top") + thm:get("images").border_n:getHeight() then
      self:set("resizing_n", true)
    elseif x >= self:get("left") and y >= self:get("top") + self:get("height") - thm:get("images").border_n:getHeight() and x <= self:get("left") + self:get("width") and y <= self:get("top") + self:get("height") then
      self:set("resizing_s", true)
    else
      self:set("moving", true)
    end
  end

end

function Window:mousemoved(x, y, dx, dy, istouch)
  if self:get("hidden") then return end
--  print(self:get("id"))
--  print("mousemoved")
  local thm = self:get("theme")

  if not self:get("fixed") then
    -- TODO: Add check to make sure the mouse is not over top of a child of this window.
    -- If it is over top of one, cancel the move/resize.
    if x >= self:get("left") and y >= self:get("top") and x <= self:get("left") + thm:get("images").corner_nw:getWidth() and y <= self:get("top") + thm:get("images").corner_nw:getHeight() then
      love.mouse.setCursor(love.mouse.getSystemCursor("sizenwse"))
    elseif x >= self:get("left") + self:get("width") - thm:get("images").corner_se:getWidth() and y >= self:get("top") + self:get("height") - thm:get("images").corner_se:getHeight() and x <= self:get("left") + self:get("width") and y <= self:get("top") + self:get("height") then
      love.mouse.setCursor(love.mouse.getSystemCursor("sizenwse"))
    elseif x >= self:get("left") and y >= self:get("top") + self:get("height") - thm:get("images").corner_sw:getHeight() and x <= self:get("left") + thm:get("images").corner_sw:getWidth() and y <= self:get("top") + self:get("height") then
      love.mouse.setCursor(love.mouse.getSystemCursor("sizenesw"))
    elseif x >= self:get("left") + self:get("width") - thm:get("images").corner_ne:getWidth() and y >= self:get("top") and x <= self:get("left") + self:get("width") and y <= self:get("top") + thm:get("images").corner_ne:getHeight() then
      love.mouse.setCursor(love.mouse.getSystemCursor("sizenesw"))
    elseif x >= self:get("left") and y >= self:get("top") and x <= self:get("left") + thm:get("images").border_w:getWidth() and y <= self:get("top") + self:get("height") then
      love.mouse.setCursor(love.mouse.getSystemCursor("sizewe"))
    elseif x >= self:get("left") + self:get("width") - thm:get("images").border_w:getWidth() and y >= self:get("top") and x <= self:get("left") + self:get("width") and y <= self:get("top") + self:get("height") then
      love.mouse.setCursor(love.mouse.getSystemCursor("sizewe"))
    elseif x >= self:get("left") and y >= self:get("top") and x <= self:get("left") + self:get("width") and y <= self:get("top") + thm:get("images").border_n:getHeight() then
      love.mouse.setCursor(love.mouse.getSystemCursor("sizens"))
    elseif x >= self:get("left") and y >= self:get("top") + self:get("height") - thm:get("images").border_n:getHeight() and x <= self:get("left") + self:get("width") and y <= self:get("top") + self:get("height") then
      love.mouse.setCursor(love.mouse.getSystemCursor("sizens"))
    else
      love.mouse.setCursor(love.mouse.getSystemCursor("arrow"))
    end
  end

end

function Window:mousereleased(x, y, button, istouch)
  if self:get("hidden") then return end
--  print(self:get("id"))
--  print("mouseup")

  self:set("moving", false)
  self:set("resizing_s", false)
  self:set("resizing_n", false)
  self:set("resizing_e", false)
  self:set("resizing_w", false)
  self:set("resizing_nw", false)
  self:set("resizing_ne", false)
  self:set("resizing_sw", false)
  self:set("resizing_se", false)

end

function Window:update(dt, dx, dy)
  if self:get("hidden") then return end

  if dx == nil then dx = 0 end
  if dy == nil then dy = 0 end
  if love.mouse.isDown(1) and not self:get("fixed") and
    (
      self:get("moving") or 
      self:get("resizing_s") or 
      self:get("resizing_n") or 
      self:get("resizing_e") or 
      self:get("resizing_w") or 
      self:get("resizing_nw") or 
      self:get("resizing_ne") or 
      self:get("resizing_sw") or 
      self:get("resizing_se"))
  then
    
    if self:get("moving") then
      self:set("top", self:get("top") + dy)
      self:set("left", self:get("left") + dx)
    elseif self:get("resizing_nw") then
      -- North West Sizer
      self:set("left", self:get("left") + dx)
      self:set("top", self:get("top") + dy)
      self:size(self:get("width") + dx *-1, self:get("height") + dy *-1)
    elseif self:get("resizing_ne")  then
      -- South East sizer
      self:size(self:get("width") + dx, self:get("height") + dy)
    elseif self:get("resizing_sw")  then
      -- South West sizer
      self:set("left", self:get("left") + dx)
      self:set("top", self:get("top"))
      self:size(self:get("width") + dx *-1, self:get("height") + dy)
    elseif self:get("resizing_se") then
      -- North East sizer
      self:set("top", self:get("top") + dy)
      self:size(self:get("width") + dx, self:get("height") + dy *-1)
    elseif self:get("resizing_w") then
      -- West sizer
      self:set("left", self:get("left") + dx)
      self:size(self:get("width") + dx *-1, self:get("height"))
    elseif self:get("resizing_e") then
      -- East sizer
      self:size(self:get("width") + dx, self:get("height"))
    elseif self:get("resizing_n") then
      -- Top sizer
      self:set("top", self:get("top") + dy)
      self:size(self:get("width"), self:get("height") + dy *-1)
    elseif self:get("resizing_s") then
      -- Bottom sizer
      self:size(self:get("width"), self:get("height") + dy)
    end
    
  end

  local wins = self:get("windows")

  if #wins > 0 then
    for i=#wins, 1, -1 do
      wins[i]:update(dt)
    end
  end
end

function Window:keypressed(key, scancode)
  if self:get("hidden") then return end

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

function Window:textinput(t)
  if self:get("hidden") then return end
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

function Window:draw()
  if self:get("hidden") then return end

  local scx, scy, scw, sch = love.graphics.getScissor( )

  love.graphics.setScissor(self:get("left"), self:get("top"), self:get("width"), self:get("height"))
  love.graphics.draw(self:get("canvas"), self:get("left"), self:get("top"))

  local wins = self:get("windows")

  if #wins > 0 then
    for i=#wins, 1, -1 do
      wins[i]:draw(self:get("left"), self:get("top"))
    end
  end
  
  love.graphics.setScissor(scx, scy, scw, sch)
end

-- Pre-render window for draw method.  Call this when your window is dirty.
function Window:render(scale)
  if scale == nil then scale = 1 end
  
  local canv = love.graphics.newCanvas(self:get("width"), self:get("height"))
  local thm = self:get("theme")

  local q = love.graphics.newQuad(
      0
      ,0
      ,self:get("width")
      ,self:get("height")
      ,thm:get("images").bg_image:getWidth()
      ,thm:get("images").bg_image:getHeight()
    )
  local qnw = love.graphics.newQuad(
      0
      ,0
      ,thm:get("images").corner_nw:getWidth()
      ,thm:get("images").corner_nw:getHeight()
      ,thm:get("images").corner_nw:getWidth()
      ,thm:get("images").corner_nw:getHeight()
    )
  local qne = love.graphics.newQuad(
      0
      ,0
      ,thm:get("images").corner_ne:getWidth()
      ,thm:get("images").corner_ne:getHeight()
      ,thm:get("images").corner_ne:getWidth()
      ,thm:get("images").corner_ne:getHeight()
    )
  local qsw = love.graphics.newQuad(
      0
      ,0
      ,thm:get("images").corner_sw:getWidth()
      ,thm:get("images").corner_sw:getHeight()
      ,thm:get("images").corner_sw:getWidth()
      ,thm:get("images").corner_sw:getHeight()
    )
  local qse = love.graphics.newQuad(
      0
      ,0
      ,thm:get("images").corner_se:getWidth()
      ,thm:get("images").corner_se:getHeight()
      ,thm:get("images").corner_se:getWidth()
      ,thm:get("images").corner_se:getHeight()
    )
  local be = love.graphics.newQuad(
      0
      ,0
      ,thm:get("images").border_e:getWidth()
      ,self:get("height") - thm:get("images").corner_se:getHeight() - thm:get("images").corner_ne:getHeight()
      ,thm:get("images").border_e:getWidth()
      ,thm:get("images").border_e:getHeight()
    )
  local bw = love.graphics.newQuad(
      0
      ,0
      ,thm:get("images").border_w:getWidth()
      ,self:get("height") - thm:get("images").corner_se:getHeight() - thm:get("images").corner_ne:getHeight()
      ,thm:get("images").border_w:getWidth()
      ,thm:get("images").border_w:getHeight()
    )
  local bs = love.graphics.newQuad(
      0
      ,0
      ,self:get("width") - thm:get("images").corner_se:getWidth() - thm:get("images").corner_ne:getWidth()
      ,thm:get("images").border_s:getHeight()
      ,thm:get("images").border_s:getWidth()
      ,thm:get("images").border_s:getHeight()
    )
  local bn = love.graphics.newQuad(
      0
      ,0
      ,self:get("width") - thm:get("images").corner_se:getWidth() - thm:get("images").corner_ne:getWidth()
      ,thm:get("images").border_n:getHeight()
      ,thm:get("images").border_n:getWidth()
      ,thm:get("images").border_n:getHeight()
    )
  
  love.graphics.setCanvas(canv)
    love.graphics.draw(thm:get("images").bg_image, q, 0, 0)
    
    love.graphics.draw(thm:get("images").corner_ne, qne, self:get("width") - thm:get("images").corner_ne:getWidth(), 0)
    love.graphics.draw(thm:get("images").corner_nw, qnw, 0, 0)
    love.graphics.draw(thm:get("images").corner_sw, qsw, 0, self:get("height") - thm:get("images").corner_sw:getHeight())
    love.graphics.draw(thm:get("images").corner_se, qse, self:get("width") - thm:get("images").corner_se:getWidth(), self:get("height") - thm:get("images").corner_se:getHeight())
    
    love.graphics.draw(thm:get("images").border_w, bw, 0, thm:get("images").corner_nw:getHeight())
    love.graphics.draw(thm:get("images").border_e, be, self:get("width") - thm:get("images").border_e:getWidth(), thm:get("images").corner_ne:getHeight())
    love.graphics.draw(thm:get("images").border_s, bs, thm:get("images").corner_sw:getWidth(), self:get("height") - thm:get("images").border_s:getHeight())
    love.graphics.draw(thm:get("images").border_n, bn, thm:get("images").corner_nw:getWidth(), 0)
    
  love.graphics.setCanvas()
  self:set("canvas", love.graphics.newImage(canv:newImageData()))
  self:set("quad", q)
  
end

return Window