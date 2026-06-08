-- rc_admin_tags - client

-- server id -> label string
local ActiveTags = {}

RegisterNetEvent('rc_admin_tags:sync', function(tags)
    ActiveTags = tags or {}
end)

-- Ask the server for the current state on load (covers resource restart & late join).
CreateThread(function()
    Wait(1000)
    TriggerServerEvent('rc_admin_tags:requestSync')
end)

local function draw3DText(pos, text)
    local camCoords = GetGameplayCamCoords()
    local dist = #(camCoords - pos)
    local scale = (Config.TextScale / dist) * 2.0
    local fov = (1.0 / GetGameplayCamFov()) * 100.0
    local scaleMul = scale * fov

    SetDrawOrigin(pos.x, pos.y, pos.z, 0)
    SetTextProportional(0)
    SetTextScale(0.0 * scaleMul, 0.55 * scaleMul)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

CreateThread(function()
    while true do
        local sleep = Config.NearCheckWait
        if next(ActiveTags) ~= nil then
            local myPed = PlayerPedId()
            local myCoords = GetEntityCoords(myPed)
            local myServerId = GetPlayerServerId(PlayerId())

            for serverId, label in pairs(ActiveTags) do
                serverId = tonumber(serverId)
                local isSelf = serverId == myServerId

                if not (isSelf and not Config.SeeOwnTag) then
                    local plyId = GetPlayerFromServerId(serverId)
                    if plyId ~= -1 then
                        local ped = GetPlayerPed(plyId)
                        if ped ~= 0 and DoesEntityExist(ped) then
                            local coords = GetEntityCoords(ped)
                            local dist = #(myCoords - coords)
                            if dist <= Config.DrawDistance then
                                sleep = 0
                                local head = vector3(coords.x, coords.y, coords.z + Config.HeightOffset)
                                draw3DText(head, label)
                            end
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)
