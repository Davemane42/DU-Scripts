local layer = createLayer()
local rx, ry = getResolution()
local time = getTime()

local version = "1.2"
local location = "Lobby"

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
                
