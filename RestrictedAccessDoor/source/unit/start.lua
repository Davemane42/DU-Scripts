unit.hide()

-- knownUser = "User1"
-- knownUser = "User1,User2,User3"
knownUser = "" --export Keep the list between quote '' and no spaces ex: 'Davemane42,User2'

version = "1.0"
player = database.getPlayer(unit.getMasterPlayerId())
known = false

-- Convert knownUser CSV to a table
knownUserList = {}
if knownUser ~= "" then
    for name in string.gmatch(knownUser, "([^,]+)") do
        table.insert(knownUserList, name)
        if player.name == name then
            known = true
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
local rx, ry = getResolution()
local layer = createLayer()
local size = 100
local font = loadFont('FiraMono', size)
local version = "]]..version..[["

setOutput(version)

local input = getInput()
local arguments = {}
for word in string.gmatch(input, "%w+") do
    table.insert(arguments, word)
end

local text = { "Restricted", "Area"}
local color = {1,1,1}
if arguments[1] == "true" then
    text = { arguments[2], "Autorized"}
    color = {0,1,0}
elseif arguments[1] == "false" then
    text = { arguments[2], "Unautorized"}
    color = {1,0,0}
end

for k,v in pairs(text) do
    setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
    setNextFillColor(layer, color[1], color[2], color[3], 1)
    addText(layer, font, v, rx/2, ry/2 - ((#text-1)/2)*size + (k-1)*size)
end
                ]])
        end
    end
end
