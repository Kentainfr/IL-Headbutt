RegisterServerEvent('RebornProject:SyncSons_Serveur')
AddEventHandler('RebornProject:SyncSons_Serveur', function()
    TriggerClientEvent('RebornProject:SyncSons_Client', -1, source)
end)

RegisterServerEvent('RebornProject:Synctete')
AddEventHandler('RebornProject:Synctete', function(netID)
    TriggerClientEvent('RebornProject:SyncAnimations', netID)
end)


-- Discord link : https://discord.gg/EDRbwTEpDu
-- Author : Kentain