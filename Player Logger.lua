--[[
        LINK DIAGRAM
     1way          2way
Zone ----> Switch <----> Board
You can connect more detection zone to the switch

Slot Rename:
  databank to "dataBank"
  screen to "screen"
  switch to "switch"

add yourself to the known user on line 5 of unit.start()
knownUser = {"My_Username"} --multiple user exemple {"User1","User2","User3"}

Activate the board manualy and type "help" in the lua chat for the command list
Only known user will be able to type commands

List of commands:
'clear' [clear the databank]
'dump latest/unknown' [dump the table as JSON in the HTML so you can copy it]
'remove latest/unknown indice' [remove an entry from one of the table]
'exit' [exit debug mode]

]]
--------------------------------------------

--------------- unit.start() ---------------

unit.hide()

json = require ("dkjson")

knownUser = {} -- knownUser = {"User1"} -- multiple user knownUser = {"User1","User2","User3"}
player = database.getPlayer(unit.getMasterPlayerId())
latestList = json.decode(dataBank.getStringValue("latest")) --{{User1, ID, Time, Known},{User2, ID, Time, Known}}
unknownList = json.decode(dataBank.getStringValue("unknown")) --{{User1, ID, Time},{User2, ID, Time}}
known = false

if unknownList == nil then unknownList={} end
if latestList == nil then latestList={} end

function getTime()
    local now = math.floor(system.getTime() + 1506729600) --(Oct. 1, 2017, at 00:00) //1506729600 //1506816000
    local hours = math.floor((now % 86400) / 3600)
    local minutes = math.floor((now % 3600) / 60)
    local seconds = math.floor(now % 60)

    if hours < 10 then hours = "0"..hours end
    if minutes < 10 then minutes = "0"..minutes end
    if seconds < 10 then seconds = "0"..seconds end

    return string.format("%s:%s:%s", hours, minutes, seconds)
end

function redraw()
    local latestHTML = ""
    if latestList ~= {} then
        for k, v in pairs(latestList) do
            latestHTML = latestHTML.."<div style=color:"..(v[4] and "green" or "white")..";font-size:4vh>"..string.format("%s %s %s", v[3], v[1], v[2]).."</div>"
        end
    end

    local unknownHTML = ""
    if unknownList ~= {} then
        for k, v in pairs(unknownList) do
            unknownHTML = unknownHTML.."<div style=color:red;font-size:4vh>"..string.format("%s %s %s", v[3], v[1], v[2]).."</div>"
        end
    end

    screen.setHTML([[
    <style>
        .column {
        float: left;
        width: 50%;
        }

        .row:after {
        content: "";
        display: table;
        clear: both;
        }
    </style>
    <div class="row">
        <div class="column" style="">
            <h1>Latest detection</h1>
            ]]..latestHTML..[[
        </div>
        <div class="column" style="">
            <h1>Latest unknown detection</h1>
            ]]..unknownHTML..[[
        </div>
    </div>
    ]])
end

for i, v in pairs(knownUser) do
    if player.name == v then
        known = true
    end
end

if switch.getState() == 0 then
    if known then
        system.print("Debug enabled, type 'help' to get a list of commands")
    end
    return
end

if known == false then
    if unknownList ~= {} then
        for k, v in pairs(unknownList) do
            if player.name == v[1] then
                table.remove(unknownList, k)
            end
        end
    end
    table.insert(unknownList, 1, {player.name, player.id, getTime()})
    dataBank.setStringValue("unknown", json.encode(unknownList))
end

table.insert(latestList, 1, {player.name, player.id, getTime(), known})
dataBank.setStringValue("latest", json.encode(latestList))

redraw()

switch.deactivate()

--------------------------------------------

--------- system.inputText(*) ---------

if known == false then system.print("UNKNOWN USER CANNOT INPUT COMMAND"); return end

local arguments = {}
for word in string.gmatch(text, "%w+") do
    table.insert(arguments, word)
end

if arguments[1] == "clear" then
    dataBank.clear()
    system.print("DataBank Cleared")
    latestList, unknownList = {}, {}
    redraw()
    switch.activate()
    switch.deactivate()
elseif arguments[1] == "dump" then
    if arguments[2] == "latest" then
        screen.setHTML(json.encode(latestList))
        system.print("dumped 'latest' table to the screen HTML")
    elseif arguments[2] == "unknown" then
        screen.setHTML(json.encode(unknownList))
        system.print("dumped 'unknown' table to the screen HTML")
    end
elseif arguments[1] == "remove" then
    local i = tonumber(arguments[3])
    if arguments[2] == "latest" then
        if i and latestList[i] ~= nil then
            table.remove(latestList, i)
            dataBank.setStringValue("latest", json.encode(latestList))
            system.print("removed #"..i.." in latest")
            redraw()
        end
    elseif arguments[2] == "unknown" then
        if i and unknownList[i] ~= nil then
            table.remove(unknownList, i)
            dataBank.setStringValue("unknown", json.encode(unknownList))
            system.print("removed #"..i.." in unknown")
            redraw()
        end
    end
elseif arguments[1] == "exit" then
    redraw()
    switch.activate()
    switch.deactivate()
elseif arguments[1] == "help" then
    local help = {
        "'clear' [clear the databank]",
        "'dump latest/unknown' [dump the table as JSON in the HTML so you can copy it]",
        "'remove latest/unknown indice' [remove an entry from one of the table]",
        "'exit' [exit debug mode]"
    }
    for k, v in pairs(help) do
        system.print(v)
    end
end
