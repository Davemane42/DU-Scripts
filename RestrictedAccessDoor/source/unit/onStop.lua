if closestZone ~= nil then
    doorsState(closestZone, "close")

    if screens ~= 0 then
        for k, v in pairs(screens) do
            v.setScriptInput("")
        end
    end
end
