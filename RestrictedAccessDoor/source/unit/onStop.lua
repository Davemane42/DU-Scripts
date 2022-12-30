if closestZone ~= nil then
    doorsState(closestZone, "close")

    if screens ~= 0 then
        for k, v in pairs(screens) do
            if globalLockdown then
                v.setScriptInput("lockdown")
            else
                v.setScriptInput("")
            end
        end
    end
end
