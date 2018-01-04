--[[local entities = {}

local mainDimension = 0

function setEntityDimension(entity, dimension)
    entities[entity] = dimension

    for a,b in pairs(entities) do
        if (b == dimension) then
            SetEntityNoCollisionEntity()
        end
    end
end]]

--[[function getEntityDimension(entity)

end]]


local firingDisabled = false

--[[RegisterNetEvent("createEntity")
AddEventHandler("createEntity", function()
    Citizen.CreateThread(function()
        local modelHash = GetHashKey("mp_m_freemode_01")

        while (not HasModelLoaded(modelHash)) do
            RequestModel(modelHash)

            Citizen.Wait(0)
        end
        local pos = GetEntityCoords(GetPlayerPed(-1))

        local ped = CreatePed(4, modelHash, pos.x, pos.y, pos.z, 0, true, true)
        pedReference = ped
        SetEntityNoCollisionEntity(ped, GetPlayerPed(-1), false)
        SetEntityAlpha(ped, 0)
        firingDisabled = true

        while firingDisabled do
            DisablePlayerFiring(-1, true)
            Citizen.Wait(0)
        end
    end)
end)]]

RegisterNetEvent("getInt")
AddEventHandler("getInt", function()
    local int = GetInteriorFromEntity(GetPlayerPed(PlayerId()))

    TriggerEvent("chat:addMessage", {args={"Int: " .. tostring(int)}})
end)

--[[Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for i = 0, 33 do
            if DoesEntityExist(GetPlayerPed(i)) and tonumber(PlayerId()) ~= i then
                playerID = i
            end

            if tonumber(playerID) ~= tonumber(PlayerId()) then 
                if GetInteriorFromEntity(GetPlayerPed(playerID)) == 166657 then
                    SetPlayerInvisibleLocally(playerID,  true)
                    --SetPlayerInvisibleLocally(PlayerId(),  false)
                    SetEntityNoCollisionEntity(GetPlayerPed(-1), GetPlayerPed(playerID), true)
                end
            end
            if not GetInteriorFromEntity(GetPlayerPed(playerID)) == 166657 then      
                SetPlayerInvisibleLocally(playerID,  false)
                --SetPlayerInvisibleLocally(PlayerId(),  false)
                SetEntityNoCollisionEntity(GetPlayerPed(-1), GetPlayerPed(playerID), false)
            end
        end
    end
end)]]

AddEventHandler("playerSpawned", function()
   -- Citizen.CreateThread(
        --function()
            --Citizen.Wait(5000)
            TriggerServerEvent("onPlayerSpawned", GetPlayerServerId(PlayerId()))
        --end
    --)
end)

RegisterNetEvent("testhide")
AddEventHandler("testhide", function()
    TriggerEvent("chat:addMessage", {args={"Triggering thread...."}})
    Citizen.CreateThread(function()
        SetPlayerInvisibleLocally(12, true)
        SetLocalPlayerInvisibleLocally(0)
        
    end)

    TriggerEvent("chat:addMessage", {args={"event triggered!"}})
end)

RegisterNetEvent("sendPlayerToDimension")
AddEventHandler("sendPlayerToDimension", function(dimension, playerDimensions, singlePlayer)

   -- TriggerEvent("chat:addMessage", {args={"Trigger received 1, doing loop."}})

    Citizen.CreateThread(function()

        local clientPed = GetPlayerPed(PlayerId())

        --TriggerEvent("chat:addMessage", {args={"Trigger received 2, doing loop. " .. GetPlayerServerId(PlayerId())}})

        for a,b in pairs(playerDimensions) do

            if (tonumber(a) == tonumber(GetPlayerServerId(PlayerId()))) then
                TriggerEvent("chat:addMessage", {args={"me (" .. tostring(a) .. ", " .. tostring(GetPlayerServerId(PlayerId())) .. ")"}})
            end

            if (tonumber(a) ~= tonumber(GetPlayerServerId(PlayerId()))) then
                TriggerEvent("chat:addMessage", {args={"not me (" .. tostring(a) .. ", " .. tostring(GetPlayerServerId(PlayerId())) .. ")"}})
                
                if (tonumber(dimension) ~= tonumber(b["currentDimension"])) then
                    TriggerEvent("chat:addMessage", {args={"other plr not same dim (" .. tostring(a) .. ", " .. tostring(b["currentDimension"]) .. ")"}})
                    local playerPed = GetPlayerPed(GetPlayerFromServerId(a))

                    SetEntityNoCollisionEntity(clientPed, playerPed, false)
                    SetEntityAlpha(playerPed, 0)
                    --SetPlayerInvisibleLocally(GetPlayerFromServerId(a), 1)

                    if (dimension > 0) then
                        firingDisabled = true
                    else
                        firingDisabled = false
                    end
                
                else
                    TriggerEvent("chat:addMessage", {args={"other plr same dim (" .. tostring(a) .. ", " .. tostring(b["currentDimension"]) .. ")"}})
                    local playerPed = GetPlayerPed(GetPlayerFromServerId(a))

                    SetEntityNoCollisionEntity(clientPed, playerPed, true)
                    SetEntityAlpha(playerPed, 255)    

                    if (dimension > 0) then
                        firingDisabled = true
                    else
                        firingDisabled = false
                    end
                end
            end

            if (singlePlayer == true) then
                TriggerServerEvent("dimensions:forceDimensionUpdate")
            end
        end

        while firingDisabled do
            DisablePlayerFiring(-1, true)
            Citizen.Wait(0)
        end
    end)
end)

--[[RegisterNetEvent("setCollision")
AddEventHandler("setCollision", function()
    Citizen.CreateThread(function()
        SetEntityNoCollisionEntity(pedReference, GetPlayerPed(-1), true)
        SetEntityAlpha(pedReference, 255)
        firingDisabled = false
    end)
end)]]