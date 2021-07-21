--[[
This script is useless due to ingame limitation. cant get further then ~100m away using acquireStorage
still have some useful exemple code if you wanna look

for instalation you just need to connect the programming board to a container / hub
paste the appropriate code in the filters and voila!
]]
--------------------------------------------

--------------- unit.start() ---------------

json = require ("dkjson")

function formatNumber(number)
    local text = string.reverse(string.reverse(tostring(number)):gsub("(...)", "%1 "))
    if string.sub(text, 1, 1) == " " then
        text = string.sub(text, 2, -1)
    end
    return text
end

containerTbl = ""
tablelist = {}

system.print("Ore Display v1.0")

container.acquireStorage()

unit.setTimer("update",30)

--------------------------------------------

-------- container.acquireStorage() --------

local oreTbl = {}
for i, v in pairs(containerTbl) do
    table.insert(oreTbl, {["name"]=v.name, ["quantity"]=math.floor(v.quantity)})
end

html = ""
for i, v in ipairs(oreTbl) do
    if ores[v.name] ~= nil then
        html = html..[[
    <div class ="element">
        <img src='resources_generated/iconsLib/materialslib/]]..ores[v.name]..[[' class="image">
        <text>]]..formatNumber(v.quantity)..[[L</text>
    </div>
]]
    end
end

system.showScreen(1)

html = [[
<style>
    .text {
    font-size:4vh;
    line-height:4vh;
    font-weight:bold;
    font-family:Montserrat;
    color:white;
    -webkit-text-stroke: 1.5vh black;
    width: 36vh;
    text-allign: right:
    }

    .element {
    width: 26vh;
    text-align:right;
    }

    .image {
    width:4vh;
    height:4vh;
    left:0;
    position:absolute;
    }

</style>

<ul class="text">
]]..html..[[
</ul>
]]

system.setScreen(html)

--------------------------------------------

------------- library.start() --------------

ores = {
    ["Bauxite"] = "aluminium_ore.png",
    ["Coal"] = "CarbonOre.png",
    ["Hematite"] = "iron_ore.png",
    ["Quartz"] = "silicon_ore.png",
    ["Natron"] = "SodiumOre.png",
    ["Malachite"] = "copper_ore.png",
    ["Chromite"] = "ChromiumOre.png",
    ["Limestone"] = "CalciumOre.png",
    ["Garnierite"] = "NickelOre.png",
    ["Pyrite"] = "SulfurOre.png",
    ["Acanthite"] = "SilverOre.png",
    ["Petalite"] = "LithiumOre.png",
    ["Cobaltite"] = "CobaltOre.png",
    ["FluorineOre"] = "FluorineOre.png",
    ["Gold nuggets"] = "gold_ore.png",
    ["Kolbeckite"] = "scandium_ore.png",
    ["Columbite"] = "NiobiumOre.png",
    ["Rhodonite"] = "manganese_ore.png",
    ["Illmenite"] = "TitaniumOre.png",
    ["Vanadinite"] = "VanadiumOre.png",
    ["Thoramine"] = "env_thoramine-ore_001_icon.png"
}
