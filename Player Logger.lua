--[[
        LINK DIAGRAM
     1way          2way
Zone ----> Switch <----> Board
You can connect more detection zone to the switch

Slot Rename:
  databank to "dataBank"
  screen to "screen"
  switch to "switch"

if you want to reset the list activate the
board manualy and type "reset" in the lua chat
]]
--------------------------------------------

--------------- unit.start() ---------------

unit.hide()

if switch.getState() == 0 then system.print("Debug: on"); return end

local json = require ("dkjson")

local player = database.getPlayer(unit.getMasterPlayerId())
local knownUser = {"Davemane42"} --Exemple {"User1","User2","User3"}
local latestList = json.decode(dataBank.getStringValue("latest")) --{{User1, ID, Time, Known},{User2, ID, Time, Known}}
local unknownList = json.decode(dataBank.getStringValue("unknown")) --{{User1, ID, Time},{User2, ID, Time}}

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

local known = false
for i, v in pairs(knownUser) do
    if player.name == v then
        known = true
    end
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

local latestHTML = ""
local unknownHTML = ""

if latestList ~= {} then
    for k, v in pairs(latestList) do
        latestHTML = latestHTML.."<div style=color:"..(v[4] and "green" or "white")..";font-size:4vh>"..string.format("%s %s %s", v[3], v[1], v[2]).."</div>"
    end
end

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

switch.deactivate()

--------------------------------------------

--------- system.inputText(reset) ---------

screen.setHTML([[
<style>
    .centered {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    font-size:10vh;
    color:red;
    }
</style>

<div class="centered">
    Data Cleared
</div>
]])

dataBank.clear()
switch.activate()
switch.deactivate()
