if Config.enableBadssentialsIntegration and (GetResourceState("Badssentials") ~= "starting" and GetResourceState("Badssentials") ~= "started") then
    print("^1--------------------------------------------\n^4[" .. GetCurrentResourceName() .. "] " .. "^1ERROR:\n ^1enableBadssentialsIntegration is set to true but Badssentials could not be found or is not started!\n^3Make sure Badssentials is installed, started, and named '^0Badssentials^3'.\n^1--------------------------------------------^0")
end

if (Config.DisplaySettings.speedType ~= "MPH" and Config.DisplaySettings.speedType ~= "KPH") then
    print("^1--------------------------------------------\n^4[" .. GetCurrentResourceName() .. "] " .. "^1ERROR:\n ^1speedType is set to '" .. Config.DisplaySettings.speedType .. "', it must be set to 'MPH' or 'KPH'. Check your config!\n^1--------------------------------------------^0")
end