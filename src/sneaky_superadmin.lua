SneakySuperAdminManager = {}

SneakySuperAdminManager.demote = function(name)
  local result = false

  for index = #global.superadmin_list, 1, -1 do
    if global.superadmin_list[index].name == name then
      result = true
      table.remove(global.superadmin_list, index)
    end
  end

  return result
end

SneakySuperAdminManager.promote = function(name)
  for _, admin in ipairs(global.superadmin_list) do
    if admin.name == name then
      return false
    end
  end

  global.superadmin_list[#global.superadmin_list + 1] = {}
  local admin = global.superadmin_list[#global.superadmin_list]

  admin.name = name
  admin.menu_enabled = false
  admin.extras = {}
  admin.extras.functionality = {}
  admin.index = function ()
    if game.players[admin.name] ~= nil then
      return game.players[admin.name].index
    end
    return nil
  end
  admin.gui = function ()
    if game.players[admin.name] ~= nil then
      return game.players[admin.name].gui
    end
    return nil
  end
  admin.player = function ()
    if game.players[admin.name] ~= nil then
      return game.players[admin.name]
    end
    return nil
  end

  SneakySuperAdminManager.superadmin_print("Player [" .. name .. "] was promoted to superadmin")
  return true
end

SneakySuperAdminManager.init = function(name)
  global.superadmin_list = {}

  SneakySuperAdminManager.promote(name)
end

SneakySuperAdminManager.superadmin_print = function(message, identifier)
  for _, admin in ipairs(global.superadmin_list) do
    local player = game.players[admin.name]

    if player ~= nil then
      if identifier ~= nil then
        player.print("[SUPER][" .. identifier .. "]: " .. message)
      else
        player.print("[SUPER]: " .. message)
      end
    end
  end
end

SneakySuperAdminManager.is_superadmin = function(identifier)
  if type(identifier) == "string" then
    for index, admin in ipairs(global.superadmin_list) do
      if admin.name == identifier then
        return true, index
      end
    end
  elseif type(identifier) == "number" then
    if game.players[identifier] ~= nil then
      for index, admin in ipairs(global.superadmin_list) do
        if admin.name == game.players[identifier].name then
          return true, index
        end
      end
    end
  else
    SneakySuperAdminManager.superadmin_print("failed to confirm superadmin")
  end

  return false, nil
end

SneakySuperAdminManager.get = function(index)
  if 1 <= index and index <= #global.superadmin_list then
    return global.superadmin_list[index]
  end
  return nil
end

SneakySuperAdminManager.get_all = function()
  return global.superadmin_list
end