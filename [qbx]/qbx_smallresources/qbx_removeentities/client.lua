local config = lib.loadJson('qbx_removeentities.config')

CreateThread(function()
    while true do
        for _, obj in ipairs(config.objects) do
            local ent = GetClosestObjectOfType(obj.coords[1], obj.coords[2], obj.coords[3], 2.0, obj.hash, false, false, false)
            if DoesEntityExist(ent) then
                SetEntityAsMissionEntity(ent, true, true)
                DeleteObject(ent)
                SetEntityAsNoLongerNeeded(ent)
                SetModelAsNoLongerNeeded(obj.hash)
            end
        end

        Wait(5000)
    end
end)


Citizen.CreateThread(function()
    local id = PlayerId()
    while true do
        Citizen.Wait(1)
        DisablePlayerVehicleRewards(id)
        local ped = PlayerPedId()
        SetPedHelmet(ped, false)
        RemovePedHelmet(ped, true)        
    end
end)

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            if GetIsVehicleEngineRunning(veh) then
                SetVehicleRadioEnabled(veh, false) -- disables radio entirely
                SetVehRadioStation(veh, "OFF")     -- ensures it's off
            end
        end
        Wait(500) -- check every half second
    end
end)



Citizen.CreateThread(function()
	while true do
		Wait(1000) 
		local vehicles = GetGamePool('CVehicle')
		for _,vehicle in pairs(vehicles) do
    	    if not IsEntityVisible(vehicle) then
    	    	DeleteVehicle(vehicle)
    	    end
		end
	end
end)


-- Peaceful NPCs system - Applies to entire map with optimized performance
local processedPeds = {} -- Cache to avoid reprocessing same peds
local BATCH_SIZE = 20 -- Process 20 peds per cycle to avoid lag
local CHECK_INTERVAL = 3000 -- Check every 3 seconds

CreateThread(function()
    while true do
        local peds = GetGamePool("CPed")
        local pedCount = #peds
        
        -- Process peds in batches
        local startIndex = 1
        while startIndex <= pedCount do
            local endIndex = math.min(startIndex + BATCH_SIZE - 1, pedCount)
            
            -- Process batch
            for i = startIndex, endIndex do
                local ped = peds[i]
                if ped and DoesEntityExist(ped) and not IsPedAPlayer(ped) then
                    -- Check if we already processed this ped
                    if not processedPeds[ped] then
                        -- Disable combat and flee attributes
                        SetPedCombatAttributes(ped, 46, false) -- Can't attack
                        -- SetPedCombatAttributes(ped, 5, false)  -- Can't flee
                        -- SetPedCombatAttributes(ped, 1, false)  -- Can use cover
                        -- SetPedFleeAttributes(ped, 0, false)    -- Don't flee
                        
                        -- Mark as processed
                        processedPeds[ped] = true
                    end
                end
            end
            
            startIndex = endIndex + 1
            
            -- Small wait between batches to avoid freezing
            if startIndex <= pedCount then
                Wait(0)
            end
        end
        
        -- Clean up cache for deleted peds (prevent memory leak)
        for ped, _ in pairs(processedPeds) do
            if not DoesEntityExist(ped) then
                processedPeds[ped] = nil
            end
        end
        
        Wait(CHECK_INTERVAL)
    end
end)