-- Define module table.
local M = {}
-- Define tutorial states
local SPAWN = 1
local KILL_BOT = 2
local KILL_TURRET = 3
M.state = SPAWN

M.Start = function(ent)
    Putteam(ent, 'a')
    SayCP(ent, '^2Let\'s learn how to use the dretch!\n^3Spawn into the dretch by clicking and selecting dretch.')
end

M.PlayerSpawn = function(ent)
    if M.state == SPAWN then
        if ent.client.class ~= 'level0' and ent.client.class ~= 'spectator' then
            ent.client:kill()
            SayCP(ent, '[cross]^1I TOLD YOU TO SPAWN AS A DRETCH. NOW YOU DIE NOOB.[cross]')
        end
        if ent.client.class == 'level0' then
            SayCP(ent, '^2Good stuff, let\'s get familiar with this base alien class.')
            M.state = KILL_BOT
        end
    end
end

return M
