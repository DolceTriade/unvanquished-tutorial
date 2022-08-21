-- Define module table.
local M = {}
-- Define tutorial states
local SPAWN = 1
local KILL_BOT = 2
local WALLWALK = 3

local BOT_SPAWN_PT = {-208, 1891, 15}
local PLAYER_SPAWN_PT = {204, 1913, 15}

M.state = SPAWN

local teleported = false
local egg = nil

function PlayerDie(self, inflictor, attacker, mod)
    teleported = false
end

function BotDie(self, inflictor, attacker, mod)
    SayCP(learner, '^2Way to go!')
    Cmd.exec('bot del Teacher')
    M.state = WALLWALK
    StartWallwalkTutorial()
end

function EggTouch(self, other)
    egg.buildable:decon()
    egg = nil
    SayCP(other, '^5Good job on learning the dretch basics! Feel free to try another tutorial!')
    Putteam(other, 's')
    ResetTutorial()
end

function StartWallwalkTutorial()
    egg = sgame.SpawnBuildable('eggpod', {-272, 1920, 451}, {0, 0, -180}, {1, 0, 0})
    egg.touch = EggTouch
    TutorialIntro()
end

function TutorialIntro()
    if M.state == KILL_BOT then
        SayCP(learner, '^2Kill the bot in front of you. Try to aim at his head for maximum damage.')
        Say(learner, '^2Dretches damage players, turrets, and rocket pods by touching them!')
    elseif M.state == WALLWALK then
        SayCP(learner, '^2Use wallwalk to touch the egg above!')
        Say(learner, '^2By default, it is CTRL. Please check options to learn the keybinding.')
        Say(learner, '^2Also, if you find wallwalk disorienting, try changing the wallwalk settings in the options menu.')
    end
end


M.Start = function(ent)
    M.state = SPAWN
    teleported = false
    local egg = nil
    Putteam(ent, 'a')
    SayCP(ent, '^2Let\'s learn how to use the dretch!\n^3Spawn into the dretch by clicking and selecting dretch.')
end

M.PlayerSpawn = function(ent)
    if ent.client.class == 'spectator' then
        return
    end
    if SameEnt(learner, ent) and ent.client.class ~= 'level0' then
        ent.client:kill()
        SayCP(ent, '[cross]^1I TOLD YOU TO SPAWN AS A DRETCH. NOW YOU DIE NOOB.[cross]')
        return
    end
    if M.state == SPAWN then
        if ent.client.class == 'level0' then
            SayCP(ent, '^2Good stuff, let\'s get familiar with this base alien class.')
            M.state = KILL_BOT
            ent.die = PlayerDie
            Cmd.exec('bot add "[bot]Mr. Teacher" h 5 dumb')
        end
    elseif M.state == KILL_BOT then
        if ent.bot ~= nil and ent.client.health > 0 then
            print('teleport bot')
            ent.die = BotDie
            ent.client:teleport(BOT_SPAWN_PT)
        end
    end
    if not teleported then
        learner.client:teleport(PLAYER_SPAWN_PT)
        TutorialIntro()
        teleported = true
    end
end

return M
