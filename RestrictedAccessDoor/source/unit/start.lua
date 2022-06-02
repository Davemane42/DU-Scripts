unit.hide()

-- knownUser = "User1"
-- knownUser = "User1,User2,User3"
knownUser = "" --export Keep the list between quotes '' and no spaces ex: 'Davemane42,User2'
knownOrg = "" --export Keep the list between quotes '' and no spaces around the names ex: "The Prospectors,Org Name2"
location = "Lobby" --export Keep between quotes ''

version = "1.2"
player = database.getPlayer(unit.getMasterPlayerId())
known = false

-- Convert knownUser CSV to a table
if knownUser ~= "" then
    for name in string.gmatch(knownUser, "([^,]+)") do
        if player.name == name then
            known = true
        end
    end
end

-- Convert knownOrg CSV to a table
orgList = unit.getMasterPlayerOrgIds()
if knownOrg ~= "" and #orgList>0 then
    for name in string.gmatch(knownOrg, "([^,]+)") do
        -- Look trough master player orgs
        for k, v in pairs(orgList) do
            if database.getOrganization(v).name == name then
                known = true
            end
        end
    end
end

-- Loop trough slots and get the screen(s) and door
screens = {}
door = nil
for slot_name, slot in pairs(unit) do
    if type(slot) == "table" and type(slot.export) == "table" and slot.getElementClass then
        local elementClass = slot.getElementClass():lower()
        if elementClass == "screenunit" then
            slot.slotname = slot_name
            table.insert(screens, slot)
        elseif elementClass:find("door") or elementClass == "airlock" or elementClass == "gate" then
            door = slot
        end
    end
end
if door == nil then
    system.print("Missing a door, exiting")
    unit.exit()
    return
end

if known then door.activate() else door.deactivate() end

if #screens ~= 0 then
    for k, screen in pairs(screens) do
        screen.setScriptInput(string.format("%s %s", known, player.name))
        screen.activate()

        -- Screen code
        if screen.getScriptOutput() ~= version then
            screen.setRenderScript([[
local layer = createLayer()
local rx, ry = getResolution()
local time = getTime()

local version = "]]..version..[["
local location = "]]..location..[["

setOutput(version)

local input = getInput()

if input ~= "" then
    local arguments = {}
    for word in string.gmatch(input, "%w+") do
        table.insert(arguments, word)
    end

    local r,g,b = 0,1,0
    local strCenter = "WELCOME"
    local t = 1

    if arguments[1] == "false" then
        r,g,b = 1,0,0
        strCenter = "REFUSED"
        t = math.sin(time*10)/2+0.5
        requestAnimationFrame(1)
    end

    local fontBig = loadFont("RobotoMono-Bold", 150)
    local fontSmall = loadFont("RobotoMono", 75)
    local border = 10

    setBackgroundColor(r,g,b)
    setDefaultFillColor(layer, Shape_Text, 0, 0, 0, 1)
    setDefaultTextAlign(layer, AlignH_Center, AlignV_Middle)
    setDefaultFillColor(layer, Shape_Box, 0, 0, 0, 1)

    -- Top Warning
    local height = ry*0.1

    addBox(layer, 0, height-20, rx, 40)

    local str = "WARNING"
    local strWidth = getTextBounds(fontSmall, str)
    setNextFillColor(layer, r,g,b, 1)
    addBox(layer, rx/2-strWidth/2-border, height-20, strWidth+border*2, 40)
    addText(layer, fontSmall, str, rx/2, height)

    -- Middle Text
    local height = ry*0.4
    local strWidth, strHeight = getTextBounds(fontBig, strCenter)
    setNextFillColor(layer, 0, 0, 0, t)
    addText(layer, fontBig, strCenter, rx/2, height)

    local left = createLayer()
    setDefaultStrokeColor(left, Shape_Line, 0, 0, 0, 1)
    setDefaultStrokeWidth(left, Shape_Line, 50)

    setLayerClipRect(left, 0, 0, rx/2-strWidth/2-border, strHeight+border*2)
    setLayerTranslation(left, 0, height-strHeight/2-border)

    addLine(left, -50, 50, 50, -50)
    addLine(left, -50, 50+150, 50+150, -50)
    addLine(left, -50, 50+300, 50+300, -50)

    local right = createLayer()
    setDefaultStrokeColor(right, Shape_Line, 0, 0, 0, 1)
    setDefaultStrokeWidth(right, Shape_Line, 50)

    setLayerClipRect(right, rx/2+strWidth/2+border, 0, rx/2-strWidth/2-border, strHeight+border*2)
    setLayerTranslation(right, 0, height-strHeight/2-border)

    addLine(right, rx+50, 50, rx-50, -50)
    addLine(right, rx+50, 50+150, rx-50-150, -50)
    addLine(right, rx+50, 50+350, rx-50-350, -50)

    -- Username
    addBox(layer, 0, ry*0.65-4, rx, 8)
    addText(layer, fontSmall, arguments[2], rx/2, ry*0.75)

    -- Bottom Text
    local height = ry*0.9

    addBox(layer, 0, height-10, rx, 20)

    local strWidth = getTextBounds(fontSmall, location)
    setNextFillColor(layer, r,g,b, 1)
    addBox(layer, rx/2-strWidth/2-border, height-10, strWidth+border*2, 20)
    addText(layer, fontSmall, location, rx/2, height)
else
    local size = 100
    local font = loadFont("RobotoMono-Bold", size)
    local text = { "Restricted", "Area"}
    for k,v in pairs(text) do
        setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
        setNextFillColor(layer, 1, 1, 1, 1)
        addText(layer, font, v, rx/2, ry/2 - ((#text-1)/2)*size + (k-1)*size)
    end
end
                ]])
        end
    end
end
