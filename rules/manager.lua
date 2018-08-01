local Addon, L, Config = _G[select(1,...).."_GET"]()
local Package = select(2, ...);
Addon.RuleManager = {}
local RuleManager = Addon.RuleManager;
local RULE_TYPE_LOCKED_KEEP = 1
local RULE_TYPE_LOCKED_SELL = 2
local RULE_TYPE_KEEP = 3
local RULE_TYPE_SELL = 4

--[[===========================================================================
    | CreateRulesEngine:
    |   Create and initialize a RulesEngine object.
    =======================================================================--]]
function Addon:CreateRulesEngine(verbose)
    local rulesEngine = CreateRulesEngine(Addon.RuleFunctions, verbose);

    -- Check for extension functions
    if (Package.Extensions) then
        rulesEngine:AddFunctions(Package.Extensions:GetFunctions());
    end

    return rulesEngine;
end

--*****************************************************************************
-- Create a new RuleManager which is a container to manage rules and the
-- environment they run in.
--*****************************************************************************
function RuleManager:Create()
    local instance = setmetatable({ unhealthy = {} }, self);
    self.__index = self;

    -- Initialize the rule engine
    local rulesEngine = Addon:CreateRulesEngine(Config:GetValue("debugrules"));
    rulesEngine:CreateCategory(RULE_TYPE_LOCKED_KEEP, "<locked-keep>");
    rulesEngine:CreateCategory(RULE_TYPE_LOCKED_SELL, "<locked-sell>");
    rulesEngine:CreateCategory(RULE_TYPE_KEEP, Addon.c_RuleType_Keep);
    rulesEngine:CreateCategory(RULE_TYPE_SELL, Addon.c_RuleType_Sell);
    rulesEngine.OnRuleStatusChange:Add(
        function(what, categoryId, ruleId, message)
            if (what == "UNHEALTHY") then
                instance:CacheRuleStatus(ruleId);
            end
        end);
    instance.rulesEngine = rulesEngine;

    -- Subscribe to events we need to update our state when the definitions change
    -- we might have scrub rules, etc.
    Addon.Rules.OnDefinitionsChanged:Add(function() instance:Update(); end);
    Config:AddOnChanged(function() instance:Update(); end);
    instance:Update();

    return instance
end

--[[===========================================================================
    | CacheRuleStatus:
    |   Cache's the status of a rule, we have a table of rules which have
    |   reported errors.
    ========================================================================--]]
function RuleManager:CacheRuleStatus(ruleId)
    if (not ruleId) then
        self.unhealthy = {};
        if (self.rulesEngine) then
            for _, ruleStatus in ipairs(self.rulesEngine:GetRuleStatus()) do
                local _, id, status = unpack(ruleStatus);
                if (status == "ERROR") then
                    self.unhealthy[string.lower(id)] = true;
                end
            end
        end
    else
        self.unhealthy[string.lower(ruleId)] = true;
    end
end

--[[===========================================================================
    | CheckRuleHealth:
    |   Queries our cache for the specified rule and return false if it
    |   is unhealthy.
    ========================================================================--]]
function RuleManager:CheckRuleHealth(ruleId)
    if (self.unhealthy[string.lower(ruleId)]) then
        return false;
    end
    return true;
end

--[[===========================================================================
    | ApplyConfig:
    |   Queries the config to get the rules which should be enabled and then
    |   adds rules to the engine.
    |
    |   Note: The config determines the order of the rules with each category
    |         custom rules are blended in the list.
    ========================================================================--]]
function RuleManager:ApplyConfig(categoryId, ruleType)
    local config = Config:GetRulesConfig(ruleType);
    local rulesEngine = self.rulesEngine;
    if (config) then
        for _, entry in ipairs(config) do
            if (type(entry) == "string") then
                local ruleDef = Addon.Rules.GetDefinition(entry, ruleType);
                if (ruleDef) then
                    Addon:DebugRules("Adding rule '%s' [%s]", ruleDef.Id, ruleType);
                    rulesEngine:AddRule(categoryId, ruleDef);
                else
                    Addon:DebugRules("Rule '%s' [%s] was not found", entry, ruleType);
                end
            elseif ((type(entry) == "table") and (entry.rule)) then
                local ruleDef = Addon.Rules.GetDefinition(entry.rule, ruleType);
                if (ruleDef) then
                    Addon:DebugRules("Adding rule '%s' [%s]", ruleDef.Id, ruleType);
                    rulesEngine:AddRule(categoryId, ruleDef, entry);
                else
                    Addon:DebugRules("Rule '%s' [%s] was not found", entry.rule, ruleType);
                end
            else
                Addon:DebugRules("Unknown configuration entry found (%s)", type(entry));
            end
        end
    end
end

--[[===========================================================================
    | Update:
    |   Updates the internal state of the rules to reflect what the user
    |   has listed in the configuration.
    ========================================================================--]]
function RuleManager:Update()
    local rulesEngine = self.rulesEngine;

    self.unhealthy = {};
    rulesEngine:ClearRules();
    rulesEngine:SetVerbose(Config:GetValue("debugrules"));

    -- Step 1: We want to add all of the locked rules into the
    --         engine as those are always added independent of the config.
    for _, ruleDef in ipairs(Addon.Rules.GetLockedRules()) do
        Addon:DebugRules("Adding LOCKED rule '%s' [%s]", ruleDef.Id, ruleDef.Type);
        if (ruleDef.Type == Addon.c_RuleType_Sell) then
            rulesEngine:AddRule(RULE_TYPE_LOCKED_SELL, ruleDef);
        elseif (ruleDef.Type == Addon.c_RuleType_Keep) then
            rulesEngine:AddRule(RULE_TYPE_LOCKED_KEEP, ruleDef);
        else
            assert(false, "An unknown rule type was encountered: " .. ruleDef.Type);
        end
    end

    -- Step 2: Add the keep rules from our configuration
    self:ApplyConfig(RULE_TYPE_KEEP, Addon.c_RuleType_Keep);

    -- Step 3: Add the sell rules from our configuration
    self:ApplyConfig(RULE_TYPE_SELL, Addon.c_RuleType_Sell);
end

--*****************************************************************************
--  Evaluates all of then rules (or a specific rule) and returns true of
--  and the name of the that matches it.
--
-- ruleName is optional, if provided it will only run that rule.
--*****************************************************************************
function RuleManager:Run(object, ...)
    local result, ran, categoryId, ruleId, name = self.rulesEngine:Evaluate(object, ...);
    Addon:DebugRules("Evaluated \"%s\" [ran=%d, result=%s, ruleId=%s]", (object.Name or "<unknown>"), ran, tostring(result), (ruleId or "<none>"));
    if (result) then
        if ((categoryId == RULE_TYPE_KEEP) or (categoryId == RULE_TYPE_LOCKED_KEEP)) then
            return false, ruleId, name;
        elseif ((categoryId == RULE_TYPE_SELL) or (categoryId == RULE_TYPE_LOCKED_SELL)) then
            return true, ruleId, name;
        end
    end

    return false, nil, nil
end

--*****************************************************************************
-- Generates a new unique custom rule id, this rule encodes the player, realm
-- and time so it should be very unique.
--*****************************************************************************
function RuleManager.CreateCustomRuleId()
    local player, realm = UnitFullName("player");
    return string.format("cr.%s.%s.%d", player, realm, time());
end