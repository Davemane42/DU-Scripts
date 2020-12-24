-- THIS GOES IN system->inputText(*)
-- You need to rename to slot to "antigrav" and "core"
arguments = {}
for word in string.gmatch(text, "%w+") do
    table.insert(arguments, word)
end

if arguments[1] == "agg" then
    if arguments[2] == "on" then
        system.print("AGG turned on")
        antigrav.activate()
        antigrav.show()
        antigrav.setBaseAltitude(math.max(core.getAltitude(), 1000))
    elseif arguments[2] == "off" then
        system.print("AGG turned off")
        antigrav.deactivate()
        antigrav.hide()
    elseif arguments[2] == "stop" then
        system.print(string.format("AGG stopped at %s meters", antigrav.getBaseAltitude()))
        antigrav.setBaseAltitude(antigrav.getBaseAltitude())
    end
        value = tonumber(arguments[2])
    if type(value) == "number" then
        value = math.max(value, 1000)
        system.print(string.format("AGG set to %s meters", value))
        antigrav.setBaseAltitude(value)
    end
end