local _, Addon = ...
local PropertyItem = {}
local HeaderItem = {}
local Colors = Addon.CommonUI.Colors

-- +Load the frame
function PropertyItem:OnLoad()
    self.value:SetWordWrap(true)
    self:RegisterForClicks("LeftButton", "RightButton")
end

-- Called when the model has cahnged
function PropertyItem:OnModelChange(model)
    self.name:SetText(model.Name)

    local valueText = "nil"
    local valueColor = Colors.DISABLED_TEXT
    local valueType = type(model.Value)

    if (valueType == "string") then
        valueText = "\"" .. model.Value .. "\""
        valueColor = Colors.GREEN_FONT_COLOR
    elseif (valueType == "boolean" and not model.Value) then
        valueText = tostring(model.Value)
        valueColor = Colors.EPIC_PURPLE_COLOR
    elseif (valueType == "boolean" and model.Value) then
        valueText = tostring(model.Value)
        valueColor = Colors.HEIRLOOM_BLUE_COLOR
    elseif (valueType == "number") then
        valueText = tostring(model.Value)
        valueColor = Colors.LEGENDARY_ORANGE_COLOR
    elseif (model.Value ~= nil) then
        valueText = tostring(model.Value)
        valueColor = Colors.COMMON_GRAY_COLOR
    end

    self.value:SetText(valueText)
    self.value:SetTextColor(valueColor:GetRGBA())
end

-- Called to get the documentation for this property
function PropertyItem:GetDocumentation()
    local model = self:GetModel()
    local doc = Addon.ScriptReference.ItemProperties[model.Name]

    if (doc) then
        local text = doc;
        if (type(doc) == "table") then
            text = doc.Text
        end
        
        return text
    end
end

-- Called when our size has changed
function PropertyItem:OnSizeChanged()
    local max = 0
    local padding = self.PaddingY or 0
    for _, child in pairs({self:GetRegions()}) do
        if (child ~= self.hilite) then
            child:SetHeight(0)
            local h = child:GetHeight()
            if h > max then
                max = h
                child:SetHeight(h)
            end
        end
    end

    self:SetHeight(max + padding)
end

-- Called to ge the intert text (can be nil)
function PropertyItem:GetInsertText(button, modifier)
    local model = self:GetModel()
    return nil
end

-- Called when the mouse enters the item
function PropertyItem:OnEnter()
    self.hilite:Show()

    local model = self:GetModel()
    local documentation = self:GetDocumentation()

    if type(documentation) == "string" then

        GameTooltip:SetOwner(self, "ANCHOR_NONE")
        GameTooltip:AddLine(model.Name, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
        GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -4)

        if (type(documentation) == "string") then
            GameTooltip:AddLine(documentation, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
            --GameTooltip:AddLine(" ")
        end

        --[[GameTooltip:AddDoubleLine("Left-click", item:GetInsertText("LeftButton"),
            YELLOW_FONT_COLOR.r, YELLOW_FONT_COLOR.g, YELLOW_FONT_COLOR.b,
            GREEN_FONT_COLOR.r,  GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
        GameTooltip:AddDoubleLine("Alt + Left-cLick", item:GetInsertText("LeftButton", "ALT"),
            YELLOW_FONT_COLOR.r, YELLOW_FONT_COLOR.g, YELLOW_FONT_COLOR.b,
            GREEN_FONT_COLOR.r,  GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
        GameTooltip:AddDoubleLine("Right-cLick", item:GetInsertText("RightButton"),
            YELLOW_FONT_COLOR.r, YELLOW_FONT_COLOR.g, YELLOW_FONT_COLOR.b,
            GREEN_FONT_COLOR.r,  GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
        GameTooltip:AddDoubleLine("Alt + Right-click", item:GetInsertText("RightButton", "ALT"),
            YELLOW_FONT_COLOR.r, YELLOW_FONT_COLOR.g, YELLOW_FONT_COLOR.b,
            GREEN_FONT_COLOR.r,  GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)]]

        GameTooltip:Show()
    end
end

-- Called when trhe mouse leves the frame
function PropertyItem:OnLeave()
    self.hilite:Hide()
    if (GameTooltip:GetOwner() == self) then
        GameTooltip:Hide()
    end
end

-- Called when the item is clicked
function PropertyItem:OnMouseDown(button)
    local model = self:GetModel()
end

-- Called when the model has cahnged
function HeaderItem:OnModelChange(model)
    self.name:SetText(model.Name)
end

Addon.Features.ItemDialog.PropertyItem = PropertyItem
Addon.Features.ItemDialog.HeaderItem = HeaderItem