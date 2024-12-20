Alternatives to death
https://www.nexusmods.com/x4foundations/mods/551
by kuertee

Updates
=======
v7.1.16, 03 Dec 2024:
-Bug-fix: For loaded games created before 13 Apr 2023: Some ships that should be indestructible (e.g. mission/story-critical ships) were still getting set to be destructible when you exit them.

Mod effects
===========
Alternatives to death: clone, descendant, teleport, ransom, assimilation. Other gameplay effects: dead is dead, ship destruction countdown, Cloning Lab, Trust Executor Office, acquire Cr to inherit property, acquire your assimilator's faction relationships.

When you plan to uninstall the mod, save the game from the Options menu. Games saved from the Options menu do not have the player ship's invulnerability. It is safe to uninstall the mod at these saves. Otherwise, when the mod is uninstalled, the player's ship will be invulnerable.

Note that the base-game's auto-eject feature is disabled with this mod - regardless of whether it is enabled in the game's settings. It disrupts this mod's countdown to destruction feature. For this override to not "stick" to all your games (i.e. in case you uninstall the mod in the future), save the game from the Options Menu. When opening the Options Menu, this override is removed - preventing it from being saved in your game. Auto-save and quick-save unfortunately saves it in your game - locking it in to your game even after this mod is uninstalled.

Requirements
============
SirNukes Mod Support APIs mod (https://www.nexusmods.com/x4foundations/mods/503) - for Lua Loader and Simple Menu Options
Kuertee's UI Extensions mod (https://www.nexusmods.com/x4foundations/mods/552) - Modded Lua files with callbacks to allow more than one mod to change the same UI element.

Recommended companion mods
==========================
Grouped save files (https://www.nexusmods.com/x4foundations/mods/1310): required when using the Ironman mode feature.
Crime has consequences (https://www.nexusmods.com/x4foundations/mods/566): Ships are fined, then impounded, then forfeited. Pay fines at the Fines and Forfeiture office to reacquire ships before their forfeiture.
Escape Pod (https://www.nexusmods.com/x4foundations/mods/596): Pilotable escape pod.
Teleport From Transporter Room (https://www.nexusmods.com/x4foundations/mods/553): Adds a Teleport button to your Transporter Room panels and removes the "Teleport to" command from the Map Menu.

Alternatives to death
=====================
(To add to my history, since 2009, of modding away the obsolete sequence of "death > reload" from games (see my version of the mod for Oblivion and Skyrim), I decided to develop it for X4. Shamus Young posted a good argument against the "game over" screen in this blog post (with YouTube video): http://www.shamusyoung.com/twentysidedtale/?p=2048.)

When a ship receives constant damage that would destroy it within the next 15 seconds, a 30-second countdown will appear in your HUD. During this countdown, the ship will be invulnerable, allowing you to escape from it.

Destruction is inevitable when your ship only has 25% of its hull AND has less than 15 seconds left before destruction, determined by received damage-per-second. After the countdown, the ship will explode.

Destruction can be averted if your ship has more 25% of its hull AND further damage is avoided.

If you get caught in the ship's destruction, one of these alternatives to death will occur:

Alternative 1: Clone: If you have a clone in reserve, it will be activated. Clones can be bought from Cloning Labs.
Alternative 2: Descendant: Your play will resume from the agency of a distant relation.
Alternative 3: Teleport: An employee will pull you to safety via their ship's or station's teleporter - provided you have that technology.
Alternative 4: Ransom: You are captured and are released for a ransom.
Alternative 5: Assimilation: You are brainwashed (by one of the major factions), assimilated (by the Xenon) or cordycepified (by the Kha'ak).

Note that these alternatives will prevent the Game Over screen. However, if you've disabled some alternatives and the active alternatives cannot be executed, you will get the Game Over screen. For example: you're playing only with the Clone option, but have no clones available.

Also note that the base-game's auto-eject feature is disabled with this mod. One of this mod's purpose is to make ejecting from a doomed ship possible but also tactile/manual.

Ironman mode
============
You can only load from one save slot. Autosaves and quicksaves are exempt.
This requires my other mod, Grouped save files (https://www.nexusmods.com/x4foundations/mods/1310), for its Game Id Manager.

Dead is dead
============
After a death alternative sequence, you won't be able to load a game until after you save the game. If a quickload is detected, a death alternative sequence will be activated. "Ironman mode" takes priority over this penalty.

Save scum penalties
===================
Penalties will be applied when a game older than 60 minutes (by default and configurable) is loaded.
1. Save scum death penalty: A death alternative sequence will be activated. "Ironman mode", and "Dead is dead" takes priority over this penalty.
And/or:
2. Credits penalty: Credits will be deducted from the player's personal credits. "Ironman mode", "Dead is dead", and the "Save scum death penalty" takes priority over this penalty.

Clones
======
If you have any clones in storage, they will be activated. The properties of your old self will automatically transfer to the clone. And your relationships with the factions will be retained by your clone. Optionally, you can set the clone to start with no properties and their relationships reset - as if the clone started a new game in your universe.

Descendants
===========
Your descendants will not automatically acquire your ships and stations. These properties will be held in a trust, which they can inherit after acquiring 1,000,000 Cr.

Ransom payment
==============
You will lose 25% of your property as payment for your ransom.

Assimilation
============
You will acquire your assimilator's faction relationships.

When captured by one of the major factions, your mind will be wiped and incepted with their philosophy. When captured by the Xenon, you will be turned into a cyborg and will be programmed to hate all organic beings. When captured by the Kha'ak, you will be infected by their cordyceps and zombified into one of their drones.

Note that assimilation to the Khaak and Xenon didn't work in my current game. My relations to those factions were locked at -30. It's likely that on games that were started before the mod activated, the changes to their "locked" attributes, which are set to "locked", cannot be changed. Their attributes MAY, however, change in new games started with the mod activated.

Properties after death options
==============================
Inheritance: Your properties will be held in a trust. They can be inherited when you acquire 1,000,000 Cr.
Confiscated by the sector's ruling faction.
Confiscated by your killer.
Destroyed.

Cloning Lab
===========
Buy reserve clones from cloning labs. Not all stations have a lab.

Trust Executor's Office
=======================
You can claim your inheritance from the Trust Executor. Their offices will be in one of the major faction's headquarters. They will only be available when you have an inheritance to claim.

Escape Pod support
==================
The "Enter Escape Pod" button on the Transporter Room panel is available when the Escape Pod mod (https://www.nexusmods.com/x4foundations/mods/596) is installed. The Escape Pod's auto launch is disabled.

Configure the mod
=================
Many features of the mod can be modified in the Extensions Options screen.

Install
=======
-Unzip to 'X4 Foundations/extensions/kuertee_alternatives_to_death/'.
-Make sure the sub-folders and files are in 'X4 Foundations/extensions/kuertee_alternatives_to_death/' and not in 'X4 Foundations/extensions/kuertee_alternatives_to_death/kuertee_alternatives_to_death/'.

Uninstall
=========
-Save the game from the Options menu. Games saved from the Options menu do not have the player ship's invulnerability. It is safe to uninstall the mod at these saves. Otherwise, when the mod is uninstalled, the player's ship will be invulnerable.
-The base-game's auto-eject feature is disabled with this mod - regardless of whether it is enabled in the game's settings. It disrupts this mod's countdown to destruction feature. For this override to not "stick" to all your games (i.e. in case you uninstall the mod in the future), save the game from the Options Menu. When opening the Options Menu, this override is removed - preventing it from being saved in your game. Auto-save and quick-save unfortunately saves it in your game - locking it in to your game even after this mod is uninstalled.
-Delete the mod folder.

Troubleshooting
===============
(1) Do not change the file structure of the mod. If you do, you'll need to troubleshoot problems you encounter yourself.
(2) Allow the game to log events to a text file by adding "-debug all -logfile debug.log" to its launch parameters.
(3) Enable the mod-specific Debug Log in the mod's Extension Options.
(4) Play for long enough for the mod to log its events.
(5) Send me (at kuertee@gmail.com) the log found in My Documents\Egosoft\X4\(your player-specific number)\debug.log.

Credits
=======
By kuertee.
German localisation by Herman2000.
Chinese localisation by "i@kag*.com".
Russian localisation by epicproff.
Split DLC restarts by General Vash.

History
=======
v7.1.09, 10 Oct 2024:
-Bug-fix: Some factions (e.g. Xenon) still had locked factions that prevented assimilation into them.
-Tweak: Station-only teleport compatibility with Teleport From Transporter Room mod.

v7.1.02, 13 Jul 2024:
-Tweak: Ensure mod only works in player-owned ships.

v7.0.02, 29 Jun 2024:
-Tweak: 7.00 hf 1 compatibility. Disabled in Timelines scenarios.
-Tweak: make new starts based on a randomly found ships instead of the player's original game start
-Bug-fix: death doesn't reset Social Standings And Citizenships mod data
-Bug-fix: death cutscene was conflicting with Autocam mod cutscenes
-Bug-fix: working countdown ui with new uix custom hud code
-Bug-fix: sometimes the countdown is stuck at paused - which prevents the countdown from completing
-Bug-fix: correct money transfers to/from trust
-Bug-fix: properties are not returned from the trust after completing its mission

v6.2.013, 25 Feb 2024:
-Localisation: Russian translation by epicproff.
-Compatibility: With Mycu's Verbose Transaction Log mod, money transfers from this mod will be labeled: Ransom payment for release from captivity, Transfer to trust upon death, Transfer from station to trust upon death, Transfer from station build storage to trust upon death, Transfer from trust as inheritance, Cloning service, Save scum penalty in the Transaction Log menu.

v6.2.011, 18 Feb 2024:
-New feature: Ironman mode: You can only load from one save slot. Autosaves and quicksaves are exempt. This requires my other mod, Grouped save files (https://www.nexusmods.com/x4foundations/mods/1310), for its Game Id Manager.
-Removed feature: Dead is dead has been replaced with Ironman mode.
-Tweak: Optimisation: limited hit detection for DPS calculation to 0.25 per second instead of for every hit.
-Bug-fix: Social Standings and Citizenships ratings were not getting reset after a death alternative process.

v6.2.001, 10 Sep 2023:
-Bug-fix: your ship was not getting protectred from destruction and so the countdown destroys the ship before its finished.

v6.1.004, 01 Aug 2023:
-Bug-fix: ship was getting destroyed too early preventing your escape.

v6.1.003, 29 Jul 2023:
-Chinese localisation: Thank you to "i@kag*.com" on Nexus.

v6.1.001, 28 Jun 2023:
-Bug-fix: The rooms for the cloning lab and the trust office were not getting created in Boron stations.

v6.0.002, 13 Apr 2023:
-New feature: Save scum penalties: A save scum is detected when a loaded game is an hour or older than the current in-game time. When detected, the player will lose 50% (by default and configurable) of their credits. Or a death alternative can be set to be the penalty instead. More info in the Save Scum Penalties section below.
-Tweak: Dead is dead now works for each separate game. I.e. it now identifies if the loaded file is from the same game. Previously, it applied its penalties across all saved games regardless of whether the loaded file is of the same game.
-Bug-fix: Entering ships that should be invulnerable were getting set to vulnerable when you exit them.

v6.0.0004, 18 Feb 2023:
-Bug-fix: The inheritance code was broken. The Trust wasn't taking the players properties for inheritance.
-Note: This version should work with 6.x and 5.x of the base game.

v5.1.0314, 06 Dec 2022:
-Bug-fix: Pause countdown to destruction on menus. They were paused when the Transporter Room menu was open, but not when the Map Menu was open - which is what's required when plotting a Teleport destination.
-New feature: Destroying your attacker before the countdown reaches 0 will cancel the destruction.
-Tweak: Because of the new feature above, the destruction becomes unavoidable only when hull points are 0. Previously, destruction was unavaoidable based on the ship's received damage-per-second.
-Note: The countdown will always start at 15 seconds (by the Extension Options default) from when there is only 15 seconds OR less of both shields and hull is left. E.g. if there's only actually 5 seconds left of shields and hull, but damage calculation starts then, the countdown will still start at 15 seconds.

v5.1.0313, 31 Oct 2022:
-Bug-fix: The pause at 3 seconds countdown to destruction while a menu is open wasn't working.

v5.1.0301, 17 Jul 2022:
-Return feature: Destrcution countdown. Needs 5.1.0301 of UI Extensions which re-enables the custom HUD elements.
-Bug-fix: Some properties were getting skipped during the bribe payment and destruction processes.

v5.1.00091, 14 Jun 2022:
-Interim fix for UI Extension not showing custom HUD bug: show the countdown as notifications.

v5.1.0009, 23 May 2022:
-New feature: New alternative: Warp to nearest friendly station. No penalty. By default, this alternative is disabled. Enable it in the Extension Options.
-New feature: When you plan to uninstall the mod, save the game from the Options menu. Games saved from the Options menu do not have the player ship's invulnerability. It is safe to uninstall the mod at these saves. Otherwise, when the mod is uninstalled, the player's ship will be invulnerable.

v5.0.0013, 30 Mar 2022:
-Bug-fix: Damage to hull and shield events to detecting countdown - instead of only on attack events.
-Bug-fix: Don't destroy ship if there more than the set destruction hull points threshold.

v5.0.0011, 19 Mar 2022:
-New feature: Pirate DLC game restarts.

v5.0.001, 18 Mar 2022:
-New feature: More reactive HUD. High and increasing (or decreasing) damage per second (DPS) will be show on the HUD next to the countdown.
-New feature: Less disruptive clones: Clones retain their relationships. In previous versions, new clones reset their relationships. Note that clones also retain Reputations (from my other mod, Reputations and Professions) and Social Standings (from my other mod, Social Standings and Citizenships). You can disable this in the Extensions Options.
-New feature: Clones are 3x more likely to be chosen when death alternative is random and it is available.
-New feature: "Teleported to safety by an employee" is 5x more likely to be chosen when death alternative is random and it is available.
-New feature: Support for Social Standings and Citizenships. When you lose properties, your Immigration Status will be recalculated.
-Bug-fix: Cloning labs are never found at player-owned stations.

v4.2.0804, 2 Feb 2022:
-Bug-fix: Respawning as a clone would break the death process if you had no clones left.
-New feature: Separated the ownership options after death. By default: clones and those assimilated retain their properties, descendants lose then can inherit their properties. Check the Extension Options. Previously, the ONE ownership options after death was applied to all three alternatives.
-Bug-fix: Crime has Consequences support: ships with no assigned ai pilot cannot be impounded and are destroyed at the end of the countdown. Previously, the countdown would restart and the ship will never explode until you exit it.

v4.2.071, 3 Jan 2022:
-Bug-fix: The mod was creating its rooms and npcs when you arrive at the station instead of when you actually dock or teleport to it.

v4.2.07, 2 Jan 2022:
-Bug-fix: Teleporting in and out of stations wasn't detected, so the mod's custom rooms and NPCs were not created when teleporting into a station.

v4.2.01, 13 Dec 2021:
-Bug-fix: Standardised the event listeners for: arrive at station, dock, undock, leave station in my mods that need them with these events: attention change, dock, undock, teleport. In previous versions, these events were handled inconsistently that resulted in intermittent bugs like: (in Reputations and Professions) the Guild Network button become disabled after docking even if it was available before docking, (in High-security Rooms Are Locked) the mission NPC not getting moved to an unlocked room, (in several mods) mod NPCs, like the Mod-Parts Trader not getting spawned in their rooms, etc.

v4.2.0, 10 Dec 2021:
-Bug-fix: Clean-up mod-specific NPCs at stations after the player teleports. Previously, they were cleaned-up only when the player leaves the station's vicinity.

v4.1.01, 12 Nov 2021:
-Bug-fix: NPC pilot disappearing from ship when countdown destruction starts.

v4.1.0, 06 Nov 2021:
-Bug-fix: Inheritance text DB in the GERMAN LANGUAGE FILE had incorrect variables breaking the text in-game.

v2.1.1, 11 Aug 2021:
-Bug-fix: Successful inheritance message fix.

v2.1.0, 26 Jul 2021:
-Bug-fix: Reading Dead-is-dead data for that feature to work.

v2.0.9, 25 Jul 2021:
-New feature: When you avert destruction, by flying evasively, you get a shield boost to help you escape. This shield boost has a cool-down timer of 10 minutes.
-New feature: Dead is dead. Optional feature. With this feature enabled, after you respawn after death with the death alternative, the game will detect if you load a different game to cheat the death alternative outcome. When this cheat is detected, the new game will load but you will spawn with another death alternative.
-Bug-fix: The ship would be invulnerable after the countdown to destruction - preventing other countdowns and preventing the impound feature of Crime has consequences from working.
-Bug-fix: The base-game's auto-eject feature is disabled with this mod - regardless of whether it is enabled in the game's settings. It disrupts this mod's countdown to destruction feature. For this override to not "stick" to all your games (i.e. in case you uninstall the mod in the future), save the game from the Options Menu. When opening the Options Menu, this override is removed - preventing it from being saved in your game. Auto-save and quick-save unfortunately saves it in your game - locking it in to your game even after this mod is uninstalled.

v2.0.8, 3 Jul 2021:
-New feature: Terran re-starts, if available.
-Tweak: Better compatibility with Crime has consequences (CHC). Previously, if you were being attack by a faction who can impound your ship, ATD's countdown to destruction is disabled. In this version, ATD's countdown will show as normal, but destruction will not occur if the ship can be impounded, as usual when both ATD and CHC are installed. Instead, the ship will be impounded, as usual when both ATD and CHC are installed. With this tweak, ATD's countdown and "take evasive manouvers" HUD notification will be active.
-Tweak: If you are assimilated and have no other ships (except the one that was destroyed), you will restart with one of the available restart options. Assimiliation is suppose to not give you any new properties. This tweak activates only if you have no other ship.
-New feature (beta): Dead is dead. Loading another game with this set, after death to cheat the mod, will cause the death alternative to start. Disable this in the Extensions Options.
-Bug-fix: When assimilated, you will restart at a station neutral or friendly to the assimilating faction. Previously, you could restart at a station aggressive against the assimilating faction.
-Bug-fix: The Trust Executor was getting created even if the death alternative chosen randomly doesn't need them.

For v4.1beta1 of the game:
v2.0.7, 15 Jun 2021:
-Compatibility: Station seed property used in creating rooms for 4.1beta1.

For v4.0 of the game:
v2.0.6, 29 May 2021:
-New feature: Clone alternative can now be de-prioritised, which allows it to be chosen randomly like the other alternatives. Clones are first exhausted before the other alternatives are used unless it is de-prioritised. By default the clone alternative has priority. Change this in the Extensions Options.
-Bug-fix: Licences weren't getting removed/updated after "death".
-Bug-fix: The destruction countdown is now paused at 3 seconds if the Map menu or the Transporter Room menu is open, which allows you to spend as much time choosing your teleport destination. Previously, the countdown wasn't paused - which was the bug. (Note that when my other mod, Teleport from Rransporter Room, is used, you can only teleport by using the Transporter Room panel.)
-Tweak: Damage-per-second (DPS) monitor.
-Tweak: Removed the now unnecessary Khaak and Xenon definitions from factions.xml. They were there to unlock them for the Assimilation feature to work. Unlocking them now work at the code level.

v2.0.5, 25 Apr 2021:
-Tweak: Better implementatino of "Extended conversation menu". Some conversation options are based on conditions. In the previous version, all conversations are sent to ECM (if it is installed). The problem is when no conversation options are based on those conditions, which sometimes leaves the conversation empty, requiring the player to Escape out of it.

v2.0.4, 22 Apr 2021:
-New feature: Support for iforgotmysocks' "Extended conversation menu" - if installed.
-Bug-fix: Reset completed cues that track boarding operations.

v2.0.3, 18 Apr 2021:
-Bug-fix: Unlock faction relationship before assimilation. Some factions are locked from relationship changes - preventing assimilation to those factions from working. Unlocking them first would make this work.

v2.0.2, 17 Mar 2021:
-Bug-fix: Split faction name typo.

v2.0.1, 17 Mar 2021:
-New feature: Destruction countdown time is now decreased to 15s. The extra time is set to 0 from the previous versions of 15s. Change this extra time back (or any value you wish) in Extensions Options menu of the mod. The long destruction countdown time was to allow players of my other mod, Teleport From Transporter Room, to get to the Transporter Room and select a teleport destination. (With that mod, teleport from the map is disabled.) In this new version, the ship will never be destroyed until after the Transporter Room Panel is closed - allowing the player to teleport away.
-Bug-fix: Descendants restart option was failing to run the full respawn-sequence (new ship, inheritance, etc.) after the player "respawns".
-Bug-fix: Split game respawns had invalid objects.

v2.0.0, 11 Mar 2021:
-New feature: updated for v4.0.0 beta 11 of the base game.
-New feature: Split DLC clone restarts. Thanks, General Vash!
-New feature: Strict clone restart option: clones will start with the same equipment and relations as the player, rather than randomised.
-New feature: expanded ownership options after death: Inheritance (default), Confiscated by the sector's ruling faction, Confiscated by your killer's faction, or Destroyed.
-New feature: inheritance notifications sent to the mail system.
-Bug fix: ransom payment option is not enabled when killed by the khaak or the xenon.

v1.3.0, 28 Dec 2020:
-New feature: Support for Escape Pod mod (https://www.nexusmods.com/x4foundations/mods/596). Enter the Escape Pod from the Transporter Room panel. Requires Escape Pod version greater than 1.01 - likely unreleased at the moment, but will be released soon.
-New feature: Set these to configure when the countdown starts and the countdown length. "Hull-seconds remaining to start countdown" and "Additional countdown seconds". Their defaults are the same as the previous versions at 15s each. Read the section, "Configure the mod", below if you want to change these values.
-New feature: "Execute evasive maneuvers." HUD notification if the ship's destruction can be averted.
-Tweak: The HUD notification stays yellow if destruction can be averted.

v1.2.2, 7 Nov 2020:
-Bug-fix: DPS calculation bug from the update that allows the player to avert destruction (v1.2.0). This is the bug that causes your ship to be invulnerable when it has no health left. Because the ship has no health left, the system doesn't register new damage - effectively reducing its received DPS every second. Luckily that, in the base game, even if the damage is not detected while your ship is protected from destruction, hits are. In this version, DPS only decreases while your ship is not getting hit - effectively maintain the previous DPS regardless of new incoming damage.

v1.2.1, 6 Nov 2020:
-Bug-fix: "Crime has consequences" mod (https://www.nexusmods.com/x4foundations/mods/566) compatibility: Ship impounds on attack overrides the death sequence, including the countdown.

v1.2.0, 2 Nov 2020:
-New feature: "Crime has consequences" mod (https://www.nexusmods.com/x4foundations/mods/566) compatibility: Crimes of ships that are put into trust are inactive until the player retrieves the ships.
-New feature: Boarding operations are forced into a stalemate on "death".
-New feature: Ship destruction can be averted by avoiding more damage and decreasing damage-received-per-second (DPS).
-New feature: Ship destruction is certain if the ship only has 15 seconds of hull left AND the hull is less than 25%.
-New feature: Better DPS tracking code.
-Bug-fix: The death sequence wasn't destroying your ship at the end of the countdown sometimes.
-New feature: More efficient dialogue.
-Bug-fix: Clone specialist and the trust executors will never leave their offices.
-Bug-fix: Notifications of relationship changes and lost licenses are suppressed while "respawning".

v1.1.1, 14 Sep 2020 PM:
-Bug-fix: Buying a clone doesn't remove monies from the player.

v1.1.0, 14 Sep 2020:
-Bug-fix: Prevent the death alternative sequence, that works "behind the scenes", from terminating by making sure that the "watch cutscene" location and the final location for the player are never empty.
-Tweak: Death alternative sequence tweaked: teleport from ship, destroy ship, transfer to trust/pay ransom, teleport to new location, show death notice.
-Bug-fix: Version number correctly appended to the names of clones.
-Bug-fix: The name of the employee in the "Teleport to safety by employee" notice should never be empty/null.
-Bug-fix: Allow the death notice to be closed. Previously, the player needed to click on the button "Mark as read" for the death alternative sequence to continue/complete.
-Bug-fix (maybe): Unlock the relations of Khaak and Xenon so that players can raise their relations to them, so that assimilation to their factions can work. Note that this didn't work in my current game. It MAY work in new games, however.

v1.0.0, 28 Aug 2020: Initial release.
