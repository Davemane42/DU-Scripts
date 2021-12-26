--[[
Player logger Version 2.0

Slot Rename:
  databank to "dataBank"
  screen to "screen"

connect a detection zone to the board for power (blue wire)

add yourself to the known user on line 7 of unit.start()
knownUser = {"My_Username"} --multiple user exemple {"User1","User2","User3"}

Activate the board manualy and type "help" in the lua chat for the command list
Only known user will be able to type commands

List of commands:
"'clear' [clear the databank]",
"'dump' [dump the table as JSON in the HTML so you can copy it]",
"'import' [WIP]",
"'remove (indice)' [remove the entry from the list",
"'exit' [exit debug mode]"
]]

--------------------------------------------

--------------- unit.start() ---------------

unit.hide()

json = require ("dkjson")
vec3 = require("cpml/vec3")

location = "Lobby" -- Name of the Location
knownUser = {} -- knownUser = {"User1"} -- multiple user knownUser = {"User1","User2","User3"}
ignoreKnown = true -- Doesn't display known user(s) to prevent screen flooding

player = database.getPlayer(unit.getMasterPlayerId())
latestList = json.decode(dataBank.getStringValue("latest"))

if latestList == nil then latestList={} end
known = false

function getTime()
    local hoursOffset = 0
    local unixTime = math.floor(system.getTime() + 1506729600) - (60*60*(hoursOffset or 0)) --(Oct. 1, 2017, at 00:00) //1506729600 //1506816000

    local hours = math.floor(unixTime / 3600 % 24)
    local minutes = math.floor(unixTime / 60 % 60)
    local seconds = math.floor(unixTime % 60)

    local unixTime = math.floor(unixTime / 86400) + 719468
    local era = math.floor(unixTime / 146097)
    local doe = math.floor(unixTime - era * 146097)
    local yoe = math.floor((doe - doe / 1460 + doe / 36524 - doe / 146096) / 365)
    --local year = math.floor(yoe + era * 400)
    local doy = doe - math.floor((365 * yoe + yoe / 4 - yoe / 100))
    local mp = math.floor((5 * doy + 2) / 153)

    --local year = year + (month <= 2 and 1 or 0)
    local month = math.floor(mp + (mp < 10 and 3 or -9))
    local day = math.ceil(doy - (153 * mp + 2) / 5 + 1)

    month = month < 10 and  "0" .. month or month
    day = day < 10 and  "0" .. day or day
    hours = hours < 10 and  "0" .. hours or hours
    minutes = minutes < 10 and  "0" .. minutes or minutes
    seconds = seconds < 10 and  "0" .. seconds or seconds

    return (day .. "/" .. month .. " " .. hours .. ":" .. minutes .. ":" .. seconds)
end

function redraw()
    local latestHTML = ""
    local count = 0
    if latestList ~= {} then
        for k, v in ipairs(latestList) do
            local textX = (count>=24 and "rx/2+" or "").."5"
            local textY = 20+((count%24)*24)
            count = count+1
            latestHTML = latestHTML..""..(v[4] and 'setNextFillColor(layer, 0, 1, 0, 1)\n' or "")..'addText(layer, font, "'..string.format('%s %s %s", %s, %s)\n', v[3], v[1], v[2], textX, textY)
        end
    end

    screen.setRenderScript([[
local rx, ry = getResolution()
local layer = createLayer()
local font = loadFont('FiraMono', 20)
setDefaultFillColor(layer, 6, 1, 0, 0, 1)

]]..latestHTML..[[

local layer = createLayer()
local font2 = loadFont('RobotoMono-Bold', 12)
setDefaultFillColor(layer, 6, 1, 1, 1, 1)
setNextFillColor(layer, 0, 0, 0, 1)
addBox (layer, rx-155, ry-40, 145, 35)
addText(layer, font2, 'Location: "]]..location..[["', rx-150, ry-24)
addText(layer, font2, "Player Logger v2.1", rx-150, ry-12)
]])
end

for i, v in pairs(knownUser) do
    if player.name == v then
        known = true
    end
end

if known then
    if vec3.new(unit.getMasterPlayerRelativePosition()):len() <= 3 then
        system.print("")
        system.print("Player Logger V2.1 by Davemane42")
        system.print("Debug enabled, type 'help' to get a list of commands")
        return
    else
        system.print("Too far away")
    end
end

if (known and ignoreKnown) == false then
    if latestList[1] ~= nil then
        if player.name == latestList[1][1] then
            if latestList ~= {} then
                table.remove(latestList, 1)
            end
        end
    end

    table.insert(latestList, 1, {player.name, player.id, getTime(), known})
    dataBank.setStringValue("latest", json.encode(latestList))
end

redraw()

unit.exit()

--------------------------------------------

----------- system.inputText(*) ------------

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
    unit.exit()
elseif arguments[1] == "dump" then
    screen.setHTML(json.encode(latestList))
    system.print("")
    system.print("dumped tables to the screen HTML")
    system.print("Right click (on the screen) -> Advanced -> Edit HTML content")
elseif arguments[1] == "remove" then
    local i = tonumber(arguments[2])
    if i and latestList[i] ~= nil then
        system.print("")
        system.print("removed #"..i.."")
        table.remove(latestList, i)
        dataBank.setStringValue("latest", json.encode(latestList))
        redraw()
    end
elseif arguments[1] == "exit" then
    redraw()
    unit.exit()
elseif arguments[1] == "help" then
    local help = {
        "'clear' [clear the databank]",
        "'dump' [dump the table as JSON in the HTML so you can copy it]",
        "'import' [WIP]",
        "'remove (indice)' [remove the entry from the list",
        "'exit' [exit debug mode]"
    }
    system.print("")
    for k, v in pairs(help) do
        system.print(v)
    end
end
