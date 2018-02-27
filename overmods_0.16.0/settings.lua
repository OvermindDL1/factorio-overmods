--[[
Types of settings:
* startup - game must be restarted if changed (such a setting may affect prototypes' changes)
* runtime-global - per-world setting
* runtime-per-user - per-user setting

Types of values:
* bool-setting
* double-setting
* int-setting
* string-setting

Files being processed by the game:
* settings.lua
* settings-updates.lua
* settings-final-fixes.lua

Using in DATA.lua:
data:extend({
   {
      type = "int-setting",
      name = "setting-name1",
      setting_type = "runtime-per-user",
      default_value = 25,
      minimum_value = -20,
      maximum_value = 100,
      per_user = true,
   },
   {
      type = "bool-setting",
      name = "setting-name2",
      setting_type = "runtime-per-user",
      default_value = true,
      per_user = true,
   },
   {
      type = "double-setting",
      name = "setting-name3",
      setting_type = "runtime-per-user",
      default_value = -23,
      per_user = true,
   },
   {
      type = "string-setting",
      name = "setting-name4",
      setting_type = "runtime-per-user",
      default_value = "Hello",
      allowed_values = {"Hello", "foo", "bar"}, -- Optional
      allow_blank = false -- Optional
      per_user = true,
   },
})

Optional keys:
* order

Using in LOCALE.cfg:
* [mod-setting-name]
* setting-name1=Seting name
* [mod-setting-description]
* setting-name1=Seting description

Using in CONTROL.lua and in other code for reading:
* EVENT: on_runtime_mod_setting_changed - called when a player changed its setting
* * event.player_index
* * event.setting
* GET: settings.startup["setting-name"].value - current value of startup setting; can be used in DATA.lua
* GET: settings.global["setting-name"].value - current value of per-world setting
* GET: set = settings.get_player_settings(LuaPlayer) - current values for per-player settings; then use set["setting-name"].value
* GET: settings.player - default values
]]

local consts = require("consts")

data:extend{
  {
    type = "bool-setting",
    name = "overmods-debug",
    setting_type = "startup",
    default_value = true,
    per_user = false,
    order = "z-z-z-z",
  },
}

local simple_modifier_settings = {}
for m, m_defaults in pairs(consts.simple_modifiers) do

    --table.insert(simple_modifier_settings, {
    --  type = "string-setting",
    --  name = "overmods-research_modifier-" .. m .. "-prereqs",
    --  setting_type = "startup",
    --  default_value = m_defaults.prerequisites,
    --    allow_blank = true,
    --  per_user = false,
    --  order = "r-m-" .. m .. "-a",
    --})

    for t = 1, consts.research_tiers do
      local tier = m_defaults[t]
      if not tier then
        tier = consts.simple_modifiers_default_tier
      end

      table.insert(simple_modifier_settings, {
        type = "int-setting",
        name = "overmods-research_modifier-" .. m .. "-" .. t .. "-count",
        setting_type = "startup",
        default_value = tier.count,
        minimum_value = -1,
        maximum_value = 100,
        per_user = false,
        order = "r-m-" .. m .. "-" .. t .. "-b",
      })
      table.insert(simple_modifier_settings, {
        type = "string-setting",
        name = "overmods-research_modifier-" .. m .. "-" .. t .. "-value",
        setting_type = "startup",
        default_value = tier.value,
        allow_blank = true,
        per_user = false,
        order = "r-m-" .. m .. "-" .. t .. "-c",
      })
      table.insert(simple_modifier_settings, {
        type = "string-setting",
        name = "overmods-research_modifier-" .. m .. "-" .. t .. "-prereqs",
        setting_type = "startup",
        default_value = tier.prereqs,
        allow_blank = true,
        per_user = false,
        order = "r-m-" .. m .. "-" .. t .. "-d",
      })
      table.insert(simple_modifier_settings, {
        type = "string-setting",
        name = "overmods-research_modifier-" .. m .. "-" .. t .. "-cost_inputs",
        setting_type = "startup",
        default_value = tier.cost_inputs,
        allow_blank = true,
        per_user = false,
        order = "r-m-" .. m .. "-" .. t .. "-e",
      })
      table.insert(simple_modifier_settings, {
        type = "string-setting",
        name = "overmods-research_modifier-" .. m .. "-" .. t .. "-cost_count",
        setting_type = "startup",
        default_value = tier.cost_count,
        allow_blank = true,
        per_user = false,
        order = "r-m-" .. m .. "-" .. t .. "-f",
      })
      table.insert(simple_modifier_settings, {
        type = "int-setting",
        name = "overmods-research_modifier-" .. m .. "-" .. t .. "-cost_time",
        setting_type = "startup",
        default_value = tier.cost_time,
        minimum_value = 1,
        maximum_value = 10000,
        allow_blank = true,
        per_user = false,
        order = "r-m-" .. m .. "-" .. t .. "-g",
      })
    end

end
--log(serpent.block(simple_modifier_settings))
data:extend(simple_modifier_settings)
