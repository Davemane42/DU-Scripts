door.close()

if #screens ~= 0 then
    for k, screen in pairs(screens) do
        screen.setScriptInput("")
    end
end
