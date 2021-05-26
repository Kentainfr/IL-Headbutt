local Langue = "en"
local VolumeDeLaMusique = 0.2 --Volume of the effect

if Langue == "fr" then
    Notif3 = "~r~Aucun citoyen face a vous~s~"
    Notif3 = " ~g~Vous venez de vous prendre un coup de boule"
elseif Langue == "en" then
    Notif1 = "~r~No citizen is in front of you~s~"
    Notif2 = " ~g~You have just been heabutted~s~"
elseif Langue == "es" then
    Notif1 = "~r~Ningún ciudadano está ante ti~s~"
    Notif2 = " ~g~Acabas de recibir un cabezazo~s~"
end

function getPlayers()
    local playerList = {}
    for i = 0, 256 do
        local player = GetPlayerFromServerId(i)
        if NetworkIsPlayerActive(player) then
            table.insert(playerList, player)
        end
    end
    return playerList
end

function getNearPlayer()
    local players = getPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

RegisterNetEvent('RebornProject:SyncSons_Client')
AddEventHandler('RebornProject:SyncSons_Client', function(playerNetId)
    local lCoords = GetEntityCoords(GetPlayerPed(-1))
    local eCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerNetId)))
    local distIs  = Vdist(lCoords.x, lCoords.y, lCoords.z, eCoords.x, eCoords.y, eCoords.z)
    if (distIs <= 2.0001) then
        SendNUIMessage({
            DemarrerLaMusique     = 'DemarrerLaMusique',
            VolumeDeLaMusique   = VolumeDeLaMusique
        })
    end
end)

RegisterNetEvent('RebornProject:SyncAnimations')
AddEventHandler('RebornProject:SyncAnimations', function(playerNetId)
    Wait(250)
    TriggerServerEvent("RebornProject:SyncSons_Serveur")
    SetPedToRagdoll(GetPlayerPed(-1), 2000, 2000, 0, 0, 0, 0)
    TriggerEvent("RebornProject:Notification", Notif3)
end)

RegisterNetEvent("RebornProject:Notification")
AddEventHandler('RebornProject:Notification', function(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(true, false)
end)

function ChargementAnimation(donnees)
    while (not HasAnimDictLoaded(donnees)) do 
        RequestAnimDict(donnees)
        Wait(5)
    end
end

CreateThread(function()
    while true do
        Wait(0)
        if IsControlPressed(1, 19) and IsControlJustPressed(1, 74) then  -- alt + G
            local CitoyenCible, distance = getNearPlayer()
            if (distance ~= -1 and distance < 2.0001) then

                if IsPedArmed(GetPlayerPed(-1), 7) then
                    SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey('WEAPON_UNARMED'), true)
                end

                if (DoesEntityExist(GetPlayerPed(-1)) and not IsEntityDead(GetPlayerPed(-1))) then
                    ChargementAnimation("melee@unarmed@streamed_variations")
                    TaskPlayAnim(GetPlayerPed(-1), "melee@unarmed@streamed_variations", "plyr_takedown_front_headbutt", 8.0, 1.0, 1500, 1, 0, 0, 0, 0)
                    TriggerServerEvent("RebornProject:Synctete", GetPlayerServerId(CitoyenCible))
                end
            else
                TriggerEvent("RebornProject:Notification", Notif3)
            end
        end
    end
end)

-- Discord link : https://discord.gg/EDRbwTEpDu
-- Author : Kentain