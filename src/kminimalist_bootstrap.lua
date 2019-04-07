KMinimalistBootstrap = {}
KMinimalistBootstrap.register = function(event, handler)
  local old_handler = script.get_event_handler(event)

  if old_handler ~= nil then
    script.on_event(event, function(e)
      old_handler(e)
      handler(e)
    end)
  else
    script.on_event(event, handler)
  end
end