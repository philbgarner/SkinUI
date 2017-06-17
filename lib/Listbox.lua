--[[

  Listbox class
  
  Use as a parent for controls which can be scrolled.
  Clips contents.
  
  By Phil Garner
  May 2017
  
  
]]--

local VScrollbar = require "lib.VScrollbar"

local Listbox = {}
Listbox.__index = Listbox

function Listbox:new(id, x, y, w, h, theme)
  
  local win = {
      
      props = {
          id = id
          ,resizable = false
          ,width = w
          ,height = h
          ,left = x
          ,top = y

          ,opacity = 1
          ,alwaysontop = false
          ,bg_autosize = false  -- If not autosize, then it tiles when the Listbox exceeds the background image size.
          ,theme = theme
          ,canvas = nil
          ,quad = nil

          ,fontSize = 12

          ,scroll = 1
          ,selectedIndex = 0
          
          ,windows = {}
          ,window_focusid = ""
          
          ,items = {}
          ,selectIndex = nil
          
          ,hidden = false
          
          ,hasFocus = false

        }
    
    }
  setmetatable(win, Listbox)
  win:render(1)
  win:load()
  return win
  
end

function Listbox:add(text)
  local items = self:get("items")
  table.insert(items, text)
  self:set("items", items)
  local vs = self:get("vscroll")
  vs:set("scroll_max", self:count())
  vs:render(1)
  self:set("vscroll", vs)
  self:render(1)
end

function Listbox:selectIndex(index)
  self.selectIndex = index
end

function Listbox:remove(index)
  table.remove(self.items, index)
end

function Listbox:find(val, val2)
  local startat
  local term
  if type(val) == "string" then
    startat = 1
    term = val
  elseif type(val) == "number" then
    startat = val
    term = val2
  end
  
  for i=startat, #self.items do
    if term == self.items[i] then
      return i
    end
  end
  return false
end

function Listbox:set(prop, val)

  self.props[prop] = val
  
  return true
  
end

function Listbox:get(prop)
    
  if self.props[prop] == nil then
    return false  
  end
  
  return self.props[prop]
  
end


function Listbox:size(w, h)
  if w <= 0 then w = 1 end
  if h <= 0 then h = 1 end
  self:set("width", w)
  self:set("height", h)
  self:render()
end

-- Master method
function Listbox:focus()
  self:set("hasFocus", true)
  self:onfocus()
end
-- User defined method.
function Listbox:onfocus()
  
end

-- Master method
function Listbox:blur()
  self:set("hasFocus", false)
  self:onblur()
end
-- User defined method.
function Listbox:onblur()
  
end
  
-- Master method
function Listbox:resize()
  self:onresize()
end
-- User defined method.
function Listbox:onresize()
  
end

-- Master method
function Listbox:change(i)
  local linesize = self:get("fontSize") + 6
  local pageheight = math.floor((self:get("height") - self:get("theme"):get("images").textbox_nw:getHeight() - self:get("theme"):get("images").textbox_sw:getHeight()) / linesize)
  
  self:set("selectedIndex", i)
  if self:get("selectedIndex") > self:count() then
    self:set("selectedIndex", self:count())
  end
  if self:get("selectedIndex") < 1 then
    self:set("selectedIndex", 1)
  end
  if self:get("scroll") > self:get("selectedIndex") then
    self:set("scroll", self:get("selectedIndex"))
  elseif self:get("selectedIndex") > self:get("scroll") + pageheight then
    self:set("scroll", self:get("selectedIndex"))
  end
  self:set("text", self:get("items")[self:get("selectedIndex")])

  local vs = self:get("vscroll")
  vs:set("scroll", self:get("scroll"))
  vs:render(1)
  self:set("vscroll", vs)
  
  self:onchange(self:get("selectedIndex"))
end
-- User defined method.
function Listbox:onchange(i)
end

-- Master method
function Listbox:scroll(i)
  self:set("scroll", i)
  if self:get("scroll") > self:count() then
    self:set("scroll", self:count())
  elseif self:get("scroll") < 1 then
    self:set("scroll", 1)
  end
  self:onscroll(i)
end
-- User defined method.
function Listbox:onscroll(i)
  
end

-- Master method
function Listbox:click(x, y, button, istouch)
  local wx = self:get("left")
  local wy = self:get("top")
--  for i=1, #wnd do
--    if x >= wnd[i]:get("left") + wx and y >= wnd[i]:get("top") + wy and x <= wnd[i]:get("left") + wnd[i]:get("width") + wx and y <= wnd[i]:get("top") + wnd[i]:get("height") + wy then
--      wnd[i]:onclick(wnd[i]:get("left") + wx + x, wnd[i]:get("top") + wy + y, button, istouch)
--      return
--    end
--  end
  local fontsize = self:get("fontSize") + 6
  local rx = x - self:get("left") - self:get("theme"):get("images").textbox_nw:getWidth()
  local ry = y - self:get("top") - self:get("theme"):get("images").textbox_nw:getHeight()
  
  -- Make sure the click wasn't on the borders.
  if x >= rx + self:get("theme"):get("images").textbox_nw:getWidth() and x <= self:get("width") - self:get("theme"):get("images").textbox_nw:getWidth() and
     y >= ry + self:get("theme"):get("images").textbox_nw:getHeight() and ry <= self:get("height") - self:get("theme"):get("images").textbox_nw:getHeight() - self:get("theme"):get("images").textbox_sw:getHeight()
  then
    self:change(math.floor(ry / fontsize + self:get("scroll")))
  end

  local vs = self:get("vscroll")
  if x >= vs:get("left") + wx and y >= vs:get("top") + wy and x <= vs:get("left") + vs:get("width") + wx and y <= vs:get("top") + vs:get("height") + wy then
    vs:click(x - wx, y - wy, button, istouch)
  end

  self:render(1)
  self:onclick(x - wx, y - wy, button, istouch)

end
-- User defined method.
function Listbox:onclick(x, y, button, istouch)
--  print(self:get("id"))
--  print("click")

end

-- Master method
function Listbox:load()
  self:fontSize(self:get("fontSize"))
  
  local vs = VScrollbar:new("vscroll", self:get("width")
                      - self:get("theme"):get("images").vscroll_body:getWidth()
                      - self:get("theme"):get("images").corner_ne:getWidth()
      , self:get("theme"):get("images").corner_ne:getHeight(), self:get("height")
            - self:get("theme"):get("images").corner_se:getHeight()
            - self:get("theme"):get("images").corner_ne:getHeight()
      , self:get("theme"))
  local lb = self
  function vs:onscroll(v)
    lb:set("scroll", v)
  end
  
  self:set("vscroll", vs)
    
  self:onload()
end
-- User defined method.
function Listbox:onload()

end

-- Master method
function Listbox:unload()
  self:set("canvas", nil)
  self:onunload()
end
-- User defined method.
function Listbox:onunload()
  
end

function Listbox:getText()
  local si = self:get("selectedIndex")
  if si > 0 then
    return self:get("items")[si]
  else
    return ""
  end
end


function Listbox:fontSize(s)
  local f = love.graphics.newFont(s)
  self:set("font", f)
  self:set("fontSize", s)
end

-- Love2d Hook Methods

function Listbox:mousepressed(x, y, button, istouch)
--  print(self:get("id"))
--  print("mousedown")

end

function Listbox:mousemoved(x, y, dx, dy, istouch)
--  print(self:get("id"))
--  print("mousemoved")

end

function Listbox:mousereleased(x, y, button, istouch)
--  print(self:get("id"))
--  print("mouseup")

end

function Listbox:update(dt)

  local wins = self:get("windows")

  if #wins > 0 then
    for i=#wins, 1, -1 do
      wins[i]:update(dt)
    end
  end
  
end

function Listbox:count()
  return #self.props.items
end

function Listbox:keypressed(key, scancode)

  print(key)
  local linesize = self:get("fontSize") + 6
  local pageheight = math.floor((self:get("height") - self:get("theme"):get("images").textbox_nw:getHeight() - self:get("theme"):get("images").textbox_sw:getHeight()) / linesize)
  
  if key == "end" then
    self:change(self:count())
    self:scroll(self:get("selectedIndex") - pageheight)
    self:render(1)
  elseif key == "home" then
    self:change(1)
    self:scroll(1)
    self:render(1)
  elseif key == "pagedown" then
    self:change(self:get("selectedIndex") + pageheight)
    self:render(1)
  elseif key == "pageup" then
    self:change(self:get("selectedIndex") - pageheight)
    self:render(1)
  elseif key == "up" then
    self:change(self:get("selectedIndex") - 1)
    self:render(1)
  elseif key == "down" then
    self:change(self:get("selectedIndex") + 1)
    self:render(1)
  end

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

function Listbox:textinput(t)
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

function Listbox:draw(x, y)
  if x == nil then x = 0 end
  if y == nil then y = 0 end
  
  local scx, scy, scw, sch = love.graphics.getScissor( )
  local nw = self:get("width")
  local nh = self:get("height")
  love.graphics.setScissor(self:get("left") + x, self:get("top") + y, nw * 2, nh * 2)
  love.graphics.draw(self:get("canvas"), self:get("left") + x, self:get("top") + y)

  self:get("vscroll"):draw(self:get("left") + x, self:get("top") + y)

  love.graphics.setScissor(scx, scy, scw, sch)
end

-- Pre-render Listbox for draw method.  Call this when your Listbox is dirty.
function Listbox:render(scale)
  if scale == nil then scale = 1 end
  local linesize = self:get("fontSize") + 6
  local pageheight = math.floor((self:get("height") - self:get("theme"):get("images").textbox_nw:getHeight() - self:get("theme"):get("images").textbox_sw:getHeight()) / linesize)

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
  local scx, scy, scw, sch = love.graphics.getScissor( )
  love.graphics.setScissor(0, 0, self:get("width"), self:get("height"))
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
    
    local dx = thm:get("images").textbox_nw:getWidth()
    local dy = thm:get("images").textbox_ne:getHeight()
    local items = self:get("items")
    local scr = self:get("scroll")
    local fnt = love.graphics.getFont()
    local fontsize = self:get("fontSize")
    local scrend = #items
    if scr < 1 then scr = 1 end
    if scrend > scr + pageheight then scrend = scr + pageheight end
    for i=scr, scrend do
      if i == self:get("selectedIndex") then
        love.graphics.setColor(0, 0, 0, 200)
        local tw = fnt:getWidth(items[i])
        love.graphics.rectangle("fill", dx - 2, dy - 2, tw + 8, fontsize + 6)
        love.graphics.setColor(255, 255, 255)
      end

      love.graphics.print(items[i], dx, dy)
      dy = dy + fontsize + 6
    end
    
  love.graphics.setCanvas()
  love.graphics.setScissor(scx, scy, scw, sch)
  self:set("canvas", love.graphics.newImage(canv:newImageData()))
  self:set("quad", q)
  love.graphics.setFont(fnt)
  
end

return Listbox