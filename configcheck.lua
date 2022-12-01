if Config.enableBadssentialsIntegration and (GetResourceState("Badssentials") ~= "starting" and GetResourceState("Badssentials") ~= "started") then
    print(GetResourceState("Badssentials"))
    print("^1--------------------------------------------\n^3[" .. GetCurrentResourceName() .. "] " .. "^1ERROR:\n ^1enableBadssentialsIntegration is set to true but Badssentials could not be found or is not started!\n^3Make sure Badssentials is installed, started, and named '^0Badssentials^3'.\n^1--------------------------------------------^0")
end