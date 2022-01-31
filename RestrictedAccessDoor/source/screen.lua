local rx, ry = getResolution()
local layer = createLayer()
local size = 100
local font = loadFont('FiraMono', size)
local version = "1.0"

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
