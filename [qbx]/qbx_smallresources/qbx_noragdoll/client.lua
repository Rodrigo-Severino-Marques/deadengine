---@diagnostic disable: undefined-global

-- Re-enable ragdoll in every situation
CreateThread(function()
    while true do
        local ped = cache.ped

        SetPedCanRagdoll(ped, true)
        SetPedConfigFlag(ped, 32, true)

        Wait(0)
    end
end)

