local _, Addon = ...
local locale = Addon:GetLocale()
local Lists = Addon.Features.Lists
local UI = Addon.CommonUI.UI
local ListEvents = Addon.Systems.Lists.ListEvents
local ListsTab = {}

--[[ Helper function for debugging ]]
local function debug(...)
    local message = ""
    for _, arg in ipairs({...}) do
        message = message .. tostring(arg)
    end
    Addon:Debug("liststab", message)
end

--[[ Handle loading the list ]]
function ListsTab:OnLoad()
    self.feature = Addon:GetFeature("Lists")

    Addon:RegisterCallback(ListEvents.ADDED, self, function()
            self.lists:Rebuild()
        end)
        
    Addon:RegisterCallback(ListEvents.REMOVED, self, function()
        self.lists:Rebuild()
    end)
end

--[[ Called when the lists tab is activated ]]
function ListsTab:OnActivate()
    self.lists:EnsureSelection()
end

function ListsTab:OnDeactivate()
end

--[[ Retrieve the currently defined lists ]]
function ListsTab:GetCategories()
    return Addon:GetLists()
end

--[[ Called to display the contents of the list ]]
function ListsTab:ShowList()
    local selected = self.lists:GetSelected()
    if (selected) then
        self.items:SetList(selected)
    end
end

function ListsTab:CreateList()
    Addon.Features.Lists.ShowEditDialog()
end

Addon.Features.Lists.ListsTab = ListsTab