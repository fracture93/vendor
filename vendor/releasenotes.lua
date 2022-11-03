local AddonName, Addon = ...

Addon.ReleaseNotes ={
{
Release ="5.2 (June 29, 2021)",
Notes = [[
# Classic / TBC Compat updates

It appears as though Blizzard has advanced their Classic and TBC UI to no longer have some 
of the previous incompatibilites. So with some minor adjustments this version of Vendor should now 
work on TBC and Classic

Note: that we have not had heavy use of this version in Classic or TBC, so there may be some bugs still 
lurking. Please report these on the curseforge site for Vendor and we will investigate.

# Systems Improvements

While there are no outward features yet exposed related to improving the systems of Vendor, 
a fair bit has changed, which may mean new unexpected bugs. Features that use some of the new 
improvements will be forthcoming.

# Updated Item Property - IsCraftingReagent

Now uses the GetItemInfo property which tracks this instead of trying to read it from the tooltip

# Notable Bug Fixes

Audit panel will no longer break after 30 days.
]]},

{
Release="5.1 (November 23, 2020",
Notes = [[
# AdiBags Plugin

* one
* two
* three

Similar to the ArkInventory plugin, we now have an AdiBags plugin that adds categories for 
items Vendor will Sell or Destroy to AdiBags.

If you use AdiBags this should Just Work and you should see things starting to get filtered once 
you install this version.

# Audit Tab

All items Vendor sells or destroys in the last 30 days is now tracked and available for viewing in the 
new Audit tab.

If you think Vendor may have sold or destroyed something, check the Audit tab! If you need
to use Blizzard item restoration, this information can be very useful in locating when the item was
sold or destroyed. It will also tell you why it was sold/destroyed and what Vendor Rule was used to make that determination.

There are also new console commands for showing the Vendor History, under "/vendor history". 
You can reset the history for a character or all characters using "/vendor history clear" and "/vendor 
history clear all".

History is automatically pruned to the last 30 days on login, which is the max documented time frame in which an item can be restored by Blizzard item restoration.

# New Built-in Keep Rule - Potential Upgrades

This is a new rule that matches gear that is within 5 levels of the player's average itemlevel or 95% of it, whichever is greater. This is a great new keep rule and now enabled by default for new profiles.

This will ensure things like the pawn "not upgrade" sell rule won't match off-spec gear, or side-grades and other items which you probably don't want to sell and haven't added to an equipment set.

# Unsellable Items added to the Sell list

If you use the hotkey to mouseover and add toggle items on the Sell-list, or drag an unsellable item onto the Sell list, it will instead be placed into the Destroy list. Such items can never be sold so we will try to do the right thing here and put it into the Destroy list. A console message will print when this
happens so you know. We thought this better than giving you annoying pop-ups, but it may seem like the add 'didn't work' - it did, it just went into a different
list. If this proves confusing to users we will improve this experience. Existing unsellable items in the sell list are unchanged - you may have to move these manually.

# New Item Property - IsEquipped

This property matches true only if the item is currently equipped.

# Notable Bug Fixes:

Random Item GUID lua error fixed (thank you fuba82!) 

Pawn extension will no longer scare you by flagging the gear you are wearing as will be sold if it isn't an 'upgrade' per Pawn (It couldn't actually sell the items you are wearing, just to be clear).
Pawn extension will also no longer match unsellable gear for its sell rule.

Rules Help once again shows functions from extensions like TSM and Pawn.

Battle pets dragged into the rule editor's Item Info tab will no longer throw lua errors. We do not yet support Battle Pet properties, but will in the future. For now it won't cause errors.

#  Known Issues

Audit Tab tooltip with audit info is briefly shown, but then removed by ArkInventory. We are investigating this issue further, but it appears to only affect those using ArkInventory.
]]},

{
Release = "5.0 (November 17, 2020)",
Notes = [[
# Profiles

Vendor now supports profiles! When you log in with a character, a profile will be created for that character with previous settings so that character's settings will be as before.
After that you can change profiles for characters, copy profiles, or create new blank profiles as you wish! The Titan Plugin for Vendor also supports rapid profile switching in the
right-click menu on the Vendor Titan button. This makes it easy to swap between profiles that you create for everyday use vs farming old content or leveling, etc.

# New UI

As you've probably noticed, our User Interface has changed significantly. Gone are Scrap Rules and the custom rule definitions and that dangerous "defaults" button. With the addition
of Destroy rules and list, as well as this help panel and profiles panels, we wanted to make the UI more compact scalable. All the rules are in one tab, and all the lists in one tab,
with a selection menu on the left and the list of rules or items on the right. The "Create" button to create new rule has been renamed to "New Rule" and is now in the "Rules" tab.

# Destroy Rules and List

By popular request, we now support Destroy rules and a Destroy list. These are items that will not be sold, but rather will be deleted from your inventory.

We had automatic-destroy
working great whenever you visited a vendor, but with the 9.0.2 patch, Blizzard protected 'DeleteCursorItem()', which means it can only be executed from a hardware event. This means
you MUST press a key in order to destroy items. Fortunately you can still destroy multiple items and there is no confirmation required, so this still saves you a lot of hassle. To facilitate
making the item destruction as easy as possible, we have added a new hotkey to trigger item destruction, added it to our API, and also added it to the Vendor Titan Plugin's Right-Click
menu option under 'Run Destroy'.

We will still attempt to sell items marked for "destroy" if you are at a merchant prior to destroying them. However we do not yet have any
notice or correction if you place an unsellable item into the Sell list - the item will simply not be sold, nor destroyed.

# Updated Vendor Titan Plugin

The Vendor Titan plugin has a few new features, including now showing the exact list of items that will 
be sold by Vendor or deleted by Vendor. In addition, in the right-click menu there is now a
"Set Profile" flyout menu where you can change your profile quickly and easily without having to open 
up the main UX. This makes it easy to have more aggressive profiles for selling and
deleting old content loot and easily switch to and from them when you're doing that content.

# Notable Bug Fixes:

* Display of items in the Matches tab of the edit rule dialog now shows the exact item tooltips as in your 
inventory.
* Changed the hook for tooltip OnHide to a securehook to remove taint possibilities.
]]}

}