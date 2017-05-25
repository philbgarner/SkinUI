local skinui = {
}

local oldmx = 0
local oldmy = 0
local mx = 0
local my = 0

local themes = require "lib.Theme"

skinui.layout = require "lib.layout"

skinui.Window = require "lib.Window"
skinui.Textinput = require "lib.Textinput"
skinui.Button = require "lib.Button"
skinui.Container = require "lib.Container"
skinui.Textbox = require "lib.Textbox"
skinui.Label = require "lib.Label"
skinui.Lineinput = require "lib.Lineinput"

function skinui:load()
  skinui.theme = themes:new()
  
  love.keyboard.setKeyRepeat(true)
  
  skinui.windows = {}
  skinui.window_focusid = ""
  skinui.window_mousedownid = ""
  
  mx = love.mouse.getX()
  my = love.mouse.getY()

end

function skinui:add(obj)
  table.insert(skinui.windows, obj)
  skinui:totop(obj:get("id"))
end

function skinui:remove(id)
  if not skinui:find(id) then return false end
  table.remove(skinui.windows, skinui:find(id))
  if #skinui.windows > 0 then skinui.window_focusid = skinui.windows[1]:get("id") else skinui.window_focusid = "" end
end

function skinui:addChild(id, obj)
  local index = skinui:find(id)
  if not index then return end
  local win = skinui.windows[index]:get("windows")
  table.insert(win, obj)
  skinui.windows[index]:set("windows", win)
end

function skinui:find(id) 
  for i=1, #skinui.windows do
    if skinui.windows[i]:get("id") == id then
      return i
    end
  end
  
  return false
end

function skinui:move(from, to)
  table.insert(skinui.windows, to, table.remove(skinui.windows, from))
end

function skinui:update(dt)
  
  for i=1, #skinui.windows do
    skinui.windows[i]:update(dt, mx - oldmx, my - oldmy)
  end

  oldmx = mx
  oldmy = my

  mx = love.mouse.getX()
  my = love.mouse.getY()
  
end

function skinui:get(id)
  for i=1, #skinui.windows do
    if id == skinui.windows[i]:get("id") then
      return skinui.windows[i]
    end
  end
  
  return false
end

function skinui:getElement(index)
  if skinui.windows[index] ~= nil then
    return skinui.windows[index]
  else
    return false
  end
end

function skinui:textinput(t)
  
  for i=1, #skinui.windows do
    if skinui.window_focusid == skinui.windows[i]:get("id") then
      return skinui.windows[i]:textinput(t)
    end
  end
  
  return false
  
end


function skinui:mousepressed(x, y, button, istouch)
  
  skinui.windows[1]:blur()
  for i=1, #skinui.windows do
    local wn = skinui.windows[i] 
    if x >= wn:get("left") and y >= wn:get("top") and x <= wn:get("left") + wn:get("width") and y <= wn:get("top") + wn:get("height") and skinui.window_focusid == wn:get("id") then
      skinui.window_mousedownid = wn:get("id")
      skinui.windows[i]:focus()
      if i ~= 1 then
        skinui:move(i, 1)
      end
      wn:mousepressed(x, y, button, istouch)
    end
      
    local wins = skinui.windows[i]:get("windows")
    local ox = skinui.windows[i]:get("left")
    local oy = skinui.windows[i]:get("top")
    if #wins > 0 then
      for j=1, #wins do
        if x >= wins[j]:get("left") + ox and y >= wins[j]:get("top") + oy and x <= wins[j]:get("left") + wins[j]:get("width") + ox and y <= wins[j]:get("top") + wins[j]:get("height") + oy then
          local blurid = skinui.windows[i]:find(skinui.windows[i]:get("window_focusid"))
          if blurid then
            wins[blurid]:blur()
          end
          skinui.windows[i]:set("window_focusid", wins[j]:get("id"))
          wins[j]:focus()
          wins[j]:mousepressed(x, y, button, istouch)
          return
        end
      end
    end
    
  end
  
  return false
end

function skinui:mousereleased(x, y, button, istouch)
  
  for i=1, #skinui.windows do
    local wn = skinui.windows[i] 
    if x >= wn:get("left") and y >= wn:get("top") and x <= wn:get("left") + wn:get("width") and y <= wn:get("top") + wn:get("height") and skinui.window_focusid == wn:get("id") then
      if skinui.window_mousedownid == skinui.window_focusid then
        wn:mousereleased(key, scancode)
        skinui.window_mousedownid = ""
        return wn:click(x, y, button, istouch)
      end
      skinui.window_mousedownid = ""
      return wn:mousereleased(key, scancode)
    elseif x >= wn:get("left") and y >= wn:get("top") and x <= wn:get("left") + wn:get("width") and y <= wn:get("top") + wn:get("height") and skinui.window_focusid ~= wn:get("id") then
      skinui.window_focusid = wn:get("id")
      skinui.window_mousedownid = ""
      return wn:mousereleased(key, scancode)
    end
  end
  
  return false
  
end

function skinui:mousemoved(x, y, dx, dy, istouch)
  
  for i=1, #skinui.windows do
    local wn = skinui.windows[i] 
    if x >= wn:get("left") and y >= wn:get("top") and x <= wn:get("left") + wn:get("width") and y <= wn:get("top") + wn:get("height") and skinui.window_focusid == wn:get("id") then
      return wn:mousemoved(x, y, dx, dy, istouch)
    elseif x >= wn:get("left") and y >= wn:get("top") and x <= wn:get("left") + wn:get("width") and y <= wn:get("top") + wn:get("height") and skinui.window_focusid ~= wn:get("id") then
      --skinui.window_focusid = wn:get("id")
      return wn:mousemoved(x, y, dx, dy, istouch)
    end
  end
  love.mouse.setCursor(love.mouse.getSystemCursor("arrow"))
  return false
  
end

function skinui:keypressed(key, scancode)
  
  for i=1, #skinui.windows do
    if skinui.window_focusid == skinui.windows[i]:get("id") then
      return skinui.windows[i]:keypressed(key, scancode)
    end
  end
  
  return false
  
end

function skinui:totop(id)
  local i = skinui:find(id)
  local wn = skinui.windows[i]
  
  skinui.window_focusid = wn:get("id")
  skinui:move(i, 1)
  
end

function skinui:draw()
  
  for i=#skinui.windows, 1, -1 do
    skinui.windows[i]:draw()
  end
  
end

return skinui