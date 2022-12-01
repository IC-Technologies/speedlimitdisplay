local showlimit = true

--Trigger this event in another script to toggle seeing the text on the screen or not.
RegisterNetEvent("ToggleSpeedLimit")
AddEventHandler("ToggleSpeedLimit", function(toggle)
	showlimit = toggle
end)

--Handles client interaction with the world (draws text to screen when inside a car and on a road)
Citizen.CreateThread(function()
    while true do
        Wait(0)
    	if IsPedInAnyVehicle(PlayerPedId()) and (not exports.Badssentials:IsDisplaysHidden()) then
			if showlimit == true then
				local display = Config.DisplaySettings.text
				display = display:gsub("{LIMIT}", GetSpeedLimit())
    	    	DrawTxt(Config.DisplaySettings.x, Config.DisplaySettings.y, Config.DisplaySettings.width, Config.DisplaySettings.height, Config.DisplaySettings.scale, display, 255, 255, 255, 255)
			end
		end
    end
end)

--Returns current road speed limit
function GetSpeedLimit()
	local coords = GetEntityCoords(PlayerPedId())
	local location = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
	local limit = Config.Limits[location]
	if limit then
		return limit
	else
		return "~r~~h~Contact Development!"
	end
end

--Draws text to the screen
function DrawTxt(x, y, width, height, scale, text, r, g, b, a)
    SetTextFont(6)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end