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
		if Config.enableBadssentialsIntegration then
			--Is Badssentials enabled and hud is not toggled and if player is in a vehicle
			if IsPedInAnyVehicle(PlayerPedId()) and (not exports.Badssentials:IsDisplaysHidden()) then
				if showlimit == true then
					local display = Config.DisplaySettings.text

					if Config.DisplaySettings.ColorOptions.enableColorChange then
						local speed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId()))
						local limit = GetSpeedLimit()
						
						if Config.DisplaySettings.speedType == "MPH" then
							--speed type is MPH
							speed = speed * 2.236936

							display = display:gsub("{SPEED_TYPE}", "MPH")
						elseif Config.DisplaySettings.speedType == "KPH" then
							--speed type is KPH
							speed = speed * 3.6

							display = display:gsub("{SPEED_TYPE}", "KPH")
						elseif (Config.DisplaySettings.speedType ~= "MPH") and (Config.DisplaySettings.speedType ~= "KPH") then
							--speed type is not configured correctly. Assumes MPH speed wise.
							speed = speed * 2.236936

							display = display:gsub("{SPEED_TYPE}", "~r~~h~Contact Development!")
						end
						
						if type(limit) == "number" then
							--setting the differnce
							local diff = speed - limit

							if diff < Config.DisplaySettings.ColorOptions.color2Speed and diff > Config.DisplaySettings.ColorOptions.color1Speed then
								--player is going faster than speed 1
								display = display:gsub("{LIMIT}", Config.DisplaySettings.ColorOptions.color1 .. limit)
							elseif diff > Config.DisplaySettings.ColorOptions.color2Speed then
								--player is going faster than speed 2
								display = display:gsub("{LIMIT}", Config.DisplaySettings.ColorOptions.color2 .. limit)
							else 
								--Player is going below speed 1
								display = display:gsub("{LIMIT}", limit)
							end
						else
							--GetSpeedLimit returned text.
							display = display:gsub("{LIMIT}", limit)
						end
					else
						--color options not enabled
						display = display:gsub("{LIMIT}", GetSpeedLimit())
					end

					DrawTxt(Config.DisplaySettings.x, Config.DisplaySettings.y, Config.DisplaySettings.width, Config.DisplaySettings.height, Config.DisplaySettings.scale, display, 255, 255, 255, 255)
				end
			end
		else
			if IsPedInAnyVehicle(PlayerPedId()) then
				if showlimit == true then
					local display = Config.DisplaySettings.text
					display = display:gsub("{LIMIT}", GetSpeedLimit())
					DrawTxt(Config.DisplaySettings.x, Config.DisplaySettings.y, Config.DisplaySettings.width, Config.DisplaySettings.height, Config.DisplaySettings.scale, display, 255, 255, 255, 255)
				end
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