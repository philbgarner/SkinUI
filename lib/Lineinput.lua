--[[

  Lineinput class
  
  By Phil Garner
  May 2017
  
  
]]--

local Lineinput = {}
Lineinput.__index = Lineinput

function Lineinput:new(id, x, y, w, theme)
  
  local win = {
      
      props = {
          id = id
          ,resizable = false
          ,width = w
          ,height = theme:get("images").lineinput:getHeight()
          ,left = x
          ,top = y
          ,opacity = 1
          ,alwaysontop = false
          ,bg_autosize = false  -- If not autosize, then it tiles when the Lineinput exceeds the background image size.
          ,theme = theme
          ,canvas = nil
          ,quad = nil
          
          ,cursor = 0
          ,text = ""
          
          ,hasFocus = false
        }
    
    }
  setmetatable(win, Lineinput)
  
  win:render()
  return win
  
end

function Lineinput:set(prop, val)

  if prop == "text" and type(val) == "number" then
    val = tostring(val)
  end

  self.props[prop] = val
  
  return true
  
end

function Lineinput:get(prop)
    
  if self.props[prop] == nil then
    return false
  end
  
  return self.props[prop]
  
end

function Lineinput:size(w, h)
  self:set("width", w)
  self:set("height", h)
  self:render()
end

-- Master method
function Lineinput:resize()
  self:onresize()
end
-- User defined method.
function Lineinput:onresize()
  
end

-- Master method
function Lineinput:blur()
  self:set("hasFocus", false)
  self:onblur()
end
-- User defined method.
function Lineinput:onblur()
  
end

-- Master method
function Lineinput:focus()
  self:set("hasFocus", true)
  local tx = self:get("text")
  self:set("cursor", #tx)
  self:onfocus()
end
-- User defined method.
function Lineinput:onfocus()
  
end

-- Master method
function Lineinput:click(x, y, button, istouch)
  self:onclick(x, y, button, istouch)
end
-- User defined method.
function Lineinput:onclick(x, y, button, istouch)
  print(self:get("id"))
  print("click")
end

-- Master method
function Lineinput:load()
  self:onload()
end
-- User defined method.
function Lineinput:onload()
  
end

-- Master method
function Lineinput:unload()
  self:onunload()
end
-- User defined method.
function Lineinput:onunload()
  
end

-- Love2d Hook Methods

function Lineinput:mousepressed(x, y, button, istouch)
--  print(self:get("id"))
--  print("mousedown")

end

function Lineinput:mousemoved(x, y, dx, dy, istouch)
--  print(self:get("id"))
--  print("mousemoved")
end

function Lineinput:mousereleased(x, y, button, istouch)
--  print(self:get("id"))
--  print("mouseup")
end

function Lineinput:update(dt)
  
end

function Lineinput:keypressed(key, scancode)
  if key == "backspace" and self:get("cursor") > 0 then
    local lp = string.sub(self:get("text"), 1, self:get("cursor") - 1)
    local rp = string.sub(self:get("text"), self:get("cursor") + 1)
    self:set("text", lp .. rp)
    self:set("cursor", self:get("cursor") - 1)
  elseif key == "left" then
    local cr = self:get("cursor") - 1
    if (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
      print(string.sub(self:get("text"), 1, cr):reverse())
      local ncr = string.find(string.sub(self:get("text"), 1, cr):reverse(), " ")
      if ncr == nil then
        cr = 0
      else
        cr = self:get("cursor") - ncr
      end
    end
    if self:get("cursor") > string.len(self:get("text")) then
      cr = string.len(self:get("text")) - 1
    elseif cr < 0 then
      cr = 0
    end
    self:set("cursor", cr)
  elseif key == "right" then
    local cr = self:get("cursor") + 1
    if (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
      local ncr = string.find(string.sub(self:get("text"), cr), " ")
      if ncr == nil then
        cr = string.len(self:get("text"))
      else
        cr = ncr + self:get("cursor")
      end
    end
    if self:get("cursor") > string.len(self:get("text")) then
      cr = string.len(self:get("text"))
    elseif cr < 0 then
      cr = 0
    end
    self:set("cursor", cr)
  elseif key == "delete" then
    local lp = string.sub(self:get("text"), 1, self:get("cursor"))
    local rp = string.sub(self:get("text"), self:get("cursor") + 2)
    self:set("text", lp .. rp)
  elseif key == "home" then
      self:set("cursor", 0)
  elseif key == "end" then
      self:set("cursor", string.len(self:get("text")))
  end
end

function Lineinput:textinput(t)
  
  local lp = string.sub(self:get("text"), 1, self:get("cursor"))
  local rp = string.sub(self:get("text"), self:get("cursor") + 1)
  local fnt = love.graphics.getFont()
  local cx = fnt:getWidth(lp .. t .. rp) + 7
  if cx < self:get("width") then
    self:set("text", lp .. t .. rp)
    self:set("cursor", self:get("cursor") + 1)
  end
    
end

function Lineinput:draw(x, y)
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
  love.graphics.print(self:get("text"), self:get("left") + 7 + x, self:get("top") + 12 + y)
  if self:get("hasFocus") and love.timer.getTime() % 1 > 0.5 then
    local fnt = love.graphics.getFont()
    local cx = fnt:getWidth(string.sub(self:get("text"), 1, self:get("cursor")))
    love.graphics.rectangle("fill", self:get("left") + 6 + cx + x, self:get("top") + 11 + y, 2, 15)
  end
  love.graphics.setColor(255, 255, 255)
  love.graphics.setScissor(scx, scy, scw, sch)
end

-- Pre-render Lineinput for draw method.  Call this when your Lineinput is dirty.
function Lineinput:render(scale)
  if scale == nil then scale = 1 end
  
  local canv = love.graphics.newCanvas(self:get("width"), self:get("height"))
  local thm = self:get("theme")
  local q = love.graphics.newQuad(
      thm:get("images").lineinput_left:getWidth()
      ,0
      ,self:get("width")
      ,self:get("height")
      ,thm:get("images").lineinput:getWidth()
      ,thm:get("images").lineinput:getHeight()
    )
  local ql = love.graphics.newQuad(
      0
      ,0
      ,thm:get("images").lineinput_left:getWidth()
      ,self:get("height")
      ,thm:get("images").lineinput_left:getWidth()
      ,thm:get("images").lineinput_left:getHeight()
    )
  local qr = love.graphics.newQuad(
      thm:get("images").lineinput:getWidth() + thm:get("images").lineinput_left:getWidth()
      ,0
      ,self:get("width")
      ,self:get("height")
      ,thm:get("images").lineinput_right:getWidth()
      ,thm:get("images").lineinput_right:getHeight()
    )
  
  love.graphics.setCanvas(canv)
    love.graphics.draw(thm:get("images").lineinput_left, ql, 0, 0)    
    love.graphics.draw(thm:get("images").lineinput, q, thm:get("images").lineinput_left:getWidth(), 0)    
    love.graphics.draw(thm:get("images").lineinput_right, qr, self:get("width") - thm:get("images").lineinput_right:getWidth(), 0)    
  love.graphics.setCanvas()
  self:set("canvas", love.graphics.newImage(canv:newImageData()))
  self:set("quad", q)
  
end

return Lineinput