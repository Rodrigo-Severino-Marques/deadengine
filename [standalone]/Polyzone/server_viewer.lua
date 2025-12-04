-- ██████╗  ██████╗ ██╗  ██╗   ██╗███████╗ ██████╗ ███╗   ██╗███████╗    ██╗   ██╗██╗███████╗██╗    ██╗███████╗██████╗ 
-- ██╔══██╗██╔═══██╗██║  ╚██╗ ██╔╝╚══███╔╝██╔═══██╗████╗  ██║██╔════╝    ██║   ██║██║██╔════╝██║    ██║██╔════╝██╔══██╗
-- ██████╔╝██║   ██║██║   ╚████╔╝   ███╔╝ ██║   ██║██╔██╗ ██║█████╗      ██║   ██║██║█████╗  ██║ █╗ ██║█████╗  ██████╔╝
-- ██╔═══╝ ██║   ██║██║    ╚██╔╝   ███╔╝  ██║   ██║██║╚██╗██║██╔══╝      ╚██╗ ██╔╝██║██╔══╝  ██║███╗██║██╔══╝  ██╔══██╗
-- ██║     ╚██████╔╝███████╗██║   ███████╗╚██████╔╝██║ ╚████║███████╗     ╚████╔╝ ██║███████╗╚███╔███╔╝███████╗██║  ██║
-- ╚═╝      ╚═════╝ ╚══════╝╚═╝   ╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝      ╚═══╝  ╚═╝╚══════╝ ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝
--
-- PolyZone Viewer - Server Commands
-- View and copy zones from the file without accessing the server
--

-- Function: Parse zones from file
local function ParseZonesFromFile()
    local created_zones = LoadResourceFile(GetCurrentResourceName(), "polyzone_created_zones.txt")
    if not created_zones or created_zones == "" then
        return {}
    end
    
    local zones = {}
    local currentZone = nil
    local zoneContent = ""
    
    for line in created_zones:gmatch("[^\r\n]+") do
        -- Check if this is a zone header
        if line:match("^%-%- Name: (.+) | (.+)$") then
            -- Save previous zone if exists
            if currentZone then
                table.insert(zones, {
                    name = currentZone,
                    content = zoneContent
                })
            end
            
            -- Start new zone
            currentZone = line:match("^%-%- Name: (.+) |")
            zoneContent = line .. "\n"
        elseif currentZone then
            -- Add line to current zone content
            zoneContent = zoneContent .. line .. "\n"
        end
    end
    
    -- Save last zone
    if currentZone then
        table.insert(zones, {
            name = currentZone,
            content = zoneContent
        })
    end
    
    return zones
end

-- Function: Get full file content
local function GetFullFileContent()
    local created_zones = LoadResourceFile(GetCurrentResourceName(), "polyzone_created_zones.txt")
    return created_zones or ""
end

-- Command: /polyzone list
RegisterCommand('polyzone', function(source, args, rawCommand)
    local subCommand = args[1]
    
    if subCommand == 'list' then
        local zones = ParseZonesFromFile()
        
        if #zones == 0 then
            TriggerClientEvent('chat:addMessage', source, {
                color = { 255, 165, 0 },
                multiline = true,
                args = {"PolyZone", "No zones found in polyzone_created_zones.txt"}
            })
            return
        end
        
        TriggerClientEvent('chat:addMessage', source, {
            color = { 0, 255, 0 },
            multiline = true,
            args = {"PolyZone", "═══════════════════════════════"}
        })
        
        TriggerClientEvent('chat:addMessage', source, {
            color = { 0, 255, 0 },
            multiline = true,
            args = {"PolyZone", string.format("Found %d zone(s):", #zones)}
        })
        
        for i, zone in ipairs(zones) do
            TriggerClientEvent('chat:addMessage', source, {
                color = { 100, 200, 255 },
                multiline = true,
                args = {"", string.format("%d. %s", i, zone.name)}
            })
        end
        
        TriggerClientEvent('chat:addMessage', source, {
            color = { 0, 255, 0 },
            multiline = true,
            args = {"PolyZone", "═══════════════════════════════"}
        })
        
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 255, 0 },
            multiline = true,
            args = {"PolyZone", "Use: /polyzone copy [name] or /polyzone copy [number]"}
        })
        
    elseif subCommand == 'copy' then
        local identifier = args[2]
        
        if not identifier then
            TriggerClientEvent('chat:addMessage', source, {
                color = { 255, 0, 0 },
                multiline = true,
                args = {"PolyZone", "Usage: /polyzone copy [name or number]"}
            })
            return
        end
        
        local zones = ParseZonesFromFile()
        local selectedZone = nil
        
        -- Check if identifier is a number
        local zoneNumber = tonumber(identifier)
        if zoneNumber then
            selectedZone = zones[zoneNumber]
        else
            -- Search by name (case insensitive)
            local searchName = identifier:lower()
            for _, zone in ipairs(zones) do
                if zone.name:lower():find(searchName, 1, true) then
                    selectedZone = zone
                    break
                end
            end
        end
        
        if not selectedZone then
            TriggerClientEvent('chat:addMessage', source, {
                color = { 255, 0, 0 },
                multiline = true,
                args = {"PolyZone", "Zone not found: " .. identifier}
            })
            return
        end
        
        -- Send zone to client for clipboard
        TriggerClientEvent('polyzone:copyToClipboard', source, selectedZone.content, selectedZone.name)
        
    elseif subCommand == 'copyall' then
        local content = GetFullFileContent()
        
        if content == "" then
            TriggerClientEvent('chat:addMessage', source, {
                color = { 255, 165, 0 },
                multiline = true,
                args = {"PolyZone", "No zones found in polyzone_created_zones.txt"}
            })
            return
        end
        
        TriggerClientEvent('polyzone:copyToClipboard', source, content, "All Zones")
        
    elseif subCommand == 'last' then
        local zones = ParseZonesFromFile()
        
        if #zones == 0 then
            TriggerClientEvent('chat:addMessage', source, {
                color = { 255, 165, 0 },
                multiline = true,
                args = {"PolyZone", "No zones found"}
            })
            return
        end
        
        local lastZone = zones[#zones]
        TriggerClientEvent('polyzone:copyToClipboard', source, lastZone.content, lastZone.name)
        
    elseif subCommand == 'help' or not subCommand then
        TriggerClientEvent('chat:addMessage', source, {
            color = { 0, 255, 0 },
            multiline = true,
            args = {"PolyZone", "═══════════════════════════════"}
        })
        TriggerClientEvent('chat:addMessage', source, {
            color = { 100, 200, 255 },
            multiline = true,
            args = {"PolyZone", "/polyzone list - Show all zones"}
        })
        TriggerClientEvent('chat:addMessage', source, {
            color = { 100, 200, 255 },
            multiline = true,
            args = {"PolyZone", "/polyzone copy [name/number] - Copy specific zone"}
        })
        TriggerClientEvent('chat:addMessage', source, {
            color = { 100, 200, 255 },
            multiline = true,
            args = {"PolyZone", "/polyzone last - Copy last created zone"}
        })
        TriggerClientEvent('chat:addMessage', source, {
            color = { 100, 200, 255 },
            multiline = true,
            args = {"PolyZone", "/polyzone copyall - Copy entire file"}
        })
        TriggerClientEvent('chat:addMessage', source, {
            color = { 0, 255, 0 },
            multiline = true,
            args = {"PolyZone", "═══════════════════════════════"}
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0 },
            multiline = true,
            args = {"PolyZone", "Unknown command. Use /polyzone help"}
        })
    end
end, false)

-- Add command suggestions
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    print('^2[PolyZone Viewer]^7 Server commands loaded')
    print('^3[PolyZone Viewer]^7 Use /polyzone help for available commands')
end)

