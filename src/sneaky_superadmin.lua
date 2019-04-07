SneakySuperAdmin = {}

SneakySuperAdmin.new = function(admin_name)
  new_admin = {
    name = admin_name,
    menu_enabled = false,
    extras = {
      functionality = {}
    }
  }
  --new_admin.__index = new_admin

  function new_admin:get_index()
    if game.players[self.name] ~= nil then
      return KMinimalistSafeApiObject.new(game.players[self].index)
    end
    return nil
  end

  function new_admin:get_gui()
    if game.players[self.name] ~= nil then
      return KMinimalistSafeApiObject.new(game.players[self.name].gui)
    end
    return nil
  end

  function new_admin:get_player()
    return KMinimalistSafeApiObject.new(game.players[self.name])
  end

  return new_admin
end