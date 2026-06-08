-- rc_admin_tags - server

-- ESX Legacy object (safe, non-blocking export - no promise/await hang).
local ESX = exports['es_extended']:getSharedObject()

-- Currently visible tags. Keyed by server id -> label string.
local ActiveTags = {}

-- Resolve the label a player should show.
-- 1) Identifier override wins (needed for superadmins forced to group "admin").
--    Checked against ALL of the player's identifiers (license, license2,
--    discord, fivem, steam, ...) so it doesn't matter which one ESX reports.
-- 2) Otherwise fall back to their ESX group.
-- Returns the label string, or nil if the player has no staff tag.
local function resolveLabel(source, xPlayer)
    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if Config.IdentifierOverrides[id] then
            return Config.IdentifierOverrides[id]
        end
    end

    local group = xPlayer.getGroup()
    return Config.GroupLabels[group]
end

-- Strip GTA text color codes (e.g. ~y~, ~r~) for display in chat.
local function stripColors(text)
    return (text:gsub('~[^~]*~', ''))
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
        local label = resolveLabel(source, xPlayer)
        print(('[rc_admin_tags] /%s by %s | group=%s | resolved label=%s'):format(
            Config.Command, source, tostring(xPlayer.getGroup()), tostring(label)))
        print('[rc_admin_tags] all identifiers for this player:')
        for _, id in ipairs(GetPlayerIdentifiers(source)) do
            print('[rc_admin_tags]   ' .. id)
        end

        if not label then
            notify(source, 'You do not have a staff tag assigned.')
            return
        end

        ActiveTags[source] = label
        notify(source, 'Tag enabled: ' .. stripColors(label))
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
        local label = resolveLabel(playerId, xPlayer)
        if label then
            ActiveTags[playerId] = label
            broadcast()
        end
    end)
end

print('[rc_admin_tags] server loaded. Command: /' .. Config.Command)
