function default_split(t)
  if #t == 0 then return {0, 1, 1}
  elseif #t == 1 then return {t[1], 1, 1}
  elseif #t == 2 then return {t[2], t[1], 1}
  else return {t[3], t[2], t[1]}
  end
end

function map_inputs(s)
  local t = s:trim():split("*")
  if #t == 0 then error("Invalid Input: " .. s)
  elseif #t == 1 then return {t[1], 1}
  elseif #t == 2 then return {t[2], t[1]}
  end
end

function filter_inputs(t)
  return om_utils.tool_exists(t[1])
end


for m, m_defaults in pairs(consts.simple_modifiers) do
  for t = 1, consts.research_tiers do
    local tier = m_defaults[t]
    --log(serpent.block(tier))
    if not tier then
      tier = consts.simple_modifiers_default_tier
    end

    local basename = "overmods-research_modifier-" .. m .. "-" .. t
    --local prefix = settings.startup[basename .. "-prefix"].value
    local count = tonumber(settings.startup[basename .. "-count"].value)
    local value = tonumber(settings.startup[basename .. "-value"].value) -- :split(", "):map(tonumber)
    local prereqs = table.map(settings.startup[basename .. "-prereqs"].value:split(","), string.trim)
    local cost_inputs = table.filter(table.map(settings.startup[basename .. "-cost_inputs"].value:split(","), map_inputs), filter_inputs)
    local cost_count = settings.startup[basename .. "-cost_count"].value -- :split("*"):map(tonumber)
    local cost_time = tonumber(settings.startup[basename .. "-cost_time"].value) -- :split("*"):map(tonumber)

    prereqs = table.map(prereqs, function(r)
      if r == "<prior>"
        then return "overmods-research_modifier-" .. m .. "-" .. (t-1) .. "-1"
        else return r
      end
    end)
    prereqs = table.filter(prereqs, om_utils.technology_exists)

    if count == 0 or cost_inputs == "" or cost_count == "" or not (cost_time > 0) then
      if overmods.debug then log("Skipping modifier research: " .. m .. "-" .. t) end
    else
      if overmods.debug then log("Adding modifier research " .. m .. "-" .. t .. ":  " .. serpent.block(tier)) end

      -- value = default_split(value)
      -- cost_count = default_split(cost_count)
      -- cost_time = default_split(cost_time)

      if count < 0
      then count = "infinite"
      else count = "" .. count
      end

      data:extend{{
        type = "technology",
        name = basename .. "-1",
        icon_size = 128,
        icon = tier.icon,
        effects =
        {
          {
            type = m,
            modifier = value,
          }
        },
        prerequisites = prereqs,
        unit =
        {
          count_formula = cost_count,
          ingredients = cost_inputs,
          time = cost_time,
        },
        upgrade = true,
        max_level = count,
        order = "o-" .. tier.order .. "-" .. t,
      }}

      --if count > 0 then
      --  for c = 1, count do
      --    data:extend{{
      --      type = "technology",
      --      name = basename .. "-" .. c,
      --      icon_size = 128,
      --      icon = tier.icon,
      --      effects =
      --      {
      --        {
      --          type = m,
      --          modifier = math.pow(value[3], value[2] * (c-1)) * value[1]),
      --        }
      --      },
      --      prerequisites = prereqs,
      --      unit =
      --      {
      --        count = math.pow(cost_count[3], cost_count[2] * (c-1)) * cost_count[1],
      --        ingredients = cost_inputs:map(reify_inputs(c)),
      --        time = math.pow(cost_time[3], cost_time[2] * (c-1)) * cost_time[1]
      --      },
      --      upgrade = true,
      --      order = "o-" .. tier.order .. "-" .. t .. "-" .. c,
      --    }}
      --  end
      --elseif count < 0 then
      --  data:extend{{
      --    type = "technology",
      --    name = basename,
      --    icon_size = 128,
      --    icon = tier.icon,
      --    effects =
      --    {
      --      {
      --        type = m,
      --        modifier = value[2]
      --      }
      --    },
      --    prerequisites = prereqs,
      --    unit =
      --    {
      --      count_formula = cost_count[3] .."^" .. cost_count[2] .. "*" .. cost_count[1],
      --      ingredients = cost_inputs:map(reify_inputs(1)),
      --      time = cost_time[1]
      --    },
      --    max_level = "infinite",
      --    upgrade = true,
      --    order = "o-" .. tier.order .. "-" .. t .. "-" .. c,
      --  }}
      --end
    end
  end
end
