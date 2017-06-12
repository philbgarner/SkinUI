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
      ,lineinput = {}
      ,lineinput_left = {}
      ,lineinput_right = {}
      
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

  -- Icons
  
  if images.icons_15x15_arrowUp == nil then images.icons_15x15_arrowUp = "lib/themes/default/arrow_up15x15.png" end
  if images.icons_15x15_arrowDown == nil then images.icons_15x15_arrowDown = "lib/themes/default/arrow_down15x15.png" end

  images.icons_15x15_arrowUp = love.graphics.newImage(images.icons_15x15_arrowUp)
  images.icons_15x15_arrowDown = love.graphics.newImage(images.icons_15x15_arrowDown)

  -- Skinning Elements

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
  if images.button_small == nil then images.button_small = "lib/themes/default/button_60x30.png" end
  if images.button_down_small == nil then images.button_down_small = "lib/themes/default/button_down_60x30.png" end
  if images.button_tiny == nil then images.button_tiny = "lib/themes/default/button_tiny_25x25.png" end
  if images.button_down_tiny == nil then images.button_down_tiny = "lib/themes/default/button_down_tiny_25x25.png" end
  if images.textbox_bg == nil then images.textbox_bg = "lib/themes/default/container_bg.png" end
  if images.textbox_ne == nil then images.textbox_ne = "lib/themes/default/container_ne.png" end
  if images.textbox_nw == nil then images.textbox_nw = "lib/themes/default/container_nw.png" end
  if images.textbox_se == nil then images.textbox_se = "lib/themes/default/container_se.png" end
  if images.textbox_sw == nil then images.textbox_sw = "lib/themes/default/container_sw.png" end
  if images.textbox_n == nil then images.textbox_n = "lib/themes/default/container_n.png" end
  if images.textbox_s == nil then images.textbox_s = "lib/themes/default/container_s.png" end
  if images.textbox_w == nil then images.textbox_w = "lib/themes/default/container_w.png" end
  if images.textbox_e == nil then images.textbox_e = "lib/themes/default/container_e.png" end
  if images.lineinput == nil then images.lineinput = "lib/themes/default/lineinput_120x35.png" end
  if images.lineinput_left == nil then images.lineinput_left = "lib/themes/default/lineinput_left_5x35.png" end
  if images.lineinput_right == nil then images.lineinput_right = "lib/themes/default/lineinput_right_5x35.png" end
  if images.vscroll_body == nil then images.vscroll_body = "lib/themes/default/scrollbar_body.png" end
  if images.vscroll_top == nil then images.vscroll_top = "lib/themes/default/scrollbar_top.png" end
  if images.vscroll_bottom == nil then images.vscroll_bottom = "lib/themes/default/scrollbar_bottom.png" end
  if images.vscroll_carat == nil then images.vscroll_carat = "lib/themes/default/scrollbar_carat.png" end
      
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
  images.button_small = love.graphics.newImage(images.button_small)
  images.button_down_small = love.graphics.newImage(images.button_down_small)
  images.textbox_bg = love.graphics.newImage(images.textbox_bg)
  images.textbox_ne = love.graphics.newImage(images.textbox_ne)
  images.textbox_se = love.graphics.newImage(images.textbox_se)
  images.textbox_sw = love.graphics.newImage(images.textbox_sw)
  images.textbox_nw = love.graphics.newImage(images.textbox_nw)
  images.textbox_n = love.graphics.newImage(images.textbox_n)
  images.textbox_e = love.graphics.newImage(images.textbox_e)
  images.textbox_w = love.graphics.newImage(images.textbox_w)
  images.textbox_s = love.graphics.newImage(images.textbox_s)
  images.lineinput_right = love.graphics.newImage(images.lineinput_right)
  images.lineinput_left = love.graphics.newImage(images.lineinput_left)
  images.lineinput = love.graphics.newImage(images.lineinput)
  images.button_tiny = love.graphics.newImage(images.button_tiny)
  images.button_down_tiny = love.graphics.newImage(images.button_down_tiny)
  images.vscroll_body = love.graphics.newImage(images.vscroll_body)
  images.vscroll_top = love.graphics.newImage(images.vscroll_top)
  images.vscroll_bottom = love.graphics.newImage(images.vscroll_bottom)
  images.vscroll_carat = love.graphics.newImage(images.vscroll_carat)
  
  images.bg_image:setWrap(repeatStyle, repeatStyle)
  images.corner_nw:setWrap(repeatStyle, repeatStyle)
  images.corner_sw:setWrap(repeatStyle, repeatStyle)
  images.corner_ne:setWrap(repeatStyle, repeatStyle)
  images.corner_se:setWrap(repeatStyle, repeatStyle)
  images.border_n:setWrap(repeatStyle, repeatStyle)
  images.border_e:setWrap(repeatStyle, repeatStyle)
  images.border_s:setWrap(repeatStyle, repeatStyle)
  images.border_w:setWrap(repeatStyle, repeatStyle)
  images.lineinput:setWrap(repeatStyle, repeatStyle)
  images.lineinput_left:setWrap(repeatStyle, repeatStyle)
  images.lineinput_right:setWrap(repeatStyle, repeatStyle)
  
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
  dimensions.button_med.width = images.button_med:getWidth()
  dimensions.button_med.height = images.button_med:getHeight()
  dimensions.button_down_med.width = images.button_down_med:getWidth()
  dimensions.button_down_med = images.button_down_med:getHeight()
  dimensions.textbox_bg.width = images.textbox_bg:getWidth()
  dimensions.textbox_bg.height = images.textbox_bg:getHeight()
  dimensions.textbox_ne.width = images.textbox_ne:getWidth()
  dimensions.textbox_ne.height = images.textbox_ne:getHeight()
  dimensions.textbox_se.width = images.textbox_se:getWidth()
  dimensions.textbox_se.height = images.textbox_se:getHeight()
  dimensions.textbox_sw.width = images.textbox_sw:getWidth()
  dimensions.textbox_sw.height = images.textbox_sw:getHeight()
  dimensions.textbox_nw.width = images.textbox_nw:getWidth()
  dimensions.textbox_nw.height = images.textbox_nw:getHeight()
  dimensions.textbox_n.width = images.textbox_n:getWidth()
  dimensions.textbox_n.height = images.textbox_n:getHeight()
  dimensions.textbox_e.width = images.textbox_e:getWidth()
  dimensions.textbox_e.height = images.textbox_e:getHeight()
  dimensions.textbox_w.width = images.textbox_w:getWidth()
  dimensions.textbox_w.height = images.textbox_w:getHeight()
  dimensions.textbox_s.width = images.textbox_s:getWidth()
  dimensions.textbox_s.height = images.textbox_s:getHeight()
  dimensions.lineinput_right.width = images.lineinput_right:getWidth()
  dimensions.lineinput_right.height = images.lineinput_right:getHeight()
  dimensions.lineinput_left.width = images.lineinput_left:getWidth()
  dimensions.lineinput_left.height = images.lineinput_left:getHeight()
  dimensions.lineinput.width = images.lineinput:getWidth()
  dimensions.lineinput.height = images.lineinput:getHeight()
  
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