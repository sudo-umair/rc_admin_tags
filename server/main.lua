-- rc_admin_tags - server

-- ESX Legacy object (safe, non-blocking export - no promise/await hang).
local ESX = exports['es_extended']:getSharedObject()

-- Currently visible tags. Keyed by server id -> label string.
local ActiveTags = {}

-- Resolve the label a player should show.
-- 1) Identifier override wins (needed for superadmins forced to group "admin").
-- 2) Otherwise fall back to their ESX group.
-- Returns the label string, or nil if the player has no staff tag.
local function resolveLabel(xPlayer)
    local identifier = xPlayer.getIdentifier()

    if Config.IdentifierOverrides[identifier] then
        return Config.IdentifierOverrides[identifier]
    end

    local group = xPlayer.getGroup()
    return Config.GroupLabels[group]
end

local function broadcast()
    TriggerClientEvent('rc_admin_tags:sync', -1, ActiveTags)
end

local function notify(source, message)
    -- resources_useSystemChat is on, so chat works everywhere without a notify dependency.
    TriggerClientEvent('chat:addMessage', source, {
        args = { 'Admin Tag', message },
        color = { 192, 147, 45 },
    })
end

RegisterCommand(Config.Command, function(source)
    if source == 0 then
        print(('[rc_admin_tags] /%s must be used in-game by a player, not from the console.'):format(Config.Command))
        return
    end

    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        print(('[rc_admin_tags] No ESX player found for source %s.'):format(source))
        return
    end

    if ActiveTags[source] then
        -- Toggle OFF
        ActiveTags[source] = nil
        notify(source, 'Tag disabled.')
    else
        -- Toggle ON
        local label = resolveLabel(xPlayer)
        print(('[rc_admin_tags] /%s by %s | identifier=%s | group=%s | resolved label=%s'):format(
            Config.Command, source, xPlayer.getIdentifier(), tostring(xPlayer.getGroup()), tostring(label)))

        if not label then
            notify(source, 'You do not have a staff tag assigned.')
            return
        end

        ActiveTags[source] = label
        notify(source, 'Tag enabled: ' .. label)
    end

    broadcast()
end, false)

-- Late join / resource restart: clients ask for the current state when they load.
RegisterNetEvent('rc_admin_tags:requestSync', function()
    local src = source
    TriggerClientEvent('rc_admin_tags:sync', src, ActiveTags)
end)

-- Clean up when a player leaves.
AddEventHandler('esx:playerDropped', function(playerId)
    if ActiveTags[playerId] then
        ActiveTags[playerId] = nil
        broadcast()
    end
end)

-- Optional: give staff their tag automatically when they load in.
if Config.AutoEnableOnJoin then
    RegisterNetEvent('esx:playerLoaded', function(playerId, xPlayer)
        local label = resolveLabel(xPlayer)
        if label then
            ActiveTags[playerId] = label
            broadcast()
        end
    end)
end

print('[rc_admin_tags] server loaded. Command: /' .. Config.Command)
