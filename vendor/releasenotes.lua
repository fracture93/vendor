local AddonName, Addon = ...

Addon.ReleaseNotes ={
{
Release ="6.0 (November ?, 2022)",
Notes = [[
# Vendor 6.0!
Another expansion, another major update for Vendor!

# New UI
As Blizzard keeps changing their UI every expansion and every classic release, we are perpetually broken by trying to retain the Blizzard theming. So we're abandoning Blizzard UI theming and using new primitives now that
should work on any version. We strongly suspect this is why many popular addons with configuration options choose to do this rather than adopt Blizzard's UI - they are too inconsistent and break us too often and too easily
to adopt their UI theme, so we will simply stop trying. Sorry Blizzard, we'd like to keep the theme of your game but we just can't.

The New UI is wider than before, hopefully this will not cause problems for too many folks. We feel this is necessary to have a better user experience in our addon.

# Custom Lists
This feature was actually released in 5.3 but we didn't mention it, but you can now create custom lists and then build rules around your custom item lists. The goal in the future is to allow sharing and for you to have sell or keep rules
which target specific item lists that you can turn on and off as you desire and give you more granular control over the lists.


]]},
{
Release ="5.3 (November 3, 2022)",
Notes = [[
# Dragonflight Pre-Patch Fixes
Blizzard has changed a lot of things in this expansion pre-patch, with more changes coming in the 10.0.2 revision (currently beta). The purpose of this update is to
enable Vendor to work during the pre-patch. It will not be pretty, as we have UI changes designed for the Beta where they have more significant changes that are incompatible
with the live version. So expect us to break again in 10.0.2 because they are changing C_Container and how tooltips work.

# Tabs extend off the side!
Yes, we know the tabs extend off to the side of the frame, its a bug with blizzard changing how frames work again, please bear with it for a few weeks. We didn't want to hold up our release on fixing this, as we have an entirely new UI in Beta and fixing this just for a few weeks in pre-patch is really not worth the time or delaying the update. We do not plan on fixing this for the pre-patch, sorry, please just...ignore it for a short time.

# Merchant Sell/Destroy Buttons
Those who use our addon have long requested a "button" on the merchant to do selling manually, and we have finally added this. The Functionality is new and the settings have not been hooked up in this version properly, but we have added both of them for convenience. In our next update you will be able to enable/disable both of these features. In the mean time please use them and give us feedback. :)

# Transmog Support Altered (may have bugs!)
We have had a bit of a complete rework around the Transmog items and are attempting to capture transmogs you might potentially want. This is particularly relevant
with the new (old?) group loot feature. Instead of scanning for tooltip we are using the Transmog APIs directly, but the transmog APIs are...strange. We think that "not IsCollected" is equivalent to the old "IsUncollectedAppearance" in functionality.
There may be bugs in the transmog feature. If you spot one please report it to us on Curseforge and we will investigate. Please note that Blizzard understands transmogs at the character level and whether a character can use an item seems to affect whether they consider it "collectable". As such it is difficult to identify a transmog item that you haven't collected which this character cannot use.

# IsUncollectedAppearance Removed
This property was removed and the built-in rule updated to use the new properties. You can now use "IsCollected" or the exact equivalent is '(not IsCollected)' if you have a rule that is now broken because of this.
We thought about keeping the other one for compatibility but we didn't want to crap up our properties. We will look at adding hidden equivalence for better back compat in the future. Apologies for this if your rule is now broken. If you used the built in Keep Uncollected Appearances you should be fine.

# Several New Properties
We've added item counts into the properties
* StackCount - Number of current items in this stack. In other words, the current stack size.
* Bag - The current bag number of the item in your inventory (or -1 if it isn't)
* Slot - The current slot number of the item in your inventory (or -1 if it isn't)
* IsCollectable - Is this a collectable appearance?
* IsCollected - Have you collected this appearance?
The intent here is that you can decide to keep any collectable appearance if you so desire so as not to miss out on. Do note that this is CHARACTER based, so if your character cannot equip an item then the appearance will show as not collectable. This is a Blizzard limitation, and we can't do much about it without book keeping every one of your other characters. We feel the best solution here is to add an extension to a popular Transmog addon and leverage their tracking of transmog data for rules. That will come at some point but for now just know that transmog equipment is a bit wonky.

# LibDataBroker Support Added
We added support for LibDataBroker for Vendor, which replaced the Vendor Titan plugin. If you were using Vendor Titan you can go add the new LibDataBroker one thorugh the interface. This will allow us to appear in many other places other than Titan. Since many addons support LibDataBroker you may now find Vendor icon and support in more of your addons! Hopefully this works well enough and we plan on improving this more to the point where it has the old titan plugin functionality (where you right-click and can destroy or change profiles).

# Minimap Button
We've added a minimap button but the setting do disable it is not yet hooked up. Apologies. In our 10.0.2 update you will be able to disable this. It uses LibDataBroker just like the new Titan plugin option.

# Notable Bug Fixes
Too many to name really, we've been doing a lot of reworking and hard to pin down exact bugs fixed along the way.

]]},
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