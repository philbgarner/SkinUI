--[[

  Textbox class
  
  Use as a parent for controls which can be scrolled.
  Clips contents.
  
  By Phil Garner
  May 2017
  
  
]]--

local Textbox = {}
Textbox.__index = Textbox

function Textbox:new(id, x, y, w, h, theme)
  
  local win = {
      
      props = {
          id = id
          ,resizable = false
          ,width = w
          ,height = h
          ,left = x
          ,top = y
          ,scrollx = 0
          ,scrolly = 0
          ,opacity = 1
          ,alwaysontop = false
          ,bg_autosize = false  -- If not autosize, then it tiles when the Textbox exceeds the background image size.
          ,theme = theme
          ,canvas = nil
          ,quad = nil
          
          ,paddingx = 15
          ,paddingy = 15
          
          ,text = "test"
          ,cursor = 0
          ,cursor_line = 0
          
          ,hidden = false
          
          ,hasFocus = false

        }
    
    }
  setmetatable(win, Textbox)
  
  win:render()
  return win
  
end

function Textbox:set(prop, val)

  self.props[prop] = val
  
  return true
  
end

function Textbox:get(prop)
    
  if self.props[prop] == nil then
    return false
  end
  
  return self.props[prop]
  
end

function Textbox:find(id) 
  local wnd = self:get("windows")
  for i=1, #wnd do
    if wnd[i]:get("id") == id then
      return i
    end
  end
  
  return false
end

function Textbox:size(w, h)
  if w <= 0 then w = 1 end
  if h <= 0 then h = 1 end
  self:set("width", w)
  self:set("height", h)
  self:render()
end

-- Master method
function Textbox:focus()
  self:set("hasFocus", true)
  self:onfocus()
end
-- User defined method.
function Textbox:onfocus()
  
end

-- Master method
function Textbox:blur()
  self:set("hasFocus", false)
  self:onblur()
end
-- User defined method.
function Textbox:onblur()
  
end
  
-- Master method
function Textbox:resize()
  self:onresize()
end
-- User defined method.
function Textbox:onresize()
  
end

-- Master method
function Textbox:click(x, y, button, istouch)
  
  self:onclick(x, y, button, istouch)

end
-- User defined method.
function Textbox:onclick(x, y, button, istouch)
--  print(self:get("id"))
--  print("click")
end

-- Master method
function Textbox:load()
  self:onload()
end
-- User defined method.
function Textbox:onload()
  
end

-- Master method
function Textbox:unload()
  self:set("canvas", nil)
  self:onunload()
end
-- User defined method.
function Textbox:onunload()
  
end

-- Love2d Hook Methods

function Textbox:mousepressed(x, y, button, istouch)
--  print(self:get("id"))
--  print("mousedown")

end

function Textbox:mousemoved(x, y, dx, dy, istouch)
--  print(self:get("id"))
--  print("mousemoved")

end

function Textbox:mousereleased(x, y, button, istouch)
--  print(self:get("id"))
--  print("mouseup")

end

function Textbox:update(dt)


end

function Textbox:keypressed(key, scancode)

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
  elseif key == "down" then
    local cr = self:get("cursor_line") + 1
    self:set("cursor_line", cr)
  elseif key == "delete" then
    local lp = string.sub(self:get("text"), 1, self:get("cursor"))
    local rp = string.sub(self:get("text"), self:get("cursor") + 2)
    self:set("text", lp .. rp)
  elseif key == "home" then
      self:set("cursor", 0)
  elseif key == "end" then
      self:set("cursor", string.len(self:get("text")))
  elseif key == "return" then
    local lp = string.sub(self:get("text"), 1, self:get("cursor"))
    local rp = string.sub(self:get("text"), self:get("cursor") + 1)
    self:set("text", lp .. string.char(13) .. rp)
    self:set("cursor_line", self:get("cursor_line") + 1)
    self:set("cursor", self:get("cursor") + 1)
  end
end


function Textbox:textinput(t)
  
  local lp = string.sub(self:get("text"), 1, self:get("cursor"))
  local rp = string.sub(self:get("text"), self:get("cursor") + 1)
  local fnt = love.graphics.getFont()
  local cx = fnt:getWidth(lp .. t .. rp) + 7
  if cx < self:get("width") then
    self:set("text", lp .. t .. rp)
    self:set("cursor", self:get("cursor") + 1)
  end
    
end

function Textbox:draw(x, y)
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
--  love.graphics.print(self:get("text"), self:get("left") + self:get("paddingx") + x, self:get("top") + self:get("paddingy") + y)
--  if self:get("hasFocus") and love.timer.getTime() % 1 > 0.5 then
--    local fnt = love.graphics.getFont()
--    local cx = fnt:getWidth(string.sub(self:get("text"), 1, self:get("cursor")))
--    love.graphics.rectangle("fill", self:get("left") + self:get("paddingx") - 1 + cx + x, self:get("top") + self:get("paddingy") - 1 + y, 2, 15)
--  end

  local tline = 0
  local tcol = 0
  local txt = self:get("text")
  local lc = 0
  
  love.graphics.setColor(255, 255, 255)
  
  for line in txt:gmatch("[^\r\n]+") do
    love.graphics.print(line, self:get("left") + self:get("paddingx") + x + tcol, self:get("top") + self:get("paddingy") + y + tline)
    if self:get("hasFocus") and love.timer.getTime() % 1 > 0.5 and self:get("cursor_line") == lc then
      --local text = {}
      local fnt = love.graphics.getFont()
      local cx = fnt:getWidth(string.sub(line, 1, self:get("cursor")))
      local cy = lc * 15 --fnt:getWidth(string.sub(line, 1, self:get("cursor_line")))
      love.graphics.rectangle("fill", self:get("left") + self:get("paddingx") - 1 + cx + x, self:get("top") + self:get("paddingy") - 1 + cy + y, 2, 15)
    end
    lc = lc + 1
    tline = tline + 15
  end

  love.graphics.setColor(255, 255, 255)
  
  love.graphics.setScissor(scx, scy, scw, sch)
end

-- Pre-render Textbox for draw method.  Call this when your Textbox is dirty.
function Textbox:render(scale)
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

return Textbox