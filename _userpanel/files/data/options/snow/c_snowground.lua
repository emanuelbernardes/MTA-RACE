
local bSnowEffectEnabled = false
noiseTexture, snowShader, treeShader, naughtyTreeShader, vehTimer = nil, nil, nil, nil, nil
local removeVehTextures = function()
  if not bHasFastRemove then
    return 
  end
  local veh = getPedOccupiedVehicle(localPlayer)
  if veh then
    local id = getElementModel(veh)
    local vis = engineGetVisibleTextureNames("*", id)
  end
  if vis then
    for _,removeMatch in pairs(vis) do
      if not doneVehTexRemove[removeMatch] then
        doneVehTexRemove[removeMatch] = true
        engineRemoveShaderFromWorldTexture(snowShader, removeMatch)
      end
    end
  end
end

local maxEffectDistance = 250
local snowApplyList = {"*"}
local snowRemoveList = {"", "vehicle*", "?emap*", "?hite*", "*92*", "*wheel*", "*interior*", "*handle*", "*body*", "*decal*", "*8bit*", "*logos*", "*badge*", "*plate*", "*sign*", "headlight", "headlight1", "shad*", "coronastar", "tx*", "lod*", "cj_w_grad", "*cloud*", "*smoke*", "sphere_cj", "particle*", "*water*", "sw_sand", "coral"}
local treeApplyList = {"sm_des_bush*", "*tree*", "*ivy*", "*pine*", "veg_*", "*largefur*", "hazelbr*", "weeelm", "*branch*", "cypress*", "*bark*", "gen_log", "trunk5", "bchamae", "vegaspalm01_128"}
local naughtyTreeApplyList = {"planta256", "sm_josh_leaf", "kbtree4_test", "trunk3", "newtreeleaves128", "ashbrnch", "pinelo128", "tree19mi", "lod_largefurs07", "veg_largefurs05", "veg_largefurs06", "fuzzyplant256", "foliage256", "cypress1", "cypress2"}
enableGoundSnow = function()
  if bSnowEffectEnabled then
    return 
  end
  snowShader = dxCreateShader("files/data/options/snow/snow_ground.fx", 0, maxEffectDistance)
  treeShader = dxCreateShader("files/data/options/snow/snow_trees.fx")
  naughtyTreeShader = dxCreateShader("files/data/options/snow/snow_naughty_trees.fx")
  sNoiseTexture = dxCreateTexture("files/data/options/snow/smallnoise3d.dds")
  
  dxSetShaderValue(treeShader, "sNoiseTexture", sNoiseTexture)
  dxSetShaderValue(naughtyTreeShader, "sNoiseTexture", sNoiseTexture)
  dxSetShaderValue(snowShader, "sNoiseTexture", sNoiseTexture)
  dxSetShaderValue(snowShader, "sFadeEnd", maxEffectDistance)
  dxSetShaderValue(snowShader, "sFadeStart", maxEffectDistance / 2)
  for _,applyMatch in ipairs(snowApplyList) do
    engineApplyShaderToWorldTexture(snowShader, applyMatch)
  end
  for _,removeMatch in ipairs(snowRemoveList) do
    engineRemoveShaderFromWorldTexture(snowShader, removeMatch)
  end
  for _,applyMatch in ipairs(treeApplyList) do
    engineApplyShaderToWorldTexture(treeShader, applyMatch)
  end
  for _,applyMatch in ipairs(naughtyTreeApplyList) do
    engineApplyShaderToWorldTexture(naughtyTreeShader, applyMatch)
  end
  doneVehTexRemove = {}
  vehTimer = setTimer(checkCurrentVehicleSnow, 100, 0)
  removeVehTextures()
  bSnowEffectEnabled = true
  showHelp()
end

disableGoundSnow = function()
  if not bSnowEffectEnabled then
    return 
  end
  destroyElement(sNoiseTexture)
  destroyElement(treeShader)
  destroyElement(naughtyTreeShader)
  destroyElement(snowShader)
  killTimer(vehTimer)
  bSnowEffectEnabled = false
end

local nextCheckTime = 0
local bHasFastRemove = getVersion().sortable > "1.1.1-9.03285"
addEventHandler("onClientPlayerVehicleEnter", root, function()
  removeVehTexturesSoonSnow()
end
)
checkCurrentVehicleSnow = function()
  local veh = getPedOccupiedVehicle(localPlayer)
  if veh then
    local id = getElementModel(veh)
  end
  if lastveh ~= veh or lastid ~= id then
    lastveh = veh
    lastid = id
    removeVehTexturesSoonSnow()
  end
  if nextCheckTime < getTickCount() then
    nextCheckTime = getTickCount() + 5000
    removeVehTextures()
  end
end

removeVehTexturesSoonSnow = function()
  nextCheckTime = getTickCount() + 200
end

showHelp = function()
  if bShowHelp ~= nil then
    return 
  end
  bShowHelp = true
  helpStartTime = getTickCount()
end

_dxCreateShader = dxCreateShader
dxCreateShader = function(filepath, priority, maxDistance, bDebug)
  if not priority then
    priority = 0
  end
  if not maxDistance then
    maxDistance = 0
  end
  if not bDebug then
    bDebug = false
  end
  local build = getVersion().sortable:sub(9)
  local fullscreen = not dxGetStatus().SettingWindowed
  if build < "03236" and fullscreen then
    maxDistance = 0
  end
  return _dxCreateShader(filepath, priority, maxDistance, bDebug)
end

local bOn = false
toggleSnowShader = function(bool)
  if bOn == bool then
    return false
  end
  bOn = bool
  if bOn then
    enableGoundSnow()
  else
    disableGoundSnow()
  end
end
