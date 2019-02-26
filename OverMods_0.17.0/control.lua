
function reset_state()
  if game and game.forces then
    for i, force in pairs(game.forces) do
      force.reset_technologies()
      force.reset_technology_effects()
      force.reset_recipes()
    end
  end
end


script.on_configuration_changed(reset_state)
script.on_init(reset_state)
script.on_load(reset_state)
