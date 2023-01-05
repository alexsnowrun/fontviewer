FontViewer = FontViewer or {Fonts = {}}
FontViewer._OLDCREATEFONT = FontViewer._OLDCREATEFONT or surface.CreateFont

local sortorder = { -- Sorts fontdata table for view in order that provided below
    "font",
    "size",
    "weight",
    "blursize",
    "scanlines",
    "extended",
    "antialias",
    "shadow",
    "symbol",
    "italic",
    "underline",
    "strikeout",
    "rotary",
    "outline",
    "additive",
}

function surface.CreateFont(name, fontdata)
    FontViewer._OLDCREATEFONT(name, fontdata)
    local location = string.match(string.Split(debug.traceback(),"\n")[3],"	(.*):")
    
    local tb = {Fontdata = fontdata, ViewFontdata = {}}
    tb.Location = location

    -- Table for preview text
    for i = 1, #sortorder do
        if fontdata[sortorder[i]] then
            tb.ViewFontdata[#tb.ViewFontdata+1] = sortorder[i]..": "..tostring(fontdata[sortorder[i]])
        end
    end

    if FontViewer.Fonts[name] then
        MsgC(Color(255,0,0), "[FontViewer]", color_white, " Recreated font '"..name.."' in "..location.."\n")
    else
        MsgC(Color(255,0,0), "[FontViewer]", color_white, " Created font '"..name.."' in "..location.."\n")
    end

    FontViewer.Fonts[name] = tb
end
