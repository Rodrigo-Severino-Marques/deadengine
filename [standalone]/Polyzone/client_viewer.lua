-- ██████╗  ██████╗ ██╗  ██╗   ██╗███████╗ ██████╗ ███╗   ██╗███████╗    ██╗   ██╗██╗███████╗██╗    ██╗███████╗██████╗ 
-- ██╔══██╗██╔═══██╗██║  ╚██╗ ██╔╝╚══███╔╝██╔═══██╗████╗  ██║██╔════╝    ██║   ██║██║██╔════╝██║    ██║██╔════╝██╔══██╗
-- ██████╔╝██║   ██║██║   ╚████╔╝   ███╔╝ ██║   ██║██╔██╗ ██║█████╗      ██║   ██║██║█████╗  ██║ █╗ ██║█████╗  ██████╔╝
-- ██╔═══╝ ██║   ██║██║    ╚██╔╝   ███╔╝  ██║   ██║██║╚██╗██║██╔══╝      ╚██╗ ██╔╝██║██╔══╝  ██║███╗██║██╔══╝  ██╔══██╗
-- ██║     ╚██████╔╝███████╗██║   ███████╗╚██████╔╝██║ ╚████║███████╗     ╚████╔╝ ██║███████╗╚███╔███╔╝███████╗██║  ██║
-- ╚═╝      ╚═════╝ ╚══════╝╚═╝   ╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝      ╚═══╝  ╚═╝╚══════╝ ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝
--
-- PolyZone Viewer - Client Commands
-- Copy zones to clipboard
--

-- Function: Copy text to clipboard (using SendNUIMessage)
local function CopyToClipboard(text)
    SendNUIMessage({
        type = "copyToClipboard",
        text = text
    })
end

-- Event: Copy zone to clipboard
RegisterNetEvent('polyzone:copyToClipboard', function(content, zoneName)
    -- Copy to clipboard
    CopyToClipboard(content)
    
    -- Notify player
    TriggerEvent('chat:addMessage', {
        color = { 0, 255, 0 },
        multiline = true,
        args = {"PolyZone", "✓ Copied '" .. zoneName .. "' to clipboard!"}
    })
    
    -- Also show in console for backup
    print("^2═══════════════════════════════════════^0")
    print("^3[PolyZone Copied]^0 " .. zoneName)
    print("^2═══════════════════════════════════════^0")
    print(content)
    print("^2═══════════════════════════════════════^0")
end)

-- Create NUI page for clipboard functionality
CreateThread(function()
    Wait(100)
    SetNuiFocus(false, false)
end)

