-----------------------------------------------------------------------------
-- Framework bridge — uniform player API over ESX and QBCore
--
-- Exposes (server-side global):
--   Bridge.Framework          -> 'esx' | 'qb' | 'none'
--   Bridge.GetGroups(src)     -> array of group/permission names ({} if none)
--   Bridge.OnPlayerLoaded(cb) -> cb(playerId) when a character finishes loading
-----------------------------------------------------------------------------

Bridge = {
    Framework = 'none',
}

local ESX, QBCore

local function tryDetectFramework()
    local wantEsx = Config.Framework == 'esx' or Config.Framework == 'auto'
    local wantQb  = Config.Framework == 'qb' or Config.Framework == 'auto'

    if wantEsx and GetResourceState('es_extended') == 'started' then
        ESX = exports['es_extended']:getSharedObject()
        Bridge.Framework = 'esx'
        return true
    end

    if wantQb and GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
        Bridge.Framework = 'qb'
        return true
    end

    return false
end

-- the framework may start after rc_admin_tags — keep retrying for a while
CreateThread(function()
    for _ = 1, 60 do
        if tryDetectFramework() then
            print(('[rc_admin_tags] framework: %s'):format(Bridge.Framework))
            return
        end
        Wait(1000)
    end
    print('[rc_admin_tags] WARNING: no framework detected — only identifier overrides will resolve tags')
end)

-----------------------------------------------------------------------------

-- ESX players have exactly one group; QBCore players can hold several
-- permission levels, so this always returns a list.
function Bridge.GetGroups(src)
    if Bridge.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            return { xPlayer.getGroup() }
        end
    elseif Bridge.Framework == 'qb' then
        local perms = QBCore.Functions.GetPermission(src)
        if type(perms) == 'string' then           -- older qb-core returns one name
            return { perms }
        elseif type(perms) == 'table' then        -- newer qb-core returns { [name] = true }
            local out = {}
            for name, has in pairs(perms) do
                if has then out[#out + 1] = name end
            end
            return out
        end
    end
    return {}
end

-- Both frameworks trigger their loaded event server-side, so plain
-- AddEventHandler is enough (and clients can't spoof it).
function Bridge.OnPlayerLoaded(cb)
    AddEventHandler('esx:playerLoaded', function(playerId)
        cb(playerId)
    end)
    AddEventHandler('QBCore:Server:PlayerLoaded', function(player)
        cb(player.PlayerData.source)
    end)
end
