local _, Addon = ...
local locale = Addon:GetLocale()
local ItemDialog = {}

function ItemDialog:GetName()
    return "ItemDialog"
end

function ItemDialog:GetDependencies()
    return { "rules", "system:itemproperties" }
end

--[[ Initialize the list feature ]]
function ItemDialog:OnInitialize()
end


Addon.Features.ItemDialog = ItemDialog