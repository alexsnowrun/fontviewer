
local function OpenFontsPreview()
    if FontViewer._MF then
        return
    end
    local mf = vgui.Create("DFrame")
    mf:SetTitle("Available Fonts")
    mf:SetSize(400, 600)
    mf:Center()
    mf:MakePopup()
    mf:InvalidateParent(true)

    mf:SetSizable( true )
    mf:SetMinWidth( mf:GetWide() )
    mf:SetMinHeight( mf:GetTall() )

    FontViewer._MF = mf

    function mf:OnRemove()
        FontViewer._MF = nil
    end

    local mp = mf:Add("Panel")
    mp:Dock(FILL)
    mp:InvalidateParent(true)
    local entrypan = mp:Add("Panel")
    entrypan:DockMargin(0, 0, 0, 8)
    entrypan:Dock(TOP)
    entrypan:SetTall(20)
    entrypan:SetWide(mp:GetWide())

    local entrylbl = entrypan:Add("DLabel")
    entrylbl:SetText("Test string:")
    entrylbl:SizeToContentsX()
    entrylbl:DockMargin(0, 0, 4, 0)
    entrylbl:Dock(LEFT)
    local entry = entrypan:Add("DTextEntry")
    entry:SetValue("Test string")
    entry:Dock(FILL)
    entry:InvalidateParent(true)

    entry:SetWide(entrypan:GetWide() - entry:GetPos())

    local scp = mp:Add("DScrollPanel")
    scp:Dock(FILL)
    scp:InvalidateParent(true)

    scp:SetTall(mp:GetTall() - scp:GetY())

    local function fontpaint(self, w, h)
        draw.RoundedBox(4, 2, 0, w, h, self:IsHovered() and (self:IsDown() and Color(10,10,10,200) or Color(40,40,40,160)) or Color(0,0,0,160))
        draw.SimpleText(entry:GetValue(), self.PreviewFont, 8, 0)
        surface.SetFont(self.PreviewFont)
        local _, pr_h = surface.GetTextSize(entry:GetValue())
        pr_h = pr_h + 4
        draw.SimpleText("Name: "..self.PreviewFont, "DermaDefault", 8, pr_h, Color(220,220,220))
        pr_h = pr_h + 13
        draw.SimpleText("Lua Path: "..self.PreviewLocation, "DermaDefault", 8, pr_h, Color(220,220,220))
        pr_h = pr_h + 26

        for i = 1, #self.PreviewData do
            draw.SimpleText(self.PreviewData[i], "DermaDefault", 8, pr_h, Color(220,220,220))
            pr_h = pr_h + 13
        end

        self:SetTall(pr_h + 6)
    end

    for i,v in pairs(FontViewer.Fonts) do
        local fontspan = vgui.Create("DButton")
        fontspan:DockMargin(8, 0, 8, 8)
        fontspan:Dock(TOP)
        fontspan:SetTall(120)
        fontspan:SetText("")
        fontspan:InvalidateParent(true)
        fontspan:SetTooltip("LMB: Copy lua font name\nRMB: Copy font lua path")
        fontspan.PreviewFont = i
        fontspan.PreviewLocation = v.Location
        fontspan.PreviewData = v.ViewFontdata
        
        fontspan.Paint = fontpaint

        function fontspan:DoClick()
            SetClipboardText(self.PreviewFont)
        end

        function fontspan:DoRightClick()
            SetClipboardText(self.PreviewLocation)
        end

        scp:AddItem(fontspan)
    end
end

concommand.Add("fontviewer", OpenFontsPreview, nil, "Opens font viewer menu")