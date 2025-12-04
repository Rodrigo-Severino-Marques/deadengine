RegisterNetEvent('qbx_elastico:client:useScrunchie', function()
    local ped = cache.ped
    local currentHair = GetPedDrawableVariation(ped, 2)
    local currentHairTexture = GetPedTextureVariation(ped, 2)
    
    -- Toggle between hair styles (this is a simple example - you can customize this)
    if currentHair == 0 then
        -- Change to ponytail style (example)
        SetPedComponentVariation(ped, 2, 7, 0, 0) -- Hair component, style 7, texture 0
        TriggerEvent('mqs-notify:sendNotify', 'success', 'Cabelo preso com elástico!', 3000)
    else
        -- Change back to original style
        SetPedComponentVariation(ped, 2, 0, 0, 0) -- Hair component, style 0, texture 0
        TriggerEvent('mqs-notify:sendNotify', 'success', 'Elástico removido!', 3000)
    end
end)
