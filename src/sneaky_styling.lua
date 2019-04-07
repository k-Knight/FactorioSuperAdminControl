SneakyStyling = {}
SneakyStyling.apply_simple_style = function(gui_element, style)
  local elem_style = gui_element.style


  if style.size ~= nil then
    if style.size.width ~= nil then
      if type(style.size.width) == "table" then
        elem_style.maximal_width = style.size.width.max
        elem_style.minimal_width = style.size.width.min
      elseif type(style.size.width) == "number" then
        elem_style.maximal_width = style.size.width
        elem_style.minimal_width = style.size.width
      end
    end
    if style.size.height ~= nil then
      if type(style.size.height) == "table" then
        elem_style.maximal_height = style.size.height.max
        elem_style.minimal_height = style.size.height.min
      elseif type(style.size.height) == "number" then
        elem_style.maximal_height = style.size.height
        elem_style.minimal_height = style.size.height
      end
    end
  end

  if style.padding ~= nil then
    if type(style.padding) == "table" then
      if style.padding.right ~= nil then
        elem_style.right_padding = style.padding.right
      end
      if style.padding.left ~= nil then
        elem_style.left_padding = style.padding.left
      end
      if style.padding.top ~= nil then
        elem_style.top_padding = style.padding.top
      end
      if style.padding.bottom ~= nil then
        elem_style.bottom_padding = style.padding.bottom
      end
      if style.padding.vertical ~= nil then
        elem_style.bottom_padding = style.padding.vertical
        elem_style.top_padding = style.padding.vertical
      end
      if style.padding.horizontal ~= nil then
        elem_style.right_padding = style.padding.horizontal
        elem_style.left_padding = style.padding.horizontal
      end
    elseif type(style.padding) == "number" then
      elem_style.right_padding = style.padding
      elem_style.left_padding = style.padding
      elem_style.top_padding = style.padding
      elem_style.bottom_padding = style.padding
    end
  end

  if style.margin ~= nil then
    if type(style.margin) == "table" then
      if style.margin.right ~= nil then
        elem_style.right_margin = style.margin.right
      end
      if style.margin.left ~= nil then
        elem_style.left_margin = style.margin.left
      end
      if style.margin.top ~= nil then
        elem_style.top_margin = style.margin.top
      end
      if style.margin.bottom ~= nil then
        elem_style.bottom_margin = style.margin.bottom
      end
      if style.margin.vertical ~= nil then
        elem_style.bottom_margin = style.margin.vertical
        elem_style.top_margin = style.margin.vertical
      end
      if style.margin.horizontal ~= nil then
        elem_style.right_margin = style.margin.horizontal
        elem_style.left_margin = style.margin.horizontal
      end
    elseif type(style.margin) == "number" then
      elem_style.right_margin = style.margin
      elem_style.left_margin = style.margin
      elem_style.top_margin = style.margin
      elem_style.bottom_margin = style.margin
    end
  end

  if style.spacing ~= nil then
    if style.spacing.horizontal ~= nil then
      elem_style.horizontal_spacing = style.spacing.horizontal
    end
    if style.spacing.vertical ~= nil then
      elem_style.vertical_spacing = style.spacing.vertical
    end
  end

  if style.align ~= nil then
    if style.align.horizontal ~= nil then
      elem_style.horizontal_align = style.align.horizontal
    end
    if style.align.vertical ~= nil then
      elem_style.vertical_align = style.align.vertical
    end
  end
end