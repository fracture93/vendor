local _, Addon = ...
local locale = Addon:GetLocale()
local Dialogs = Addon.Features.Dialogs
local UI  = Addon.CommonUI.UI
local EditParamDialog = Mixin({}, CallbackRegistryMixin)

local DialogMode = {
    VIEW = 1,
    EDIT = 2,
    CREATE = 3,
}

local ParameterType = {
    NUMBER = "number",
    BOOLEAN = "boolean",
    STRING = "string"
}

--[[ Gets the default value for the specified type ]]
local function getDefaultForType(type)
    if (type == ParameterType.BOOLEAN) then
        return false
    elseif (type == ParameterType.NUMBER) then
        return 0
    elseif (type == ParameterType.STRING) then
        return ""
    end

    assert(false, "Unknown parameter type :: " .. tostring(type))
end

--[[ Compute the default value of a rule paramter 
TODO: move to rules system ]]
local function getDefault(param)
    local default = param.Default
    if (type(default) == "boolean") then
        return default
    elseif (type(default) == "number") then
        return default
    elseif (type(default) == "string") then
        return default
    elseif (type(default) == "function") then
        return default()
    end

    return getDefaultForType(param.Type)
end


local ParameterEditor = Mixin({}, CallbackRegistryMixin)

function ParameterEditor:Init(param)
    CallbackRegistryMixin.OnLoad(self)
    CallbackRegistryMixin.GenerateCallbackEvents(self, { "OnChanged" })
    self.dirty = false

    if (param) then
        self.new = false
        self.name = param.Name
        self.key = param.Key
        self.default = getDefault(param)
        self.type = param.Type
    else
        self.new = true
        self.name = locale["EDITPARAM_DEFAULT_NAME"]
        self.key = locale["EDITPARAM_DEFAULT_SCRIPTNAME"]
        self.default = getDefaultForType(ParameterType.NUMBER)
        self.type = ParameterType.NUMBER
    end
end

function ParameterEditor:GetName()
    return self.name
end

function ParameterEditor:SetName(name)
    if (self.name ~= name) then
        self.name = name
        self.dirty = true
        self:TriggerEvent("OnChanged", self, "name")
    end
end

function ParameterEditor:GetKey()
    return self.key
end

function ParameterEditor:SetKey(key)
    if (self.key ~= key) then
        self.key = key
        self.dirty = true
        self:TriggerEvent("OnChanged", self, "key")
    end
end

function ParameterEditor:GetDefault()
    return tostring(self.default)
end

function ParameterEditor:SetDefault(default)
    if (self.default ~= default) then
        self.default = default
        self.dirty = true
        self:TriggerEvent("OnChanged", self, "default")
    end
end

function ParameterEditor:GetType()
    return self.type
end

function ParameterEditor:SetType(type)
    print("setType", type)
    --@debug@
    local valid = false
    for k, v in pairs(ParameterType) do
        if (v == type) then
            valid = true
            break
        end
    end
    assert(valid, "Expected a valid rule type got :: ", tostring(type))
    --@end-debug@

    if (self.type ~= type) then
        self.type = type
        self.dirty = true
        self:TriggerEvent("OnChanged", self, "type")
    end
end

--[[ Determine if the parameter is new ]]
function ParameterEditor:IsNew()
    return self.new
end

--[[ Determine if we can save the parameter ]]
function ParameterEditor:CanSave()
    if (type(self.name) ~= "string" or string.len(self.name) == 0) then
        return false
    end

    if (type(self.key) ~= "string" or string.len(self.key) == 0) then
        return false
    end

    if (self.default == nil) then
        return false
    end

    return self.dirty or self.new
end

--[[ Retrieve the value of the parameter being edited ]]
function ParameterEditor:GetValue()

    return {
            Name = self.name,
            Key = string.upper(self.key),
            Default = self.default,
            Type = self.type
        }
end

--[[ static : Create a new editor ]]
function ParameterEditor.Create(param)
    local editor = CreateFromMixins(ParameterEditor)
    editor:Init(param)
    return editor
end

--[[ Called to initialize the edit param dialog ]]
function EditParamDialog:OnInitDialog(dialog, readonly, param, currentValue)
    CallbackRegistryMixin.OnLoad(self)
    CallbackRegistryMixin.GenerateCallbackEvents(self, { "OnValidate", "OnClose", "OnSave", "OnCreate" })

    self.editor = ParameterEditor.Create(param)
    self.readonly = readonly

    self.paramType:AddChips({
        { id=ParameterType.BOOLEAN, text="EDITPARAM_BOOLEAN_LABEL", tooltip="EDITPARAM_BOOLEAN_HELP" },
        { id=ParameterType.NUMBER, text="EDITPARAM_NUMBER_LABEL", tooltip="EDITPARAM_NUMBER_HELP" },
        { id=ParameterType.STRING, text="EDITPARAM_STRING_LABEL", tooltip="EDITPARAM_STRING_HELP" }
    })

    self.create = true
    self.name:SetText(self.editor:GetName())
    self.key:SetText(self.editor:GetKey())
    self.default:SetText(self.editor:GetDefault())
    self:SetType(self.editor:GetType())

    if (currentValue ~= nil) then
        self.current:SetText(tostring(currentValue))
    end

    UI.Enable(self.name, not readonly)
    UI.Enable(self.key, not readonly and self.editor:IsNew())
    UI.Enable(self.default, not readonly)
    UI.Enable(self.paramType, not readonly)
    UI.Enable(self.current, false)

    if (not readonly) then
        self.editor:RegisterCallback("OnChanged", GenerateClosure(self.Update, self), self)
        self:Update()
    end
end

--[[ Handle closing the dialog ]]
function EditParamDialog:OnClose()
    self:TriggerEvent("OnClose", self)
end

--[[ Handle setting the type of the parameter ]]
function EditParamDialog:SetType(paramType)
    local type = {}
    if (paramType == "number" or paramType == "numeric") then
        type.number = true
    elseif (paramType == "boolean") then
        type.boolean = true
    elseif (paramType == "string") then
        type.string = true
    else
        type.boolean = true
    end
    self.paramType:SetSelected(type)
end

function EditParamDialog:OnNameChanged(text)
    self.editor:SetName(text)
end

function EditParamDialog:OnKeyChanged(text)
    self.editor:SetKey(text)
end

function EditParamDialog:OnDefaultChanged(text)
    -- todo verify the default is appropriate
    self.editor:SetDefault(text)
end

function EditParamDialog:OnParamTypeChange()
    local selected = self.paramType:GetSelected()
    for type, state in pairs(selected) do
        if (state) then
            self.editor:SetType(type)
            break
        end
    end
end

--[[ Called to handle save ]]
function EditParamDialog:OnSave()
end

--[[ Handle creating a parameter ]]
function EditParamDialog:OnCreate()
    local param = self.editor:GetValue()
    Addon:DebugForEach("dialogs", param)
end

--[[ Called to handle updates ]]
function EditParamDialog:Update()
    local canSave = self.editor:CanSave()
    self:SetButtonState({
        cancel = true,
        create =  { show = true, enabled = canSave },
        save = { show = true, enabled = canSave },
    })
end

--[[ static : Create a new edit param dialog ]]
function EditParamDialog.Create(mode, param, currentValue)
    local buttons = {}

    -- Determine what buttons we have
    if (mode == DialogMode.EDIT) then
        buttons.save = { label = "EDITPARAM_SAVE_LABEL", handler = "OnSave" }
        buttons.cancel = { label = "EDITPARAM_CANCEL_LABEL", handler = "Hide", default = true, order = 1 }
    elseif (mode == DialogMode.VIEW) then
        buttons.close = { label = "EDITPARAM_CLOSE_LABEL", handler="Hide" }
    elseif (mode == DialogMode.CREATE) then
        buttons.create = { label = "EDITPARAM_CREATE_LABEL", handler = "OnCreate" }
        buttons.cancel = { label = "EDITPARAM_CANCEL_LABEL", handler = "Hide", default = true, order = 1 }
    end

    local dialog = UI.Dialog("EDIT_RULE_PARAMETER", "Rule_EditParamDialog", EditParamDialog, 
            buttons, mode == DialogMode.VIEW, param, currentValue)

    dialog:Show()
    dialog:Raise()
    return dialog
end

--[[ Shows the read/write edit param dialog ]]
function Dialogs:EditRuleParam(param, currentValue)
    assert(type(param) == "table", "Expected a valid parameter to edit")

    return EditParamDialog.Create(DialogMode.EDIT, param, currentValue)
end

--[[ Shows the read only dialog ]]
function Dialogs:ViewRuleParam(param, currentValue)
    assert(type(param) == "table", "Expected a valid parameter to view")

    return EditParamDialog.Create(DialogMode.VIEW, param, currentValue)
end

--[[ Show the create parameter dialog ]]
function Dialogs:CreateRuleParam()
    return EditParamDialog.Create(DialogMode.CREATE)
end