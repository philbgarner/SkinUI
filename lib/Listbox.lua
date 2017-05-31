--[[

  Listbox class
  
  Use as a parent for controls which can be scrolled.
  Clips contents.
  
  By Phil Garner
  May 2017
  
  
]]--

local btiny = require "lib.Button-Tiny"

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
          ,scrollx = 0
          ,scrolly = 0
          ,opacity = 1
          ,alwaysontop = false
          ,bg_autosize = false  -- If not autosize, then it tiles when the Listbox exceeds the background image size.
          ,theme = theme
          ,canvas = nil
          ,quad = nil
          
          ,windows = {}
          ,window_focusid = ""
          
          ,items = {}
          ,selectIndex = nil
          
          ,hidden = false
          
          ,hasFocus = false

        }
    
    }
  setmetatable(win, Listbox)
  win.upButton = btiny:new("btnUp", w - theme:get("images").textbox_nw:getWidth() - theme:get("images").textbox_ne:getWidth(), theme:get("images").textbox_ne:getHeight(), theme)
  win.upButton:set("text", "U")
  win.upButton:render(1)
  win.downButton = btiny:new("btnDown", w - theme:get("images").textbox_sw:getWidth() - theme:get("images").textbox_se:getWidth(), h - theme:get("images").textbox_se:getHeight() - theme:get("images").textbox_ne:getHeight(), theme)
  win.downButton:set("text", "D")
  win.downButton:render(1)
  table.insert(win.props.windows, win.upButton)
  table.insert(win.props.windows, win.downButton)
  
  win:render()
  return win
  
end

function Listbox:add(text)
  local items = self:get("items")
  table.insert(items, text)
  self:set("items", items)
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
  
  for i=starat, #self.items do
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
function Listbox:click(x, y, button, istouch)
  print("click!")
  local wnd = self:get("windows")
  local wx = self:get("left")
  local wy = self:get("top")
  print(listclock)
  for i=1, #wnd do
    print(i)
    if x >= wnd[i]:get("left") + wx and y >= wnd[i]:get("top") + wy and x <= wnd[i]:get("left") + wnd[i]:get("width") + wx and y <= wnd[i]:get("top") + wnd[i]:get("height") + wy then
      print("click", i)
      wnd[i]:onclick(x, y, button, istouch)
      return
    end
  end
  self:onclick(x, y, button, istouch)

end
-- User defined method.
function Listbox:onclick(x, y, button, istouch)
--  print(self:get("id"))
--  print("click")
end

-- Master method
function Listbox:load()
  self:onload()
end
-- User defined method.
function Listbox:onload()
  
end

-- Master method
function Listbox:unload()
  self:onunload()
end
-- User defined method.
function Listbox:onunload()
  
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

function Listbox:keypressed(key, scancode)

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

    
  local wins = self:get("windows")
  if #wins > 0 then
    for i=#wins, 1, -1 do
      local wx = wins[i]:get("left")
      local wy = wins[i]:get("top")
      wins[i]:draw(self:get("left") + x, self:get("top") + y)
    end
  end

  love.graphics.setScissor(scx, scy, scw, sch)
end

-- Pre-render Listbox for draw method.  Call this when your Listbox is dirty.
function Listbox:render(scale)
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
    for i=1, #items do
      love.graphics.print(items[i], dx, dy)
      dy = dy + 20
    end
    
  love.graphics.setCanvas()
  love.graphics.setScissor(scx, scy, scw, sch)
  self:set("canvas", love.graphics.newImage(canv:newImageData()))
  self:set("quad", q)
  
end

return Listbox