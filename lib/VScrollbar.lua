--[[

  Vertical Scrollbar class
  
  By Phil Garner
  May 2017
  
  
]]--

local btiny = require "lib.Button-Tiny"

local VScrollbar = {}
VScrollbar.__index = VScrollbar

function VScrollbar:new(id, x, y, h, theme)
  
  local win = {
      
      props = {
          id = id
          ,resizable = false
          ,width = theme:get("images").vscroll_body:getWidth()
          ,height = h
          ,left = x
          ,top = y
          ,opacity = 1
          ,alwaysontop = false
          ,bg_autosize = false  -- If not autosize, then it tiles when the VScrollbar exceeds the background image size.
          ,theme = theme
          ,canvas = nil
          ,quad = nil
          
          ,scroll = 1
          ,scroll_max = 1
          
          ,text = ""
          
          ,hidden = false
          
          ,hasFocus = false
          ,downSprite = false
        }
    
    }
  setmetatable(win, VScrollbar)
  
  win:render()
  win:load()
  return win
  
end

function VScrollbar:set(prop, val)
  self.props[prop] = val
  
  return true
  
end

function VScrollbar:get(prop)
    
  if self.props[prop] == nil then
    return false
  end
  
  return self.props[prop]
  
end

function VScrollbar:size(w, h)
  self:set("width", w)
  self:set("height", h)
  self:render()
end

-- Master method
function VScrollbar:resize()
  self:onresize()
end
-- User defined method.
function VScrollbar:onresize()
  
end

-- Master method
function VScrollbar:blur()
  self:set("hasFocus", false)
  self:onblur()
end
-- User defined method.
function VScrollbar:onblur()
  
end

-- Master method
function VScrollbar:focus()
  self:set("hasFocus", true)
  self:onfocus()
end
-- User defined method.
function VScrollbar:onfocus()
  
end

-- Master method
function VScrollbar:click(x, y, button, istouch)
  local btnUp = self:get("btnUp")
  local btnDown = self:get("btnDown")
  
  local wx = x - self:get("left")
  local wy = y - self:get("top")
  if wx >= btnUp:get("left") and wx <= self:get("left") + btnUp:get("left") + btnUp:get("width") and wy >= btnUp:get("top") and wy <= btnUp:get("top") + btnUp:get("height") then
    btnUp:click(x, y)
  elseif wx >= btnDown:get("left") and wx <= btnDown:get("left") + btnDown:get("width") and wy >= btnDown:get("top") and wy <= btnDown:get("top") + btnDown:get("height") then
    btnDown:click(x, y)
  else
    local thm = self:get("theme")
    local bodyheight = thm:get("images").vscroll_bottom:getHeight() + thm:get("images").vscroll_top:getHeight() + thm:get("images").vscroll_body:getHeight()
    local carat_pos = (self:get("scroll") / self:get("scroll_max")) * bodyheight + thm:get("images").button_tiny:getHeight()
    if wy < carat_pos then
      self:scroll(math.floor(self:get("scroll") - (self:get("scroll_max") * .10)))
    else
      self:scroll(math.floor(self:get("scroll") + (self:get("scroll_max") * .10)))
    end
  end
  self:onclick(x, y, button, istouch)
end
-- User defined method.
function VScrollbar:onclick(x, y, button, istouch)
  print(self:get("id"))
  print("click")
end

-- Master method
function VScrollbar:load()
  local theme = self:get("theme")
  local btnUp = btiny:new("btnUp", 0, 0, theme)
  local btnDown = btiny:new("btnDown", 0, self:get("height") - theme:get("images").button_tiny:getWidth(), theme)
  
  btnUp:set("icon", theme:get("images").icons_15x15_arrowUp)
  btnDown:set("icon", theme:get("images").icons_15x15_arrowDown)
  local vs = self
  
  function btnDown:onclick()
    local sc = vs:get("scroll")
    sc = sc + 1
    vs:scroll(sc)
  end
  function btnUp:onclick()
    local sc = vs:get("scroll")
    sc = sc - 1
    vs:scroll(sc)
  end
  function btnDown:onunload()
    self:set("icon", nil)
  end
  function btnUp:onunload()
    self:set("icon", nil)
  end
  function btnDown:ondraw(x, y)
    love.graphics.setColor(255, 255, 255, 175)
    love.graphics.draw(self:get("icon"), x + 5, y + 4 + self:get("top"))
    love.graphics.setColor(255, 255, 255, 255)
  end
  function btnUp:ondraw(x, y)
    love.graphics.setColor(255, 255, 255, 175)
    love.graphics.draw(self:get("icon"), x + 5, y + 4 + self:get("top"))
    love.graphics.setColor(255, 255, 255, 255)
  end
  
  self:set("btnUp", btnUp)
  self:set("btnDown", btnDown)

  self:onload()
end
-- User defined method.
function VScrollbar:onload()
  
end

-- Master method
function VScrollbar:unload()
  self:set("canvas", nil)
  self:get("btnUp"):unload()
  self:get("btnDown"):unload()
  self:set("btnUp", nil)
  self:set("btnDown", nil)
  self:onunload()
end
-- User defined method.
function VScrollbar:onunload()
  
end

-- Love2d Hook Methods

function VScrollbar:textinput(t)

  
end

function VScrollbar:mousepressed(x, y, button, istouch)
--  print(self:get("id"))
--  print("mousedown")
  self:set("downSprite", true)
  self:render()
end

function VScrollbar:mousemoved(x, y, dx, dy, istouch)
--  print(self:get("id"))
--  print("mousemoved")
end

function VScrollbar:mousereleased(x, y, button, istouch)
--  print(self:get("id"))
--  print("mouseup")
  self:set("downSprite", false)
  self:render()
end

function VScrollbar:update(dt)
  if self:get("downSprite") and not love.mouse.isDown(1) then
    self:set("downSprite", false)
    self:render()
  end
end

function VScrollbar:keypressed(key, scancode)
  
  print(self:get("id"))
  print(key, scancode)
  
end

-- Master method.
function VScrollbar:scroll(v)
  if self:get("scroll_max") > v and v > 0 then
    self:set("scroll", v)
    self:render(1)
    self:onscroll(v)
  end
end

-- User defined method.
function VScrollbar:onscroll(v)

end

-- Master method.
function VScrollbar:draw(x, y)
  if x == nil then x = 0 end
  if y == nil then y = 0 end
  
  local scx, scy, scw, sch = love.graphics.getScissor( )

    local nw = self:get("width")
    local nh = self:get("height")
    local l = self:get("left")
    local t = self:get("top")

    love.graphics.draw(self:get("canvas"), self:get("left") + x, self:get("top") + y)
    
    self:get("btnUp"):draw(l + x, t + y)
    self:get("btnDown"):draw(l + x, t + y)
    
  love.graphics.setColor(255, 255, 255)
  love.graphics.setScissor(scx, scy, scw, sch)
  
  self:ondraw(x, y)
end

-- User defined method.
function VScrollbar:ondraw(x, y)
  
end

-- Pre-render VScrollbar for draw method.  Call this when your VScrollbar is dirty.
function VScrollbar:render(scale)
  if scale == nil then scale = 1 end
  
  local canv = love.graphics.newCanvas(self:get("width"), self:get("height"))
  local thm = self:get("theme")
  local qc = love.graphics.newQuad(
      0
      ,0
      ,thm:get("images").vscroll_body:getWidth()
      ,self:get("height") - thm:get("images").vscroll_bottom:getHeight() - thm:get("images").vscroll_top:getHeight()
                          - thm:get("images").button_tiny:getHeight() - thm:get("images").button_tiny:getHeight()
      ,thm:get("images").vscroll_body:getWidth()
      ,thm:get("images").vscroll_body:getHeight()
    )
 
  local qt = love.graphics.newQuad(
      0
      ,0
      ,thm:get("images").vscroll_top:getWidth()
      ,thm:get("images").vscroll_top:getHeight()
      ,thm:get("images").vscroll_top:getWidth()
      ,thm:get("images").vscroll_top:getHeight()
    )
  local qb = love.graphics.newQuad(
      0
      ,0
      ,thm:get("images").vscroll_bottom:getWidth()
      ,thm:get("images").vscroll_bottom:getHeight()
      ,thm:get("images").vscroll_bottom:getWidth()
      ,thm:get("images").vscroll_bottom:getHeight()
    )
  local qcarat = love.graphics.newQuad(
      0
      ,0
      ,thm:get("images").vscroll_carat:getWidth()
      ,thm:get("images").vscroll_carat:getHeight()
      ,thm:get("images").vscroll_carat:getWidth()
      ,thm:get("images").vscroll_carat:getHeight()
    )
    
  local maxv = self:get("scroll_max")
  local scrollheight = self:get("height") - thm:get("images").vscroll_bottom:getHeight() - thm:get("images").vscroll_top:getHeight()
                          - thm:get("images").button_tiny:getHeight() - thm:get("images").button_tiny:getHeight()
  local val = self:get("scroll")
  local carat_pos = math.floor((val / maxv) * scrollheight - thm:get("images").vscroll_carat:getHeight() / 2)

  love.graphics.setCanvas(canv)
    love.graphics.draw(thm:get("images").vscroll_top, qt, 0, thm:get("images").button_tiny:getHeight())
    love.graphics.draw(thm:get("images").vscroll_body, qc, 0, thm:get("images").button_tiny:getHeight() + thm:get("images").vscroll_top:getHeight())
    love.graphics.draw(thm:get("images").vscroll_bottom, qb, 0, self:get("height") - thm:get("images").button_tiny:getHeight() - thm:get("images").vscroll_bottom:getHeight())
    
    love.graphics.draw(thm:get("images").vscroll_carat, qcarat, 2, thm:get("images").button_tiny:getHeight() + thm:get("images").vscroll_top:getHeight() + carat_pos)
  love.graphics.setCanvas()
  self:set("canvas", love.graphics.newImage(canv:newImageData()))
  --self:set("quad", qc)
  
end

return VScrollbar