local layer = createLayer()
local rx, ry = getResolution()
local time = getTime()
local input = getInput()

local version = "2.1"
local location = "ZONE 1"
local colorHash = 2262
local standbyTextColor = {192, 203, 220}
local standbyBackgroundColor = {24, 20, 37}
local knownTextColor = {192, 203, 220}
local knownBackgroundColor = {24, 20, 37}
local unknownTextColor = {192, 203, 220}
local unknownBackgroundColor = {255, 0, 0}
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
