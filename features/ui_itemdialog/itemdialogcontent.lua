local AddonName, Addon = ...
local locale = Addon:GetLocale()
local UI = Addon.CommonUI.UI
local Info = Addon.Systems.Info
local ItemDialogContent = {}

local function debugp(msg, ...) Addon:Debug("itemdialog", msg, ...) end


function ItemDialogContent:OnInitDialog(dialog)
    debugp("Initialize itemdialog dialog")
    self:SetButtonState({ close = true })
    self.itemInfo = Addon:GetSystem("ItemProperties")
end

function ItemDialogContent:ON_CURSOR_CHANGED()
    local item = C_Cursor.GetCursorItem()
    if item then
        self.current = self.itemInfo:GetItemProperties(item)
        self.item:SetItem(self.current.Id, false)
        self.properties:Rebuild()
    end
end

function ItemDialogContent:OnShow()
    self.current = nil

    local item = C_Cursor.GetCursorItem()
    if item then 
        self.current = self.itemInfo:GetItemProperties(item)
        self.item:SetItem(self.current.Id, false)
        self.properties:Rebuild()
    end
end

function ItemDialogContent:OnHide()
end

function ItemDialogContent:OnItemChanged()
    self.current = self.itemInfo:GetItemPropertiesFromItem(self.item)
    self.properties:Rebuild()
end

function ItemDialogContent:GetItem()
    if self.current then
        return self.current
    end

    return nil
end

function ItemDialogContent:GetItemProperties()
    local models = {}
    local item = self:GetItem()
    
    if item then
        if type(item) == "table" then
            local categories = {}
            for _, name in ipairs(self.itemInfo:GetPropertyCategories()) do
                table.insert(categories, { Name = name, Items = {} })
            end

            local findCategory = function(name)
                for _, c  in ipairs(categories) do
                    if c.Name == name then
                        return c
                    end
                end
                 return nil
            end

            for name, value in pairs(item) do

                local isApplicable = true
                local hideType = 0

                local defined = self.itemInfo:IsPropertyDefined(name)
                if not defined then
                    Addon:Debug("items", "Undefined property: " .. name)
                end

                if defined then
                    -- Hide has 3 states, never hidden, always hidden, and hidden if default
                    hideType = self.itemInfo:IsPropertyHidden(name)

                    -- Two types of applicability:
                    -- 1) parent is specified and is false
                    -- 2) conditional hide is specified and it is the default value
                    -- Property is considered non-applicable if either of these are true.

                    -- If property has a parent, it is not applicable unless the parent
                    -- has a non-false value.

                    local parent = self.itemInfo:GetPropertyParent(name)
                    if parent and not item[parent] then
                        -- Parent is false, this is not applicable
                        isApplicable = false
                    end

                    -- Conditional hide state
                    if hideType == 2 then
                        local default = self.itemInfo:GetPropertyDefault(name)
                        if value == default then
                            isApplicable = false
                        end
                    end
                end

                -- TODO: add setting to show non-applicable values
                -- This effectively would override the applicability test, but not the
                -- always-hidden test.

                -- TODO: Add debug setting to override to show all properties regardless
                -- of applicability or hide state.
                local category = findCategory(self.itemInfo:GetPropertyCategory(name))
                if (hideType ~= 1) and isApplicable and category ~= nil then
                    table.insert(category.Items,  { Name = name, Value = value })
                end
            end

            for _, category in ipairs(categories) do
                if table.getn(category.Items) ~= 0 then
                    table.insert(models, { Name = category.Name, Header = true })
                    table.sort(category.Items, function(a, b) return a.Name < b.Name end)
                    for _, model in ipairs(category.Items) do
                        table.insert(models, model)
                    end
                end
            end
        else
            debugp("Unable to get properties for item :: %s", item:GetItemID())
        end
    end

    return models
end

function ItemDialogContent:CreatePropertyItem(model)
    if model.Header then
        return Mixin(CreateFrame("Frame", nil, self.properties, "ItemDialog_ItemCategory"), Addon.Features.ItemDialog.HeaderItem)        
    else
        return Mixin(CreateFrame("Frame", nil, self.properties, "ItemDialog_ItemProperty"), Addon.Features.ItemDialog.PropertyItem)
    end
end

--[[ Show the export dialog with the contents provided ]]
function Addon.Features.ItemDialog:ShowDialog()
    if not self.dialog then
        self.dialog = UI.Dialog("ITEMDIALOG_CAPTION", "ItemDialog_Content", ItemDialogContent, {
            { id="close", label = CLOSE, handler = "Hide" },
        })
    end

    self.dialog:Show()
    self.dialog:Raise()
end