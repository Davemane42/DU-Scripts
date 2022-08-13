local output = screen.getScriptOutput()
if output ~= "" then
    screen.setScriptInput("")
    screen.clearScriptOutput()

    local instruction = {}
    local pos = string.find(output, " ")
    if pos == nil then pos=-1 end
    for word in string.gmatch(string.sub(output, 1, pos), "%w+") do
        table.insert(instruction, word)
    end
    local outputData = string.sub(output, pos+1)

    if instruction[1] == "load" then

        local i = tonumber(instruction[2])
        local max = tonumber(instruction[3])

        if i <= max then
            local screenData = string.format("load,%s,%s %s", i, max, string.sub(loadBuffer, 1+1000*(i-1), 1000+1000*(i-1)))
            screen.setScriptInput(screenData)
        end
    elseif instruction[1] == "end" then
        comState = nil
        loadBuffer = nil
        screen.setScriptInput("")
    end
end

if exit and comState == nil then switch.deactivate() unit.exit() end
