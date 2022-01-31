if unit.getSignalIn('in')==1 then return end
if known == false then system.print("UNKNOWN USER CANNOT INPUT COMMAND"); return end

local arguments = {}
for word in string.gmatch(text, "%w+") do
    table.insert(arguments, word)
end

if arguments[1] == "clear" then

    for k,v in pairs(dataBanks) do
        v.setStringValue ("logData", "")
    end

    logData = {}
    screen.clearScriptOutput()
    loadScreenData()

    system.print("DataBank Cleared")
    exit=true
elseif arguments[1] == "dump" then
    system.print("")
    if #logData > 0 then
        screen.setHTML(encodeLogData())

        system.print(string.format("dumped table with %s %s to the screen HTML. CTRL+L or", #logData, #logData > 1 and  "Entries" or "Entry"))
        system.print("Right click (on the screen) -> Advanced -> Edit HTML content")
        dataBanks[1].setStringValue("screenVer", nil)

        exit=true
    else
        system.print("No data to dump")
    end
elseif arguments[1] == "remove" then

    local i = tonumber(arguments[2])
    if i and logData[i] ~= nil then

        table.remove(logData, i)
        saveData()
        loadScreenData()
        system.print("")
        system.print("removed #"..i.."")
    end
elseif arguments[1] == "exit" then
    loadScreenData()
    exit=true
elseif arguments[1] == "update" then
    loadScreenCode()
    loadScreenData()
    exit=true
elseif arguments[1] == "help" then

    local help = {
        "'clear' [clear the databank]",
        "'dump' [dump the table as JSON in the HTML so you can copy it]",
        "'exit' [exit debug mode]",
        "'import' [WIP]",
        "'remove (indice)' [remove the entry from the list]",
        "'update' [Update the screen code]"
    }
    system.print("")
    for k, v in pairs(help) do
        system.print(v)
    end
end
