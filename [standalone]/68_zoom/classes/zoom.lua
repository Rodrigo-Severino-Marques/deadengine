
---@class zoom_68 : OxClass
---@field zoomed boolean
---@field active boolean
---@field cam number
---@field fov number
---@field block boolean
local zoom = lib.class('zoom_68')

-- -------------------------------------------------------------------------- --
--                                  Functions                                 --
-- -------------------------------------------------------------------------- --

function zoom:constructor()
    self.zoomed = false
    self.active = false
    self.cam = nil
    self.fov = 20.0
    self.block = false
end

return zoom:new()