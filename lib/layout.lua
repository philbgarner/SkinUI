local layout = {
    area = {x = 0, y = 0, w = 0, h = 0}
    ,cursor = {x = 0, y = 0}
    ,margin = {x = 5, y = 5}
    
  }

function layout:reset(x, y, w, h)
  layout.area = {x = x, y = y, w = w, h = h}
end

function layout:col(w, h)
  layout.cursor.x = layout.cursor.x + layout.margin.x
  if layout.cursor.x > layout.area.x + layout.area.w then
    layout.cursor.x = layout.area.x
    layout.cursor.y = layout.cursor.y + layout.margin.y
  end
  
  return {x = layout.cursor.x, y = layout.cursor.y, w = w, h = h}
end

function layout:row(w, h)
  layout.cursor.y = layout.cursor.y + layout.margin.y
  layout.cursor.x = layout.area.x
  
  return {x = layout.cursor.x, y = layout.cursor.y, w = w, h = h}
end

function layout:locate(x, y)
  
  layout.cursor.x = x + layout.area.x
  layout.cursor.y = y + layout.area.y
  
end

return layout