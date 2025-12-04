RegisterNetEvent("qbx_carry:sync", function(targetSrc)
    TriggerClientEvent("qbx_carry:syncTarget", targetSrc, source)
end)

RegisterNetEvent("qbx_carry:stop", function(targetSrc)
    TriggerClientEvent("qbx_carry:cl_stop", targetSrc)
end)
