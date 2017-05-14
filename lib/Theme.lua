--[[

  Theme class
  
  By Phil Garner
  May 2017
  
  
]]--

local Theme = {}
Theme.__index = Theme

function Theme:new(images, dimensions)
  if images == nil then images = {} end
  if dimensions == nil then
    dimensions = {
      bg_image = {}
      ,corner_nw = {}
      ,corner_ne = {}
      ,corner_sw = {}
      ,corner_se = {}
      ,border_n = {}
      ,border_e = {}
      ,border_s = {}
      ,border_w = {}
      ,textinput = {}
      
      ,textbox_bg = {}
      ,textbox_ne = {}
      ,textbox_nw = {}
      ,textbox_se = {}
      ,textbox_sw = {}
      ,textbox_n = {}
      ,textbox_s = {}
      ,textbox_w = {}
      ,textbox_e = {}

      ,button_med = {}
      ,button_down_med = {}
    }
  end

  local repeatStyle = "repeat"  -- or use "mirroredrepeat"

  if images.bg_image == nil then images.bg_image = "lib/themes/default/bgimage.png" end
  if images.corner_nw == nil then images.corner_nw = "lib/themes/default/corner_nw.png" end
  if images.corner_sw == nil then images.corner_sw = "lib/themes/default/corner_sw.png" end
  if images.corner_ne == nil then images.corner_ne = "lib/themes/default/corner_ne.png" end
  if images.corner_se == nil then images.corner_se = "lib/themes/default/corner_se.png" end
  if images.border_n == nil then images.border_n = "lib/themes/default/border_n.png" end
  if images.border_e == nil then images.border_e = "lib/themes/default/border_e.png" end
  if images.border_s == nil then images.border_s = "lib/themes/default/border_s.png" end
  if images.border_w == nil then images.border_w = "lib/themes/default/border_w.png" end
  if images.textinput == nil then images.textinput = "lib/themes/default/textinput_242x35.png" end
  if images.button_med == nil then images.button_med = "lib/themes/default/button_225x40.png" end
  if images.button_down_med == nil then images.button_down_med = "lib/themes/default/button_down_225x40.png" end
  if images.textbox_bg == nil then images.textbox_bg = "lib/themes/default/container_bg.png" end
  if images.textbox_ne == nil then images.textbox_ne = "lib/themes/default/container_ne.png" end
  if images.textbox_nw == nil then images.textbox_nw = "lib/themes/default/container_nw.png" end
  if images.textbox_se == nil then images.textbox_se = "lib/themes/default/container_se.png" end
  if images.textbox_sw == nil then images.textbox_sw = "lib/themes/default/container_sw.png" end
  if images.textbox_n == nil then images.textbox_n = "lib/themes/default/container_n.png" end
  if images.textbox_s == nil then images.textbox_s = "lib/themes/default/container_s.png" end
  if images.textbox_w == nil then images.textbox_w = "lib/themes/default/container_w.png" end
  if images.textbox_e == nil then images.textbox_e = "lib/themes/default/container_e.png" end
      
  images.bg_image = love.graphics.newImage(images.bg_image)
  images.corner_nw = love.graphics.newImage(images.corner_nw)
  images.corner_sw = love.graphics.newImage(images.corner_sw)
  images.corner_ne = love.graphics.newImage(images.corner_ne)
  images.corner_se = love.graphics.newImage(images.corner_se)
  images.border_n = love.graphics.newImage(images.border_n)
  images.border_e = love.graphics.newImage(images.border_e)
  images.border_s = love.graphics.newImage(images.border_s)
  images.border_w = love.graphics.newImage(images.border_w)
  images.textinput = love.graphics.newImage(images.textinput)
  images.button_med = love.graphics.newImage(images.button_med)
  images.button_down_med = love.graphics.newImage(images.button_down_med)
  images.textbox_bg = love.graphics.newImage(images.textbox_bg)
  images.textbox_ne = love.graphics.newImage(images.textbox_ne)
  images.textbox_se = love.graphics.newImage(images.textbox_se)
  images.textbox_sw = love.graphics.newImage(images.textbox_sw)
  images.textbox_nw = love.graphics.newImage(images.textbox_nw)
  images.textbox_n = love.graphics.newImage(images.textbox_n)
  images.textbox_e = love.graphics.newImage(images.textbox_e)
  images.textbox_w = love.graphics.newImage(images.textbox_w)
  images.textbox_s = love.graphics.newImage(images.textbox_s)
  
  images.bg_image:setWrap(repeatStyle, repeatStyle)
  images.corner_nw:setWrap(repeatStyle, repeatStyle)
  images.corner_sw:setWrap(repeatStyle, repeatStyle)
  images.corner_ne:setWrap(repeatStyle, repeatStyle)
  images.corner_se:setWrap(repeatStyle, repeatStyle)
  images.border_n:setWrap(repeatStyle, repeatStyle)
  images.border_e:setWrap(repeatStyle, repeatStyle)
  images.border_s:setWrap(repeatStyle, repeatStyle)
  images.border_w:setWrap(repeatStyle, repeatStyle)
  
  dimensions.bg_image.width = images.bg_image:getWidth()
  dimensions.bg_image.height = images.bg_image:getHeight()
  dimensions.corner_nw.width = images.corner_nw:getWidth()
  dimensions.corner_nw.height = images.corner_nw:getHeight()
  dimensions.corner_ne.width = images.corner_ne:getWidth()
  dimensions.corner_ne.height = images.corner_ne:getHeight()
  dimensions.corner_sw.width = images.corner_sw:getWidth()
  dimensions.corner_sw.height = images.corner_sw:getHeight()
  dimensions.corner_se.width = images.corner_se:getWidth()
  dimensions.corner_se.height = images.corner_se:getHeight()
  dimensions.border_w.width = images.border_w:getWidth()
  dimensions.border_w.height = images.border_w:getHeight()
  dimensions.border_n.width = images.border_n:getWidth()
  dimensions.border_n.height = images.border_n:getHeight()
  dimensions.border_e.width = images.border_e:getWidth()
  dimensions.border_e.height = images.border_e:getHeight()
  dimensions.border_s.width = images.border_s:getWidth()
  dimensions.border_s.height = images.border_s:getHeight()
  dimensions.textinput.width = images.textinput:getWidth()
  dimensions.textinput.height = images.textinput:getHeight()
  dimensions.button_med = images.button_med:getWidth()
  dimensions.button_med = images.button_med:getHeight()
  dimensions.button_down_med = images.button_down_med:getWidth()
  dimensions.button_down_med = images.button_down_med:getHeight()
  
  local thm = {

      props = {
          images = images
          ,dimensions = dimensions
        }
    
    }
  setmetatable(thm, Theme)
  
  return thm
  
end

function Theme:set(prop, val)

  self.props[prop] = val
  
  return true
  
end

function Theme:get(prop)
    
  if self.props[prop] == nil then
    return false
  end
  
  return self.props[prop]
  
end

function Theme:save(filename)
  
end

function Theme:load(filename)
  
end

return Theme