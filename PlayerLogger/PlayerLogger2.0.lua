unit.hide()

json = require ("dkjson")
vec3 = require("cpml/vec3")

location = "location" --export: Name of the Location
knownUser = {} -- knownUser = {"User1"} -- multiple user knownUser = {"User1","User2","User3"}
ignoreKnown = false --export: Doesn't display known user(s) to prevent screen flooding

player = database.getPlayer(unit.getMasterPlayerId())
latestList = json.decode(dataBank.getStringValue("latest"))

if latestList == nil then latestList={} end
known = false

function getTime()
    local hoursOffset = -0 --export
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
    if latestList ~= {} then
        for k, v in ipairs(latestList) do
            latestHTML = latestHTML..'<li'..(v[4] and ' style="color: green;"' or "")..'>'..string.format("%s %s %s", v[3], v[1], v[2])..'</li>\n    '
        end
    end
    
    screen.setHTML([[
<style>
    .container {
    display: flex;
    flex-direction: column;
    flex-wrap: wrap;
    justify-content: flex-start;
    height: 100%;
    }

    li {
    width: 50%;
    font-size:4vh;
    font-weight:bold;
    font-family:Montserrat;
    color: red;
    }

    .green {
    color: green;
    }	
</style>

<ol class="container">
    ]]..latestHTML..[[ 
</ol>

<div style=position:absolute;bottom:0;right:0;background-color:black;color:white;font-size:3vh;font-family:Montserrat;padding-right:1vh;text-align:center;>Location: "]]..location..[["<br>Player Logger v2.0</div>
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
        system.print("Player Logger V2.0 by Davemane42")
        system.print("Debug enabled, type 'help' to get a list of commands")
        return
    else
        system.print("Too far away")
    end
end

if (known and ignoreKnown) == false then
    system.print("vazio0")
    if latestList[1] ~= nil then
        system.print("vazio1")
        if player.name == latestList[1][1] then
            if latestList ~= {} then
                system.print("vazio2")
            end
        end
    end
    
    table.insert(latestList, 1, {player.name, player.id, getTime(), known})
    dataBank.setStringValue("latest", json.encode(latestList))
else
    table.remove(latestList, 1)
end

redraw()

unit.exit()
