-- Copyright (c) Jérémie N'gadi
--
-- All rights reserved.
--
-- Even if 'All rights reserved' is very clear :
--
--   You shall not use any piece of this software in a commercial product / service
--   You shall not resell this software
--   You shall not provide any facility to install this particular software in a commercial product / service
--   If you redistribute this software, you must link to ORIGINAL repository at https://github.com/ESX-Org/es_extended
--   This copyright should appear in every part of the project code

local utils = M('utils')

module.DyingActive, module.LowActive, module.StressActive, module.DrunkActive = false, false, false, false
module.WeedActive, module.CocaineActive, module.MethActive, module.HeroinActive = false, false, false, false
module.Ready, module.Frame, module.isPaused, module.Sick, module.CurrentAnimSet, module.StatusEffectActive, module.CurrentStrength = false, nil, false, false, nil, false, 0

module.UpdateStatus = function(statuses)
  if statuses then
    local Statuses = {}
    local existingStatuses = {}

    for k,v in pairs(Config.Modules.Status.StatusIndex) do
      if k then
        if v then
          if not existingStatuses[v] then
            existingStatuses[v] = v
            if statuses[v]["fadeType"] == "desc" then
              if statuses[v]["value"] < 50 or statuses[v]["value"] == 75 or statuses[v]["value"] == 100 then
                table.insert(Statuses, statuses[v])
              end
            elseif statuses[v]["fadeType"] == "asc" then
              if statuses[v]["value"] > 0 then
                table.insert(Statuses, statuses[v])
              end
            end
          end
        end
      end
    end

    module.Frame:postMessage({
      app = "STATUS",
      method = "setStatus",
      data = Statuses
    })
  end
end

module.Frame = Frame('status', 'nui://' .. __RESOURCE__ .. '/modules/__core__/status/data/html/index.html', true)

module.Frame:on('load', function()
  module.Ready = true
  emit('status:ready')
end)

module.StatCheck = function(low, dying, drunk, drugName, drugs, stress)
  if Config.Modules.Status.UseEffects then
    if dying then
      module.Dying()
    elseif low then
      module.Low()
    elseif drunk == 0 and drugs == 0 and stress == 0 then
      module.ClearStatus()
    else
      if (stress > 0 and stress == drunk) or (stress > 0 and stress == drugs) or (stress > 0 and stress > drugs and stress > drunk) then
        module.StatusEffectActive = true
        module.Stress(stress)
      elseif (drunk > 0 and drunk == drugs) or (drunk > 0 and drunk > drugs and drunk > stress) then
        print("drunk")
        module.Drunk(drunk)
      elseif drugs > 0 and drugs > stress and drugs > drunk then
        module.StatusEffectActive = true
        module.Drugs(drugName, drugs)
      end
    end
  else
    if dying then
      ApplyDamageToPed(PlayerPedId(), 10, false)
    end
  end
end

--------------------------------------------------------------
--                    Status Effects                        --
--------------------------------------------------------------

module.Dying = function()
  if module.IsAnyOtherStatusActive("dying") then
    module.LowActive     = false
    module.WeedActive    = false
    module.CocaineActive = false
    module.MethActive    = false
    module.HeroinActive  = false
    module.StressActive  = false
  end

  if not module.DyingActive then
    module.StatusEffectActive = true
    module.DyingActive = true
    SetPedMoveRateOverride(PlayerPedId(),0.8)
    SetRunSprintMultiplierForPlayer(PlayerPedId(),0.8)
    utils.game.LoopModifier("REDMIST_blend", 16, 0.02, 0.0, 1.0)

    RequestAnimSet("MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP")

    while not HasAnimSetLoaded("MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP") do
      Wait(10)
    end

    SetPedMovementClipset(PlayerPedId(), "MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP", true)
  else
    if math.random(0,100) > 90 then
      module.Trip()
    end
  end

  ApplyDamageToPed(PlayerPedId(), 10, false)
end

module.Low = function()
  if module.IsAnyOtherStatusActive("low") then
    if module.DyingActive then
      RemoveAnimSet("MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP")
    end
    module.DyingActive   = false
    module.WeedActive    = false
    module.CocaineActive = false
    module.MethActive    = false
    module.HeroinActive  = false
    module.StressActive  = false
  end

  if not module.LowActive then
    module.StatusEffectActive = true
    module.LowActive = true
    utils.game.LoopModifier("BlackOut", 100, 0.02, 0.0, 0.5)
  else
    if math.random(0,100) > 80 then
      utils.game.DoAnimation("anim@mp_player_intupperface_palm","idle_a",4000,49)
    end
  end
end

module.ClearStatus = function()
  if module.StatusEffectActive then
    module.StatusEffectActive = false

    if module.DyingActive then
      module.DyingActive = false
      ResetPedMovementClipset(PlayerPedId())
      RemoveAnimSet("MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP")
      SetPedMoveRateOverride(PlayerPedId(),1.0)
      SetRunSprintMultiplierForPlayer(PlayerPedId(),1.0)
      utils.game.BreakLoopModifier()
    elseif module.LowActive then
      module.LowActive = false
      utils.game.BreakLoopModifier()
    elseif module.StressActive or module.DrunkActive or module.DrugsActive then
      module.Init()
    end
  end
end

module.Stress = function(value)

end

module.Drunk = function(drunk)
  module.StatusEffectActive = true
  local modifier = nil
  local clipset  = nil
  local speed    = nil
  local amount   = nil
  local max      = nil

  print("made it here 1")

  if not module.DrunkActive then
    SetPedConfigFlag(PlayerPedId(), 100, true)
    SetPedIsDrunk(PlayerPedId(), true)
    module.DrunkActive = true
  end

  print("made it here 2")

  if drunk <= 9 then
    if module.CurrentModifier then
      utils.game.FadeOutModifier(100, 0.0025)
      module.CurrentModifier = nil
      module.CurrentStrength = 0
    end

    SetPedConfigFlag(PlayerPedId(), 100, false)
    SetPedIsDrunk(PlayerPedId(), false)
    module.DrunkActive = false
    if module.CurrentAnimSet then
      RemoveAnimSet(module.CurrentAnimSet)
      module.CurrentAnimSet = nil
    end
    ResetPedMovementClipset(PlayerPedId())
  elseif drunk >= 10 and drunk <= 24 then
    modifier = "Drunk"
    clipset  = "MOVE_M@BUZZED"
    speed    = 50
    amount   = 0.0025
    max      = 0.2
    fall     = 0
    sick     = 0
  elseif drunk >= 25 and drunk <= 49 then
    modifier = "Drunk"
    clipset  = "MOVE_M@DRUNK@SLIGHTLYDRUNK"
    speed    = 50
    amount   = 0.0025
    max      = 0.3
    fall     = 0
    sick     = 0
  elseif drunk >= 50 and drunk <= 75 then
    modifier = "Drunk"
    clipset  = "MOVE_M@DRUNK@A"
    speed    = 50
    amount   = 0.0025
    max      = 0.5
    fall     = math.random(10,100)
    sick     = math.random(10,100)
  elseif drunk >= 76 and drunk <= 89 then
    modifier = "Drunk"
    clipset  = "MOVE_M@DRUNK@VERYDRUNK"
    speed    = 50
    amount   = 0.0025
    max      = 0.75
    fall     = math.random(20,100)
    sick     = math.random(20,100)
  elseif drunk >= 90 and drunk <= 100 then
    modifier = "Drunk"
    clipset  = "MOVE_M@DRUNK@VERYDRUNK"
    speed    = 50
    amount   = 0.0025
    max      = 1.0
    fall     = math.random(25,100)
    sick     = math.random(35,100)
  end

  print("made it here 3")

  if max then
    print(max .. " | " .. module.CurrentStrength)
  end

  if modifier and module.CurrentStrength ~= max then
    module.CurrentStrength = max
    print("Triggering. Was it finished?")
    module.IsDrunk(modifier, speed, amount, max)
  end

  print("made it here 4")

  if clipset then
    if module.CurrentAnimSet ~= clipset then
      RemoveAnimSet(module.CurrentAnimSet)
      module.CurrentAnimSet = clipset
      RequestAnimSet(module.CurrentAnimSet)
    end

    while not HasAnimSetLoaded(module.CurrentAnimSet) do
      Wait(10)
    end
    
    SetPedMovementClipset(PlayerPedId(), module.CurrentAnimSet, true)
  end

  print("made it here 5")

  if drunk > 25 and sick > 55 then
    if IsPedInAnyVehicle(PlayerPedId(), false) then
      local veh = GetVehiclePedIsIn(PlayerPedId())

      if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
        module.DrunkDriving(veh)
      end
    else
      if fall > 0 or sick > 0 then
        module.DrunkEffects(fall, sick)
      end
    end
  end

  print("made it here 6")
end

module.Weed = function(value)

end

module.Cocaine = function(value)

end

module.Meth = function(value)

end

module.Heroin = function(value)

end

--------------------------------------------------------------
--                     Other Functions                      --
--------------------------------------------------------------

module.IsDrunk = function(modifier, speed, amount, max)
  module.CurrentModifier = modifier
  utils.game.FadeInModifier(modifier, speed, amount, max)
end

module.DrunkEffects = function(fallChance,sickChance)
  if sickChance >= 80 then
    module.Sick = true
    utils.game.DoAnimation("oddjobs@taxi@tie","vomit_outside",8000,49)
    ApplyDamageToPed(PlayerPedId(), 1, false)
  else
    module.Sick = false
  end

  local fallTime = 2 * 1000 -- 2 seconds

  if fallChance >= 75 and not module.Sick then
    if not IsPedInVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId()), false) then
      SetPedToRagdoll(PlayerPedId(), fallTime, fallTime, 0, 0, 0, 0)
      DisableAllControlActions(0)
      ApplyDamageToPed(PlayerPedId(), 1, false)
      Wait(fallTime)
      EnableAllControlActions(0)
    end
  end

  module.IsMoving = true
end

module.Drugs = function(name, value)
  if name == "weed" then
    module.Weed(value)
  elseif name == "cocaine" then
    module.Cocaine(value)
  elseif name == "meth" then
    module.Meth(value)
  elseif name == "heroin" then
    module.Heroin(value)
  end
end

module.DrunkDriving = function(veh)
  local generateRandomDrunkDrivingEvent = math.random(1, #Config.Modules.Status.RandomEvents)
  local randomDrunkEvent                = Config.Modules.Status.RandomEvents[generateRandomDrunkDrivingEvent]

  TaskVehicleTempAction(PlayerPedId(), veh, randomDrunkEvent.action, randomDrunkEvent.duration)
end

module.Trip = function()
  local shakeIntensity = math.random(1,10) * 0.1
  ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", shakeIntensity)
  SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
  DisableAllControlActions(0)
  ApplyDamageToPed(PlayerPedId(), 1, false)
  Wait(1000)
  EnableAllControlActions(0)
end

module.Init = function()
  RemoveAnimSet(module.CurrentAnimSet)
  module.CurrentAnimSet = nil
  module.DyingActive    = false
  module.LowActive      = false
  module.StressActive   = false
  module.DrunkActive    = false
  module.WeedActive     = false
  module.CocaineActive  = false
  module.MethActive     = false
  module.HeroinActive   = false
  module.DrunkActive    = false
  utils.game.ClearModifiers()
  ResetPedMovementClipset(PlayerPedId())
end

module.IsAnyOtherStatusActive = function(value)
  if value == "dying" then
    if module.LowActive or module.DrunkActive or module.WeedActive or module.CocaineActive or module.MethActive or module.HeroinActive or module.StressActive then
      return true
    else
      return false
    end
  elseif value == "low" then
    if module.DyingActive or module.DrunkActive or module.WeedActive or module.CocaineActive or module.MethActive or module.HeroinActive or module.StressActive then
      return true
    else
      return false
    end
  elseif value == "drunk" then
    if module.DyingActive or module.LowActive or module.WeedActive or module.CocaineActive or module.MethActive or module.HeroinActive or module.StressActive then
      return true
    else
      return false
    end
  elseif value == "weed" then
    if module.DyingActive or module.LowActive or module.DrunkActive or module.CocaineActive or module.MethActive or module.HeroinActive or module.StressActive then
      return true
    else
      return false
    end
  elseif value == "cocaine" then
    if module.DyingActive or module.LowActive or module.DrunkActive or module.WeedActive or module.MethActive or module.HeroinActive or module.StressActive then
      return true
    else
      return false
    end
  elseif value == "meth" then
    if module.DyingActive or module.LowActive or module.DrunkActive or module.WeedActive or module.CocaineActive or module.HeroinActive or module.StressActive then
      return true
    else
      return false
    end
  elseif value == "heroin" then
    if module.DyingActive or module.LowActive or module.DrunkActive or module.WeedActive or module.CocaineActive or module.MethActive or module.StressActive then
      return true
    else
      return false
    end
  elseif value == "stress" then
    if module.DyingActive or module.LowActive or module.DrunkActive or module.WeedActive or module.CocaineActive or module.MethActive or module.HeroinActive then
      return true
    else
      return false
    end
  else
    return false
  end
end