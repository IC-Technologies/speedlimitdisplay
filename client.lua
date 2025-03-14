local showlimit = true
local ped = PlayerPedId()
local speedmultiplier = 2.236936
local display = Config.DisplaySettings.text
local manualToggle = true

--Trigger this event in another script to toggle seeing the text on the screen or not.
RegisterNetEvent("ToggleSpeedLimit")
AddEventHandler("ToggleSpeedLimit", function(toggle)
	if Config.enableBadssentialsIntegration then
		manualToggle = toggle
	else
		showlimit = toggle
	end
end)

if Config.DisplaySettings.speedType == "MPH" then

	display = display:gsub("{SPEED_TYPE}", "MPH")

elseif Config.DisplaySettings.speedType == "KPH" then
	--speed type is KPH
	speedmultiplier = 3.6

	display = display:gsub("{SPEED_TYPE}", "KPH")
elseif (Config.DisplaySettings.speedType ~= "MPH") and (Config.DisplaySettings.speedType ~= "KPH") then
	--speed type is not configured correctly. Assumes MPH speed wise.

	display = display:gsub("{SPEED_TYPE}", "~r~~h~Contact Development!")
end

--Handles client interaction with the world (draws text to screen when inside a car and on a road)
Citizen.CreateThread(function()
	if Config.DisplaySettings.enableDisplay then
		while true do
			Wait(0)

			if showlimit then
				local limit = GetSpeedLimit()

				if Config.showOnFoot then
					display = display:gsub("{LIMIT}", limit)
					DrawTxt(Config.DisplaySettings.x, Config.DisplaySettings.y, Config.DisplaySettings.width, Config.DisplaySettings.height, Config.DisplaySettings.scale, display, 255, 255, 255, 255)
					return
				end

				local ped = PlayerPedId()
				local invehicle = IsPedInAnyVehicle(ped)
				
				if invehicle and Config.DisplaySettings.ColorOptions.enableColorChange and type(limit) == "number" then

					local speed = GetEntitySpeed(GetVehiclePedIsIn(ped)) * speedmultiplier
					--setting the differnce
					local diff = speed - limit

					if diff > Config.DisplaySettings.ColorOptions.color2Speed then
						--player is going faster than speed 2
						display = display:gsub("{LIMIT}", Config.DisplaySettings.ColorOptions.color2 .. limit)
					elseif diff > Config.DisplaySettings.ColorOptions.color1Speed then
						--player is going faster than speed 1
						display = display:gsub("{LIMIT}", Config.DisplaySettings.ColorOptions.color1 .. limit)
					else
						--player is going slower than speed 1
						display = display:gsub("{LIMIT}", limit)
					end
				else
					display = display:gsub("{LIMIT}", limit)
				end

				DrawTxt(Config.DisplaySettings.x, Config.DisplaySettings.y, Config.DisplaySettings.width, Config.DisplaySettings.height, Config.DisplaySettings.scale, display, 255, 255, 255, 255)
				
				
				--[[]
				if Config.enableBadssentialsIntegration then
					--Is Badssentials enabled and hud is not toggled and if player is in a vehicle
					
					if ((showlimit and invehicle) or Config.showOnFoot) and (not exports.Badssentials:IsDisplaysHidden()) then
						DrawTxt(Config.DisplaySettings.x, Config.DisplaySettings.y, Config.DisplaySettings.width, Config.DisplaySettings.height, Config.DisplaySettings.scale, display, 255, 255, 255, 255)
					end
				else
					--Badssentials is not enabled
					if (showlimit and invehicle) or Config.showOnFoot then		
						DrawTxt(Config.DisplaySettings.x, Config.DisplaySettings.y, Config.DisplaySettings.width, Config.DisplaySettings.height, Config.DisplaySettings.scale, display, 255, 255, 255, 255)
					end
				end
				]]
			end
		end
	end
end)

Citizen.CreateThread(function()
	if Config.DisplaySettings.enableDisplay and Config.enableBadssentialsIntegration then
		while true do
			Wait(500)

			if exports.Badssentials:IsDisplaysHidden() or not manualToggle then
				showlimit = false
			elseif manualToggle then
				if Config.showOnFoot then
					showlimit = true
					return
				end

				local ped = PlayerPedId()
				local invehicle = IsPedInAnyVehicle(ped)

				if invehicle then
					showlimit = true
				end
			end
		end
	end
end)

--Returns current road speed limit
function GetSpeedLimit()
	local coords = GetEntityCoords(ped)
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