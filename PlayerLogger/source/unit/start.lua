----------
-- INIT --
----------
unit.hideWidget()

-- knownUser = "User1"
-- knownUser = "User1,User2,User3"
knownUser = "" --export Keep the list between quotes '' and no spaces ex: 'Davemane42,User2'
knownOrg = "" --export Keep the list between quotes '' and no spaces around the names ex: "The Prospectors,Org Name2"
ignoreKnown = true --export Doesn't display known user(s) to prevent screen flooding

location = "Lobby" --export Keep between quotes ''

mergeLastDay = true --export if the player was seen in the last 24h, delete the old one
mergeLastDayCount = 25 --export search the last x entries for the 'mergeLastDay' setting
known = false
mode = ""
version = "4.0"

---------------
-- Functions --
---------------

-- Encode logData table to "JSON"
function encodeLogData(limit)
    limit = limit or #logData

    local buffer = "["
    for i=1, limit do
        buffer = string.format('%s["%s",%d,"%s",%s],', buffer, logData[i][1], logData[i][2], logData[i][3], logData[i][4])
    end
    return string.sub(buffer, 1, -2).."]"
end

-- Load the first 100 entries of a logData to the screen input in 1000 characters chunks
function loadScreenData()
    comState = "load"
    if #logData > 0 then
        local limit = math.min(100, #logData)
        loadBuffer = encodeLogData(limit)

        -- Send the first chunk of 1000 characters
        local max = math.ceil(loadBuffer:len()/1000)
        local screenData = string.format("load,1,%s %s", max, string.sub(loadBuffer, 1, 1000))
        screen.setScriptInput(screenData)

        system.print(string.format("Sending %s characters with %s %s to the screen", #loadBuffer, limit, #logData > 1 and  "Entries" or "Entry"))
    else
        screen.setScriptInput("load,1,1 []")
    end
end

-- Save a logData/string to "logData" key in multiple databanks
function saveData(str)
    local str = str or false
    if #logData > 0 or str ~= false then
        -- Clear all Databanks
        for k,v in pairs(dataBanks) do
            v.setStringValue("logData", "")
        end

        -- Type Check
        local buffer = ""
        if str == false then
            buffer = encodeLogData()
        else
            buffer = str
        end

        -- Save to DataBanks
        if buffer ~= "" then
            local chunkSize = 10000
            local max = math.ceil(buffer:len()/chunkSize)
            if max > #dataBanks then
                local index = string.match(buffer, '^.*()%["') -- Find the last instance of [" in the buffer

                system.print("Not egnough space, Deleting Last Entry")
                system.print(string.sub(buffer, index, -2))

                saveData(string.sub(buffer, 1, index-2).."]")
            else
                for i=1, max do
                    dataBanks[i].setStringValue("logData", string.sub(buffer, 1+chunkSize*(i-1), chunkSize+chunkSize*(i-1)))
                end
                if str then
                    system.print(string.format("Saved %s characters to Databank%s", #buffer, #dataBanks > 1 and  "s" or ""))
                else
                    system.print(string.format("Saved %s characters with %s %s to Databank%s", #buffer, #logData, #logData > 1 and  "Entries" or "Entry", #dataBanks > 1 and  "s" or ""))
                end
            end
        end
    else
        system.print("skipped atempt to save no data")
    end
end

-- return a table from "logData" in multiple databanks
function loadData()
    local buffer = ""
    for k,v in pairs(dataBanks) do
        -- Import old data from before v3.0
        if v.hasKey("latest") == 1 then
            buffer = v.getStringValue("latest")
            v.clear()
            if k == 1 then
                dataBanks[1].setStringValue("screenVer", version)
            end
            system.print(string.format("Old data Detected, importing %s characters", #buffer))
            break
        end

        if v.hasKey("logData") == 1 then
            buffer = buffer..v.getStringValue("logData")
        end
    end

    -- Use pattern matching to get a logData table from the buffer string
    local newData = {}
    if buffer ~= "" then
        local stringtoboolean = { ["true"]=true, ["false"]=false }
        for name, id, time, known in string.gmatch(buffer, '%[(%b""),(%d+),"([%d/ :]+)",(%a+)%]') do
            table.insert(newData, #newData+1, {string.sub(name, 2, -2), tonumber(id), time, stringtoboolean[known]})
        end
        system.print(string.format("Loaded %s characters with %s Entries from Databank%s", #buffer, #newData, #dataBanks > 1 and  "s" or ""))
    else
        system.print("No data loaded")
    end
    return newData
end

-- Get curent time in dd/mm/yy h:m:s
function getTime(hoursOffset)
    local hoursOffset = hoursOffset or 0
    local unixTime = math.floor(system.getUtcTime()) + (3600*hoursOffset) --(Oct. 1, 2017, at 00:00) //1506729600 //1506816000

    local hours = math.floor(unixTime / 3600 % 24)
    local minutes = math.floor(unixTime / 60 % 60)
    local seconds = math.floor(unixTime % 60)

    local unixTime = math.floor(unixTime / 86400) + 719468
    local era = math.floor(unixTime / 146097)
    local doe = math.floor(unixTime - era * 146097)
    local yoe = math.floor((doe - doe / 1460 + doe / 36524 - doe / 146096) / 365)
    local year = math.floor(yoe + era * 400)
    local doy = doe - math.floor((365 * yoe + yoe / 4 - yoe / 100))
    local mp = math.floor((5 * doy + 2) / 153)

    local day = math.ceil(doy - (153 * mp + 2) / 5 + 1)
    local month = math.floor(mp + (mp < 10 and 3 or -9))
    local year = year + (month <= 2 and 1 or 0)

    seconds = seconds < 10 and  "0" .. seconds or seconds
    minutes = minutes < 10 and  "0" .. minutes or minutes
    hours = hours < 10 and  "0" .. hours or hours
    day = day < 10 and  "0" .. day or day
    month = month < 10 and  "0" .. month or month
    year = string.sub(year, 3)

    return (string.format("%s/%s/%s %s:%s:%s",day, month, year, hours, minutes, seconds))
end

-----------------
-- Screen Code --
-----------------

-- Update screen code if the version get changed
function loadScreenCode()

    system.print("-----------------------------------------------")
    system.print(string.format("Updated screen version from %s to %s", dataBanks[1].getStringValue("screenVer"), version))
    system.print("-----------------------------------------------")

    dataBanks[1].setStringValue("screenVer", version)
    screen.setRenderScript([[
----------
-- INIT --
----------
local rx, ry = getResolution()
local layer = createLayer()
local front = createLayer()
local font = loadFont('FiraMono', 20)
local fontAH, fontDH = getFontMetrics(font)

-- Set default text color to red
setDefaultFillColor(layer, Shape_Text, 1, 0, 0, 1)

if not init then
    init = true
    data = {}
    buffer = ""
    comState = ""
end

-------------------
-- PB <-> Screen --
-- Communication --
-------------------
local input = getInput()
if input ~= "" then
    local instruction = {}
    local pos = string.find(input, " ")
    if pos == nil then pos=-1 end
    for word in string.gmatch(string.sub(input, 1, pos), "%w+") do
        table.insert(instruction, word)
    end
    local inputData = string.sub(input, pos+1)
    if instruction[1] == "load" then
        if inputData == "[]" then
            data = {}
        else
            local i = tonumber(instruction[2])
            local max = tonumber(instruction[3])

            buffer = buffer..inputData

            if i < max then
                setOutput(string.format("load,%s,%s ", math.floor(i+1), max))
            else
                -- Use pattern matching to return 'str' JSON data as a log table
                local tempData = {}
                local stringtoboolean = { ["true"]=true, ["false"]=false }
                for name, id, time, known in string.gmatch(buffer, '%[(%b""),(%d+),"([%d/ :]+)",(%a+)%]') do
                    table.insert(tempData, #tempData+1, {string.sub(name, 2, -2), tonumber(id), time, stringtoboolean[known]})
                end
                if tempData ~= nil then
                    data = tempData
                end
                buffer = ""
                comState = nil
                setOutput("end")
            end
        end
    end
end
----------------
-- Player Log --
----------------
for k, v in ipairs(data) do
    -- How many fit vertically
    local fit = math.floor(ry/fontAH)
    if k > fit*2 then break end

    local text = string.format('%s %s %s', v[3], v[1], v[2])
    local textX = 5+math.floor((k-1)/fit)*rx/2
    local textY = fontAH*(((k-1)%fit)+1)

    if v[4] then setNextFillColor(layer, 0, 1, 0, 1) end
    addText(layer, font, text, textX, textY)
end

----------------
-- Info Panel --
----------------
local spacing, border = 12, 5
local fontSmall = loadFont('FiraMono', spacing)
local text = {
    'Location: "]]..location..[["',
    "Player Logger v]]..version..[["
}
-- find the string with the most width
local width, height = 0, #text*spacing
for k,v in pairs(text) do
    local curWidth, height = getTextBounds(fontSmall, v)
    if curWidth > width then width = curWidth end
end
local x, y = rx-width-border*2, ry-height-border*2
-- Draw text / box
for k,v in pairs(text) do
    setNextFillColor(front, 1, 0, 0, 1)
    setNextTextAlign(front, AlignH_Center, AlignV_Middle)
    setNextFillColor(front, 1, 1, 1, 1)
    addText(front, fontSmall, v, x+width/2, y + (k-1)*spacing + spacing/2)
end
setNextStrokeColor(front, 1, 1, 1, 1)
setNextStrokeWidth(front, 1)
setNextFillColor(front, 0, 0, 0, 1)
addBoxRounded(front, x-border, y-border, width+border*2, height+border*2, 1)
        ]])
end

---------------------
-- Seting up Slots --
---------------------

-- Loop trough slots and get DataBank(s), screen and switch
dataBanks = {}
screen = nil
switch = nil
for slot_name, slot in pairs(unit) do
    if type(slot) == "table" and type(slot.export) == "table" and slot.getElementClass then
        if slot.getClass():lower() == 'databankunit' then
            slot.slotname = slot_name
            table.insert(dataBanks,slot)
        end
        if slot.getClass():lower() == 'screenunit' then
            screen = slot
        end
        if slot.getClass():lower() == 'manualswitchunit' then
            switch = slot
        end
    end
end
local flag = false
if #dataBanks == 0 then
    system.print("No Databank Detected, add one for the PlayerLogger to work")
    flag = true
else
    --sorting dataBanks by slotname to be sure the data isnt scrambled
    table.sort(dataBanks, function(a,b) return a.slotname < b.slotname end)
    system.print(string.format("%d Databank%s Connected", #dataBanks, #dataBanks > 1 and  "s" or ""))
end
if screen == nil then
    system.print("No Screen Detected, add one for the PlayerLogger to work")
    flag = true
else
    system.print("Screen Connected")
end
if switch == nil then
    system.print("No Manual Switch Detected, add one for the PlayerLogger to work")
    flag = true
else
    system.print("Manual Switch Connected")
end

if flag then
    unit.exit()
    switch.deactivate()
    return
end

----------
-- Code --
----------

screen.activate()
screen.setScriptInput("")
screen.clearScriptOutput()

if dataBanks[1].getStringValue("screenVer") ~= version then
    loadScreenCode()
end

logData = loadData()

-- Convert knownUser CSV to a table
playerData = database.getPlayer(player.getId())
if knownUser ~= "" then
    for name in string.gmatch(knownUser, "([^,]+)") do
        if playerData.name == name then
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
            if database.getOrganization(v).name == name then
                known = true
            end
        end
    end
end

-- If explicit PB activation
if unit.getSignalIn('in')==0 then
    system.print("-----------------------------------------------")
    if known then
        system.print("Debug enabled, type 'help' to get a list of commands")
        system.print("-----------------------------------------------")
        loadScreenData()
        return
    else
        system.print("Add yourself to the knownUser list on line 7 of unit.start()")
        system.print("-----------------------------------------------")
    end
end

if (known and ignoreKnown) == false then

    if #logData > 0 then
        if playerData.id == logData[1][2] then
            system.print(string.format("Deleting repeating entry of %s", logData[1][1]))
            table.remove(logData, 1)
        elseif mergeLastDay then
            local limit = #logData > mergeLastDayCount and mergeLastDayCount or #logData
            local pastTimeString = string.match(getTime(-24), '([%d/]+)')
            for i=1, limit do
                if playerData.id == logData[i][2] then
                    local timeString = string.match(logData[i][3], '([%d/]+)')
                    if timeString == pastTimeString then
                        system.print(string.format("Deleting past entry of %s from %s", logData[i][1], timeString))
                        table.remove(logData, i)
                        break
                    end
                end
            end
        end
    end

    table.insert(logData, 1, {playerData.name, playerData.id, getTime(), known})
    saveData()
end

loadScreenData()

exit = true
