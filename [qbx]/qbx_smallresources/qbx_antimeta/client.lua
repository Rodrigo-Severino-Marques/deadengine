---@diagnostic disable: undefined-global

local config = lib.loadJson('qbx_antimeta.config')

if not config.enableAntiMeta then return end

CreateThread(function()
    local resetcounter = 0
    local jumpDisabled = true
    
    while true do 
        Wait(1)
        local ped = cache.ped
        if cache.vehicle then
            Wait(250)
            goto continue
        end
        
        if jumpDisabled and resetcounter > 0 and IsPedJumping(ped) then	
            SetPedToRagdoll(ped, config.ragdollTime, config.ragdollTimeVariation, config.ragdollType, false, false, false)
            resetcounter = 0
        end
        
        if not jumpDisabled and IsPedJumping(ped) then
            if math.random(2) == 2 then
                jumpDisabled = true
            end
            resetcounter = 1000
            Wait(config.cooldownTime)
        end

        ::continue::
        
        if resetcounter > 0 then
            resetcounter = resetcounter - 1
        else
            if jumpDisabled then
                resetcounter = 0
                jumpDisabled = false
            end
        end
    end
end)
