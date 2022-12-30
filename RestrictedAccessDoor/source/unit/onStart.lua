vec3 = require("cpml/vec3")
unit.hideWidget()

-- knownUser = "User1"
-- knownUser = "User1,User2,User3"
knownUser = "" --export <p style="font-size:150%;">ex: "Davemane42,User2"</p><p style="font-size:150%; color:red";">Keep the list between quotes ""</p>
knownOrg = "" --export <p style="font-size:150%;">ex: "The Prospectors,Org Name2"</p><p style="font-size:150%; color:red";">Keep the list between quotes ""</p>

zoneRadius = 5 --export <p style="font-size:150%;">Maximum radius of a zone in meters</p><br><p style="font-size:150%; color:green;">Default: 5</p>
activationDistance = 25 --export <p style="font-size:150%;">Maximum distance to activate a zone in meters</p><br><p style="font-size:150%; color:green;">Default: 25</p>
sigleZone = false --export <p style="font-size:150%;">All elements are in a single zone</p><br><p style="font-size:150%; color:green;">Default: false</p>

standbyTextColor = "192, 203, 220" --export <p style="font-size:150%; color:rgb(192, 203, 220);">Default: "192, 203, 220"<p><p style="font-size:150%; color:red;">Keep R,G,B between quotes ""</p>
standbyBackgroundColor = "24, 20, 37" --export <p style="font-size:150%; background-color:rgb(24, 20, 37);">Default: "24, 20, 37"<p><p style="font-size:150%; color:red;">Keep R,G,B between quotes ""</p>
knownTextColor = "192, 203, 220" --export <p style="font-size:150%; color:rgb(192, 203, 220);">Default: "192, 203, 220"<p><p style="font-size:150%; color:red;">Keep R,G,B between quotes ""</p>
knownBackgroundColor = "24, 20, 37" --export <p style="font-size:150%; background-color:rgb(24, 20, 37);">Default: "24, 20, 37"<p><p style="font-size:150%; color:red;">Keep R,G,B between quotes ""</p>
unknownTextColor = "192, 203, 220" --export <p style="font-size:150%; color:rgb(192, 203, 220);">Default: "192, 203, 220"<p><p style="font-size:150%; color:red;">Keep R,G,B between quotes ""</p>
unknownBackgroundColor = "255, 0, 0" --export <p style="font-size:150%; background-color:rgb(255, 0, 0);">Default: "255, 0, 0"<p><p style="font-size:150%; color:red;">Keep R,G,B between quotes ""</p>

displayEmptyZoneNumber = true --export <p style="font-size:150%;">Display empty names as</p><p style="font-size:150%;">"Zone 1"</p><p style="font-size:150%;">"Zone 2"</p><p style="font-size:150%;">"Zone 3"</p><p style="font-size:150%;">ect...</p><br><p style="font-size:150%; color:green;">Default: true</p>
zone1 = "" --export <p style="font-size:150%; color:red";">Keep between quotes ""</p>
zone2 = "" --export <p style="font-size:150%; color:red";">Keep between quotes ""</p>
zone3 = "" --export <p style="font-size:150%; color:red";">Keep between quotes ""</p>
zone4 = "" --export <p style="font-size:150%; color:red";">Keep between quotes ""</p>
zone5 = "" --export <p style="font-size:150%; color:red";">Keep between quotes ""</p>
zone6 = "" --export <p style="font-size:150%; color:red";">Keep between quotes ""</p>
zone7 = "" --export <p style="font-size:150%; color:red";">Keep between quotes ""</p>
zone8 = "" --export <p style="font-size:150%; color:red";">Keep between quotes ""</p>
zone9 = "" --export <p style="font-size:150%; color:red";">Keep between quotes ""</p>
zoneName = {zone1, zone2, zone3, zone4, zone5, zone6, zone7, zone8, zone9}

updateScreens = false --export <p style="font-size:150%;">Update screens</p><br><p style="font-size:150%; color:green;">Default: false</p><p style="font-size:150%; color:red;">Turn back off if not needed</p>

playerData = database.getPlayer(player.getId())
known = false
globalLockdown = false

-- Loop trough slots and get the screen(s) and door(s)
screens = {}
doors = {}
switches = {}
for slot_name, slot in pairs(unit) do
    if type(slot) == "table" and type(slot.export) == "table" and slot.getClass then
        local elementClass = slot.getClass():lower()

        local pos = slot.getPosition()
        slot.position = vec3.new(pos[1],pos[2],pos[3])

        slot.slotname = slot_name

        if elementClass == "screenunit" then
            table.insert(screens, slot)
        elseif elementClass:find("door") or elementClass == "airlock" or elementClass == "gate" or elementClass == "forcefieldunit" then
            table.insert(doors, slot)
        elseif elementClass == "manualswitchunit" then
            table.insert(switches, slot)
        end
    end
end
if #doors == 0 then
    system.print("Missing a door, exiting")
    unit.exit()
    return
end
if #switches ~= 0 then
    if switches[1].isActive() == 1 then
        globalLockdown = true
    end
end
if globalLockdown then system.print("lockdown") end

function getClosestZone(pos, max)
    local max = max or 999
    local closest = {nil, 10000}
    for k, v in pairs(zones) do
        local distance = pos.dist(pos, v.position)
        if distance < closest[2] and distance < max then
            closest = {k, distance}
        end
    end

    return closest[1]
end

function doorsState(zone, state)
    for k, v in pairs(zones[zone]["door"]) do
        door = doors[v]
        local elementClass = door.getClass():lower()
        if state == "open" then
            if elementClass == "forcefieldunit" then
                door.retract()
            else
                door.open()
            end
        elseif state == "close" then
            if elementClass == "forcefieldunit" then
                door.deploy()
            else
                door.close()
            end
        end
    end
end

if not sigleZone then
    -- Group doors/screen into zones
    table.sort(doors, function(a,b) return a.slotname < b.slotname end)

    zones = {}
    for k, v in pairs(doors) do
        if v.zone == nil then
            zoneID = #zones+1
            doors[k].zone = zoneID
            zones[zoneID] = {["door"]={k}, ["screen"]={}, ["position"]=v.position, ["name"]=zoneName[zoneID] or ""}
            local elementClass = v.getClass():lower()
            local id = v.getItemId()

            for kk, vv in pairs(doors) do
                local valid = false
                if vv.getItemId() == id then valid=true end
                if vv.getClass():lower() ~= elementClass then valid=false end

                if kk ~= k and valid then
                    if vv.zone == nil and v.position.dist(v.position, vv.position) < zoneRadius then
                        doors[kk].zone = zoneID
                        table.insert(zones[zoneID]["door"], kk)
                    end
                end
            end
        end
    end

    closestZone = getClosestZone(vec3.new(player.getPosition()), activationRadius)

    if #screens ~= 0 then
        for k, v in pairs(screens) do
            local closest = getClosestZone(v.position)
            if closest ~= nil then
                table.insert(zones[closest]["screen"], k)
            end
        end
    end

    for k, v in pairs(zones) do
        doorsState(k, "close")
    end
    if screens ~= 0 then
        for k, v in pairs(screens) do
            v.setScriptInput("")
        end
    end
else
    -- Single Zone
    zones = {{["door"]={k}, ["screen"]={}, ["name"]=zoneName[1] or ""}}
    for k, v in pairs(doors) do
        doors[k].zone = 1
        table.insert(zones[1]["door"], k)
    end
    if #screens ~= 0 then
        for k, v in pairs(screens) do
            table.insert(zones[1]["screen"], k)
        end
    end
    closestZone = 1
end

local colorHash = 0
local str = string.format("%s,%s,%s,%s,%s,%s",standbyTextColor, standbyBackgroundColor, knownTextColor, knownBackgroundColor, unknownTextColor, unknownBackgroundColor)
for x in string.gmatch(str, "([^,]+)") do colorHash = colorHash+tonumber(x) end

-- Update screens if necessary
local version = "2.1"
for k, v in pairs(zones) do
    if #v["screen"] ~= 0 then
        for kk, vv in pairs(v["screen"]) do
            screens[vv].activate()
            local location = v.name
            if displayEmptyZoneNumber and location == "" then
                location = string.format("ZONE %s", k)
            end

            if updateScreens or screens[vv].getScriptOutput() ~= string.format("%s %s %s", version, location, colorHash) then
                -- Screen code
                screens[vv].setRenderScript([[
local layer = createLayer()
local rx, ry = getResolution()
local time = getTime()
local input = getInput()

]].. string.format([[
local version = "%s"
local location = "%s"
local colorHash = %s
local standbyTextColor = {%s}
local standbyBackgroundColor = {%s}
local knownTextColor = {%s}
local knownBackgroundColor = {%s}
local unknownTextColor = {%s}
local unknownBackgroundColor = {%s}]],
version,
location,
colorHash,
standbyTextColor,
standbyBackgroundColor,
knownTextColor,
knownBackgroundColor,
unknownTextColor,
unknownBackgroundColor)..[[

setOutput(string.format("%s %s %s", version, location, colorHash))

local fontBig = loadFont("RobotoMono-Bold", 150)
local fontSmall = loadFont("RobotoMono", 75)

function getColor(var)
    return var[1]/255, var[2]/255, var[3]/255
end

local backR, backG, backB = getColor(standbyBackgroundColor)
local textR, textG, textB = getColor(standbyTextColor)
local strCenter = "RESTRICTED"
local username = ""
local t = 1
local lockdown = false

if input ~= "" then
    local arguments = {}
    for word in string.gmatch(input, "([^,]+)") do
        table.insert(arguments, word:match("^%s*(.-)%s*$"))
    end

    if arguments[1] == "true" then
        backR, backG, backB = getColor(knownBackgroundColor)
        textR, textG, textB = getColor(knownTextColor)
        strCenter = "WELCOME"
        t = 1
        username = arguments[2]
    elseif arguments[1] == "false" then
        backR, backG, backB = getColor(unknownBackgroundColor)
        textR, textG, textB = getColor(unknownTextColor)
        strCenter = "REFUSED"
        t = math.sin(time*10)/2+0.5
        requestAnimationFrame(1)
        username = arguments[2]
    elseif arguments[1] == "lockdown" then
        backR, backG, backB = getColor(unknownBackgroundColor)
        textR, textG, textB = getColor(unknownTextColor)
        strCenter = "LOCKDOWN"
        username = ""
        t = math.sin(time*10)/2+0.5
        requestAnimationFrame(1)

        lockdown = true
    end
end

setBackgroundColor(backR, backG, backB)
setDefaultFillColor(layer, Shape_Text, textR, textG, textB, 1)
setDefaultTextAlign(layer, AlignH_Center, AlignV_Middle)
setDefaultFillColor(layer, Shape_Box, textR, textG, textB, 1)

function drawLineText(text, font, height, lineWidth)
    local border = 15
    addBox(layer, 0, height-lineWidth/2, rx, lineWidth)

    if text ~= "" then
        local strWidth = getTextBounds(font, text)
        setNextFillColor(layer, backR, backG, backB, 1)
        addBox(layer, rx/2-strWidth/2-border, height-lineWidth/2-5, strWidth+border*2, lineWidth+10)
        addText(layer, font, text, rx/2, height)
    end
end

-- Top Warning
drawLineText("WARNING", fontSmall, ry*0.1, 40)

-- Bottom Location
drawLineText(location, fontSmall, ry*0.9, 20)

-- Middle Text
if lockdown then
    height = ry*0.5
else
    height = ry*0.4
end

local strWidth, strHeight = getTextBounds(fontBig, strCenter)
setNextFillColor(layer, textR, textG, textB, t)
addText(layer, fontBig, strCenter, rx/2, height)
if input == "" then
    addText(layer, fontBig, "AREA", rx/2, ry*0.65)
end

-- Username
if username ~= "" then
    addBox(layer, 0, ry*0.65-4, rx, 8)
    addText(layer, fontSmall, username, rx/2, ry*0.75)
end
                    ]])
            end
        end
    end
end

-- Convert knownUser CSV to a table
if knownUser ~= "" then
    for name in string.gmatch(knownUser, "([^,]+)") do
        if playerData.name == name:match("^%s*(.-)%s*$") then
            known = true
        end
    end
end

-- Convert knownOrg CSV to a table
orgList = player.getOrgIds()
if knownOrg ~= "" and #orgList>0 then
    for name in string.gmatch(knownOrg, "([^,]+)") do
        -- Look trough master player orgs
        for k, v in pairs(orgList) do
            if database.getOrganization(v).name == name:match("^%s*(.-)%s*$") then
                known = true
            end
        end
    end
end

if globalLockdown then
    for k, v in pairs(zones) do
        for kk, vv in pairs(v["door"]) do
            doorsState(k, "lockdown")
        end
        if #v["screen"] ~= 0 then
            for kk, vv in pairs(v["screen"]) do
                screens[vv].setScriptInput("lockdown")
            end
        end
    end
else
    if closestZone ~= nil then
        if known then
            doorsState(closestZone, "open")
        else
            doorsState(closestZone, "close")
        end

        if #zones[closestZone]["screen"] ~= 0 then
            for k, v in pairs(zones[closestZone]["screen"]) do
                screens[v].setScriptInput(string.format("%s,%s", known, playerData.name))
            end
        end
    end
end
