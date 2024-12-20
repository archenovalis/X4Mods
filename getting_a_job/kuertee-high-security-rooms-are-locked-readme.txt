High-security rooms are locked
https://www.nexusmods.com/x4foundations/mods/540
by kuertee

Updates
=======
v7.1.02, 13 Jul 2024:
-Tweak: silence null var error logging.

Mod effects
===========
-High-security rooms (Engineering Section, Security Office) are locked. Get access from a black marketeer in the sector.
-Buy black marketeer contacts in adjacent sectors from black marketeers.

Requirements
============
SirNukes Mod Support APIs mod (https://www.nexusmods.com/x4foundations/mods/503) - to load the custom Lua files
Kuertee's UI Extensions mod (https://www.nexusmods.com/x4foundations/mods/552) - Modded Lua files with callbacks to allow more than one mod to change the same UI element.

High-security rooms are locked
==============================
To gain entry to the Engineering Sections or Security Offices of stations, access must be bought from a black marketeer in the sector.

Three types of accesses can be bought. And not all types are available.
1. A Transporter Room entry code. Use this immediately on the Transporter Room panel to gain entry to the high-security room.
2. A hacker who can hack the Transporter Room. Contact the hacker by scanning his Signal Comm. They will then hack the Transporter Room.
3. An operative who has access to the Transporter Room. Make contact with the operative and follow them through the Transporter Room.

Once unlocked, the key will be valid for only 10 minutes. (The key is stored in your PDA. If you abort the mission, you will lose the key.)

Note that if you find a mission NPC behind a locked room, they will be moved to an unlocked room AFTER you use the Transporter Room the first time. Usually, the mission NPC is moved AFTER you dock, but sometimes the mod doesn't find them at that time. Moving to another room will re-trigger the code that moves them to an unlocked room.

Black marketeer contacts
========================
Buy black marketeer contacts in adjacent sectors from black marketeers. You need to find a black marketeer before you can buy the mission signal of other black marketeers.

Install
=======
-Unzip to 'X4 Foundations/extensions/kuertee_high_security_rooms_are_locked/'.
-Make sure the sub-folders and files are in 'X4 Foundations/extensions/kuertee_high_security_rooms_are_locked/' and not in 'X4 Foundations/extensions/kuertee_high_security_rooms_are_locked/kuertee_high_security_rooms_are_locked/'.

Uninstall
=========
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
German localisation by LeLeon.

History
=======
v7.0.02, 29 Jun 2024:
-Tweak: 7.00 hf 1 compatibility. Disabled in Timelines scenarios.

v6.2.013, 25 Feb 2024:
-Compatibility: With Mycu's Verbose Transaction Log mod, money transfers from this mod will be labeled: High-security room entry code, Hacker services for high-security room access, Bribe for high-security room access, Bribe for other black marketeer contact in the Transaction Log menu.

v6.1.001, 28 Jun 2023:
-Bug-fix: Black marketeers were still not getting found on newly-started games. Basically, the base game creates black marketeers when you near a station. Therefore no black marketeers would be found for you to buy contacts unless you've already explored much of the stations in the sector. When purchasing a contact, this fix forces the creation of at least one black marketeer if none are found in a sector.
-Bug-fix: Mission NPCs in locked rooms were not getting moved to an unlocked room in Boron stations.
-Bug-fix: No monies were actually removed after purchasing a black marketeer contact. :D
-Bug-fix: The operative contact was disappearing on their video comm when they contact you after unlocking the secured room.

v6.0.0021, 18 Apr 2023:
-Tweak: Allow buying new blackmarketeer contacts on unexplored adjacent sectors.

v6.0.002, 13 Apr 2023:
-Bug-fix: The new black marketeer contact's signal wasn't getting detected if it has already been created - requiring the player to leave the sector and re-approach the station.
-Bug-fix: The cost of the a new black marketeer contact wasn't getting deducted from the player's credits.

v5.1.0010, 26 May 2022:
-New feature: Buy black marketeer contacts in adjacent sectors from black marketeers. You need to find a black marketeer before you can buy the mission signal of other black marketeers.

v5.0.001, 18 Mar 2022:
-Bug-fix: Default cost of access keys are were set at 1% instead of 10% - which is my original intention. Set this to whatever value in the Extension Options.

v4.2.073, 5 Jan 2022:
-Bug-fix: Unrecoverable freezes caused by infinite loop when arriving at stations which MAY happen anytime you arrive at the station regardless of whether you teleport or dock.

v4.2.071, 3 Jan 2022:
-Bug-fix: The mod was creating its rooms and npcs when you arrive at the station instead of when you actually dock or teleport to it.

v4.2.07, 2 Jan 2022:
-Bug-fix: Teleporting in and out of stations wasn't detected, so the mod's custom rooms and NPCs were not created when teleporting into a station.

v4.2.01, 13 Dec 2021:
-Bug-fix: Standardised the event listeners for: arrive at station, dock, undock, leave station in my mods that need them with these events: attention change, dock, undock, teleport. In previous versions, these events were handled inconsistently that resulted in intermittent bugs like: (in Reputations and Professions) the Guild Network button become disabled after docking even if it was available before docking, (in High-security Rooms Are Locked) the mission NPC not getting moved to an unlocked room, (in several mods) mod NPCs, like the Mod-Parts Trader not getting spawned in their rooms, etc.

v4.2.0, 10 Dec 2021:
-Bug-fix: Clean-up mod-specific NPCs at stations after the player teleports. Previously, they were cleaned-up only when the player leaves the station's vicinity. This also fixes the bug when taxi passengers were not getting moved away from the locked rooms.

v4.1.0, 6 Nov 2011:
-Bug-fix: Initiate locking of rooms, moving mission actors away from locked rooms, etc. on docked event instead of docking started event.

For v4.1beta1 of the game:
v2.0.3, 15 Jun 2021:
-Compatibility: Station seed property used in creating rooms for 4.1beta1.

For v4.0 of the game:
v2.0.2, 22 Apr 2021:
-New feature: Support for iforgotmysocks' "Extended conversation menu" - if installed.
-Bug-fix: If you didn't have my other mod, Alternatives to Death (ATD), installed, the blackmarketeer would fail to give you the passcode. In this version, reliance on ATD is removed.

v2.0.1, 18 Apr 2021:
-Bug-fix: Was using a text reference from "Crime has consequences". Fixed in this version.

v2.0.0, 11 Mar 2021:
-New feature: updated for v4.0.0 beta 11 of the base game.
-Tweaks: Cleaned-up unnecessary localisation files. Rewrote content.xml manifest file.

v1.1.3, 28 Dec 2020:
-Bug-fix: The operative still failed to spawn in stations with very few NPCs. In this version, the operative is forced-spawn into a random newly-created room. Previously, the operative was spawned in the most populated room.
-Tweak: Much better guidance to mission objectives. E.g. Instead of only "Use the Transporter Room", the mission objective in this version will point you to the room you unlocked. Instead of only "Talk to X" without a pointer to the station they are in, the mission objective in this version will point you to the station.

v1.1.2, 22 Dec 2020:
-Bug-fix: The operative on the station wasn't getting spawned.

v1.1.1, 14 Dec 2020:
-Bug-fix: NPC mission targets (e.g. transport passengers) locked behind high-security rooms are moved to another room.

v1.1.0, 2 Nov 2020:
-Tweak: More efficient conversation threads (e.g. buying a key from the black marketeer).
-Bug-fix: The code got cross-wired while conversing with a hacker to unlock a door WHEN you have multiple missions with different hackers for different stations at once.
-Update: Pilot cutscene caption standardised with my other mods. I.e. name, faction, ship/station, caption.

v1.0.2, 14 Sep 2020:
-Bug-fix: Ensure that $station is not empty so that clean-up of station data is executed when the station leaves high attention.
-Tweak: Add more code phrases.
-Bug-fix: Ensure inside operative can be reached by the player by adding the inside operative in the most crowded walkable module.
-Tweak: Method of finding locked rooms, unlocking them then relocking them.
-Bug-fix: The inside operative will need to get into a Transporter Room before the room is unlocked. Previously, the room was getting unlocked before this.

v1.0.1, 27 Aug 2020:
-Tweak: Detecting player.station changes.
-Bug-fix: Validate locked/unlocked rooms to prevent Transporter Menu from getting disabled.
-Tweak: Player-owned stations don't have locked rooms.
-New feature: Configurable costs of the keys.
-Tweak: Localisation of "Yes"/"No" confirmation of key purchase.
-Bug-fix: Re-unlock room on return to the station within the key time limit.
-Tweak: The station is set as the mission target for the map mission pointer.
-Clean-up: cutscene convos.

Update from version v1.0.0
==========================
Do a clean-save of the previous version before installing this.
How to do a clean-save:
1. Delete the previous version from the file system.
2. Load a game.
3. Save the game. This is the clean-save. Load this after installing the new version.

1.0.0, 29 Jul 2020: initial release
