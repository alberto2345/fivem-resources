local dimensions = {}

AddEventHandler("chatMessage", function(player, playerName, msg)
	if (msg == "") then
		CancelEvent()
	end

	if msg:sub(1, 1) == "/" then
		fullcmd = stringSplit(msg, " ")
    	cmd = fullcmd[1]
		CancelEvent()

		if cmd == "/setdim" then
			if (fullcmd[2]) then
				setPlayerDimension(player, tonumber(fullcmd[2]))
			else
				TriggerClientEvent("chat:addMessage", player, {args={"No second argument for dimension or second argument wasnt a number."}})
			end
			CancelEvent()
		elseif (cmd == "/getdim") then
			local dim = getPlayerDimension(player)

			TriggerClientEvent("chat:addMessage", player, {args={"Dim = " .. tostring(dim)}})
		elseif (cmd == "/dt") then
			TriggerClientEvent("chat:addMessage", player, {args={"---------- Num. in table: " .. tostring(tablelength(dimensions))}})
			for a,b in pairs(dimensions) do
				TriggerClientEvent("chat:addMessage", player, {args={"plr_id: " .. tostring(a) .. ", curr_dim: " .. tostring(b["currentDimension"]) .. ", prev_dim: " .. tostring(b["previousDimension"])}})
			end
		elseif (cmd == "/testhide") then
			TriggerClientEvent("testhide", player)
		elseif (cmd == "/getint") then
			TriggerClientEvent("getInt", player)
		end
	end
end)

AddEventHandler("onResourceStart", function(resource)
	if (resource == "dimensions") then
		local players = GetPlayers()

		--[[for a,b in pairs(players) do
			dimensions[b] = {}
			dimensions[b]["previousDimension"] = 0
			dimensions[b]["currentDimension"] = 0
		end]]

		for c,d in pairs(players) do
			setPlayerDimension(tonumber(d), 0)
		end
	end
end)

RegisterServerEvent("onPlayerSpawned")
AddEventHandler("onPlayerSpawned", function(plr)
	print("[dims] Plr Connecting: " .. tostring(plr))
	setPlayerDimension(plr, 0)
end)

AddEventHandler("playerDropped", function()
	print("[dims] Plr dropped: " .. tostring(source))
	dimensions[source] = nil
	print("[dims] Plr " .. tostring(source) .. " removed from table")
end)

function setPlayerDimension(player, dimension)
	if (type(dimensions[player]) == "table") then
		--TriggerClientEvent("chat:addMessage", player, {args={"Dimensions table has record of player, setting dimension (" .. tostring(player) .. ", " .. tostring(dimensions[player]) .. ")"}})
		dimensions[player]["previousDimension"] = dimensions[player]["currentDimension"] or 0
		dimensions[player]["currentDimension"] = dimension
	else
		--TriggerClientEvent("chat:addMessage", player, {args={"No record of player in dimensions table, creating entry and setting dimension (" .. tostring(player) .. ", " .. tostring(dimensions[player]) .. ")"}})
		dimensions[player] = {}
		dimensions[player]["previousDimension"] = 0
		dimensions[player]["currentDimension"] = dimension
	end

	--TriggerClientEvent("chat:addMessage", player, {args={"Triggering sendPlayerToDimension..."}})
	print("Set player " .. tostring(player) .. " to dim " .. tostring(dimension))
	TriggerClientEvent("sendPlayerToDimension", player, dimension, dimensions, true)
end
RegisterServerEvent("dimensions:setPlayerDimension")
AddEventHandler("dimensions:setPlayerDimension", setPlayerDimension)

RegisterServerEvent("dimensions:forceDimensionUpdate")
AddEventHandler("dimensions:forceDimensionUpdate", 
	function()
		for _,id in pairs(GetPlayers()) do
			print("Updating players: " .. tostring(id) .. ", " .. tostring(dimensions[tonumber(id)]["currentDimension"]))
			TriggerClientEvent("sendPlayerToDimension", id, dimensions[tonumber(id)]["currentDimension"], dimensions, false)
		end
	end
)

function getPlayerDimension(player)
	if (dimensions[player] ~= nil) then
		return dimensions[player]["currentDimension"]
	else
		dimensions[player] = {}
		dimensions[player]["currentDimension"] = 0
		return 0
	end
end
RegisterServerEvent("dimensions:getPlayerDimension")
AddEventHandler("dimensions:getPlayerDimension", getPlayerDimension)

function stringSplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end