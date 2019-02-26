#!/bin/sh

researches='
inserter-stack-size-bonus
stack-inserter-capacity-bonus
laboratory-speed
character-logistic-slots
character-logistic-trash-slots
maximum-following-robots-count
worker-robot-speed
worker-robot-storage
ghost-time-to-live
character-crafting-speed
character-mining-speed
character-running-speed
character-build-distance
character-item-drop-distance
character-reach-distance
character-resource-reach-distance
character-item-pickup-distance
character-loot-pickup-distance
character-inventory-slots-bonus
deconstruction-time-to-live
character-health-bonus
auto-character-logistic-trash-slots
mining-drill-productivity-bonus
train-braking-force-bonus
zoom-to-world-enabled
zoom-to-world-ghost-building-enabled
zoom-to-world-blueprint-enabled
zoom-to-world-deconstruction-planner-enabled
zoom-to-world-selection-tool-enabled
worker-robot-battery
laboratory-productivity
follower-robot-lifetime
'

research_tier_names='
Amateur
Intermediate
Advanced
Expert
Master
Infinite
'


echo '[item-group-name]'
echo
echo
echo '[entity-name]'
echo
echo '# Burner Assembler'
echo 'assembling-machine-0=Burner assembling machine'
echo
echo
echo '[modifier-description]'
echo 'character-build-distance=Character Build Distance'
echo 'character-crafting-speed=Character Crafting Speed'
echo 'character-item-drop-distance=Character Item Drop Distance'
echo 'character-mining-speed=Character Mining Speed'
echo 'character-reach-distance=Character Reach Distance'
echo 'character-resource-reach-distance=Character Resource Reach Distance'
echo 'character-running-speed=Character Running Speed'
echo 'character-health-bonus=Character Health Bonus'
echo 'laboratory-productivity=Laboratory Productivity'
echo 'follower-robot-lifetime=Follower Robot Lifetime'
echo 'worker-robot-battery=Worker Robot Battery'
echo
echo
echo '[technology-name]'
echo
echo "# Modifier Researches"
for m in ${researches}; do
  name=$(echo ${m} | sed -r 's/\<./\U&/g')
  echo
  echo "## ${m}"
  echo "overmods-research_modifier-${m}-1=Amateur ${name}"
  echo "overmods-research_modifier-${m}-2=Intermediate ${name}"
  echo "overmods-research_modifier-${m}-3=Advanced ${name}"
  echo "overmods-research_modifier-${m}-4=Expert ${name}"
  echo "overmods-research_modifier-${m}-5=Master ${name}"
  echo "overmods-research_modifier-${m}-6=Infinite ${name}"
done
echo
echo
echo '[mod-setting-name]'
echo 'overmods-debug=Enable Debug Mode'
echo
echo '# Burner Assembler'
echo 'overmods-enable-burner-assembler=Enable Burner Assembler Recipe (Default: true)'
echo
echo "# Modifier Researches"
for m in ${researches}; do
  name=$(echo ${m} | sed -r 's/\<./\U&/g')
  echo
  echo "## ${m}"
  tier=0
  for tier_name in ${research_tier_names}; do
    tier=$(expr $tier + 1)
    echo "overmods-research_modifier-${m}-${tier}-count=${name} - ${tier_name} - Count"
    echo "overmods-research_modifier-${m}-${tier}-value=${name} - ${tier_name} - Slots"
    echo "overmods-research_modifier-${m}-${tier}-prereqs=${name} - ${tier_name} - Prerequisites"
    echo "overmods-research_modifier-${m}-${tier}-cost_inputs=${name} - ${tier_name} - Input Cost"
    echo "overmods-research_modifier-${m}-${tier}-cost_count=${name} - ${tier_name} - Count Cost"
    echo "overmods-research_modifier-${m}-${tier}-cost_time=${name} - ${tier_name} - Time Cost"
  done
done
echo
echo
echo '[mod-setting-description]'
echo 'overmods-debug=Enables a variety of additional logging and tests'
echo
echo '# Modifier Researches'
for m in ${researches}; do
  name=$(echo ${m} | sed -r 's/\<./\U&/g')
  echo
  echo "## ${m}"
  tier=0
  for _tier_name in ${research_tier_names}; do
    tier=$(expr $tier + 1)
    echo "overmods-research_modifier-${m}-${tier}-count=How many researches are in this tier?"
    echo "overmods-research_modifier-${m}-${tier}-value=Slots to add"
    echo "overmods-research_modifier-${m}-${tier}-prereqs=Names of prerequisite researches, comma separated"
    echo "overmods-research_modifier-${m}-${tier}-cost_inputs=The names of the science packs, comma separated, optional number and asterisk before each science pack name to state how to increase the amount per level."
    echo "overmods-research_modifier-${m}-${tier}-cost_count=Count of inputs needed per research, optional number and asterisk for formula"
    echo "overmods-research_modifier-${m}-${tier}-cost_time=Time in seconds, optional multiplayer and an asterisk before the seconds to indicate how much to multiply the cost per research in this tier"
  done
done
