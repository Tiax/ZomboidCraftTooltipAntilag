ISRecipeTooltip.ClothingItemExtras = {}

-- Return true if item2's type is in item1's getClothingExtraItem() list.
-- Note: CraftTooltip == ISRecipeTooltip, sadly CraftTooltip is file local
-- This mimics the original behavior, just caches the results in a lua table instead of
-- calling the ScriptManager to find all items every single iteration
function ISRecipeTooltip:isExtraClothingItemOf(item1, item2)
  local key = item1.fullType
  
  if ISRecipeTooltip.ClothingItemExtras[key] == nil then
    -- entry does not exist: calculate similar types and cache the result for next time
    ISRecipeTooltip.ClothingItemExtras[key] = {}

    --print(string.format("Generating isExtraClothingItemOf for \"%s\"...", item1.fullType))

    local scriptItem = getScriptManager():FindItem(item1.fullType)
    
    if not scriptItem then
      return false
    end
    
    local extras = scriptItem:getClothingItemExtra()
    
    if not extras then
      return false
    end
    
    local moduleName = scriptItem:getModule():getName()

    for i=1, extras:size() do
      local extra = extras:get(i-1)
      local fullType = moduleDotType(moduleName, extra)
      table.insert(ISRecipeTooltip.ClothingItemExtras[key], fullType)
    end
  end

  for i=1, #ISRecipeTooltip.ClothingItemExtras[key] do
    local item1Type = ISRecipeTooltip.ClothingItemExtras[key][i]
    if item2.fullType == item1Type then
      return true
    end
  end

  return false
end
