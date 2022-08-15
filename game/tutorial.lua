-- Globals
dretch = require('tutorials/dretch.lua')
tutorials = {
    dretch,
}
learner = nil
tutorial = nil

function Say(ent, txt)
    local num = -1
    if ent ~= nil then
        num = ent.number
    end
    sgame.SendServerCommand(num, 'print ' .. '"^2TUTORIAL^*:' .. txt .. '"')
end

function CP(ent, txt)
    local num = -1
    if ent ~= nil then
        num = ent.number
    end
    sgame.SendServerCommand(num, 'cp ' .. '"' .. txt .. '"')
end

function SayCP(ent, txt)
    CP(ent, txt)
    Say(ent, txt)
end

function Putteam(ent, team)
    if ent == nil or ent.client == nil then
        return
    end
    Cmd.exec('delay 1f putteam ' .. ent.number .. ' ' .. team)
end

function LockTeams(lock)
    local cmd = lock and 'lock' or 'unlock'
    Cmd.exec(cmd .. ' a;' .. cmd .. ' h')
end

function SameEnt(a, b)
    if a == nil or b == nil then
        return false
    end
    return a.number == b.number
end

function WelcomeClient(ent, connect)
    if not connect then
        return
    end
    txt = 'Welcome to the Unvanquished tutorial!'
    if learner ~= nil then
        txt = txt .. ' Wait for ' .. learner.client.name .. '^* to finish.'
    else
        txt = txt .. ' Here we\'ll teach you how to play the game! Join a team to get started!'
    end
    CP(ent, txt)
end

function ResetTutorial()
    learner = nil
    tutorial = nil
    LockTeams(false)
end

function StartTutorial(ent)
    learner = ent
    LockTeams(true)
    CP(ent, "Get ready to learn!")
    tutorial = tutorials[1]
    tutorial.Start(learner)
end

function HandleTeamChange(ent, team)
    if SameEnt(ent, learner) and tutorial ~= nil then
        if tutorial.TeamChange then
            tutorial.TeamChange(ent, team)
        end
        return
    end
    if learner ~= nil and not SameEnt(ent, learner) then
        Putteam(ent, 's')
        CP(ent, '[cross]^1GTFO. Wait for your turn.[cross]')
    end

    if team == "spectator" then
        if ent == learner then
            ResetTutorial()
        end
        return
    end

    StartTutorial(ent)
end

function HandlePlayerSpawn(ent)
    if tutorial ~= nil and tutorial.PlayerSpawn ~= nil then
        tutorial.PlayerSpawn(ent)
    end
end

function HandleChat(ent, team, message)
end

function init()
    sgame.hooks.RegisterClientConnectHook(WelcomeClient)
    sgame.hooks.RegisterTeamChangeHook(HandleTeamChange)
    sgame.hooks.RegisterChatHook(HandleTeamChange)
    sgame.hooks.RegisterPlayerSpawnHook(HandlePlayerSpawn)
    print('Loaded lua...')
end

init()
