function apply_simple_style(gui_element, style)
    if style.size ~= nil then
      if style.size.width ~= nil then
        if type(style.size.width) == "table" then
          gui_element.style.maximal_width = style.size.width.max
          gui_element.style.maximal_width = style.size.width.min
        elseif type(style.size.width) == "number" then
          gui_element.style.maximal_width = style.size.width
          gui_element.style.minimal_width = style.size.width
        end
      end
      if style.size.height ~= nil then
        if type(style.size.height) == "table" then
          gui_element.style.maximal_height = style.size.height.max
          gui_element.style.maximal_height = style.size.height.min
        elseif type(style.size.height) == "number" then
          gui_element.style.maximal_height = style.size.height
          gui_element.style.minimal_height = style.size.height
        end
      end
    end

    if style.padding ~= nil then
      if type(style.padding) == "table" then
        if style.padding.right ~= nil then
          gui_element.style.right_padding = style.padding.right
        end
        if style.padding.left ~= nil then
          gui_element.style.left_padding = style.padding.left
        end
        if style.padding.top ~= nil then
          gui_element.style.top_padding = style.padding.top
        end
        if style.padding.bottom ~= nil then
          gui_element.style.bottom_padding = style.padding.bottom
        end
        if style.padding.vertical ~= nil then
          gui_element.style.bottom_padding = style.padding.vertical
          gui_element.style.top_padding = style.padding.vertical
        end
        if style.padding.horizontal ~= nil then
          gui_element.style.right_padding = style.padding.horizontal
          gui_element.style.left_padding = style.padding.horizontal
        end
      elseif type(style.padding) == "number" then
        gui_element.style.right_padding = style.padding
        gui_element.style.left_padding = style.padding
        gui_element.style.top_padding = style.padding
        gui_element.style.bottom_padding = style.padding
      end
    end

    if style.margin ~= nil then
      if type(style.margin) == "table" then
        if style.margin.right ~= nil then
          gui_element.style.right_margin = style.margin.right
        end
        if style.margin.left ~= nil then
          gui_element.style.left_margin = style.margin.left
        end
        if style.margin.top ~= nil then
          gui_element.style.top_margin = style.margin.top
        end
        if style.margin.bottom ~= nil then
          gui_element.style.bottom_margin = style.margin.bottom
        end
        if style.margin.vertical ~= nil then
          gui_element.style.bottom_margin = style.margin.vertical
          gui_element.style.top_margin = style.margin.vertical
        end
        if style.margin.horizontal ~= nil then
          gui_element.style.right_margin = style.margin.horizontal
          gui_element.style.left_margin = style.margin.horizontal
        end
      elseif type(style.margin) == "number" then
        gui_element.style.right_margin = style.margin
        gui_element.style.left_margin = style.margin
        gui_element.style.top_margin = style.margin
        gui_element.style.bottom_margin = style.margin
      end
    end
  end