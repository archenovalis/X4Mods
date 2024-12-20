Teleport from transporter room
https://www.nexusmods.com/x4foundations/mods/553
by kuertee

Updates
=======
v7.1.13, 02 Nov 2024:
-Tweak: Cleaned-up the code that determines teleportation availability.

Mod effects
===========
Adds a Teleport button to your Transporter Room panels.
By default, only stations have teleportation technology. Ship to ship teleportations are not allowed.
By default, this mod removes the "Teleport to" command from the Map Menu.
By default, this mod also disallows teleportation to and from allied properties.

Use this mod with the ship destruction countdown of my other mod, Alternatives To Death (https://www.nexusmods.com/x4foundations/mods/551), for a more tactile experience of abandoning ships.

Requirements
============
SirNukes Mod Support APIs mod (https://www.nexusmods.com/x4foundations/mods/503) - for Lua Loader and Simple Menu Options
Kuertee's UI Extensions mod (https://www.nexusmods.com/x4foundations/mods/552) - Modded Lua files with callbacks to allow more than one mod to change the same UI element.

Configure the mod
=================
From the Extensions Options screen:
1. Enable the "Teleport to" command in the Map Menu,
2. Allow teleportation to and from allied properties.
3. Allow ship-to-ship teleportation.

Install
=======
-Unzip to 'X4 Foundations/extensions/kuertee_teleport_from_transporter_room/'.
-Make sure the sub-folders and files are in 'X4 Foundations/extensions/kuertee_teleport_from_transporter_room/' and not in 'X4 Foundations/extensions/kuertee_teleport_from_transporter_room/kuertee_teleport_from_transporter_room/'.

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
German localisation by Herman2000.

History
=======
v7.1.09, 10 Oct 2024:
-New feature: By default, only stations have teleportation technology. Ship to ship teleportations are not allowed. Disable this in the mod's Extension Options.

v7.0.02, 29 Jun 2024:
-Tweak: 7.00 hf 1 compatibility.
-Maintenance update: use UI Extensions' new method to load mod-specific UIX lua(s)

v6.0.002, 13 Apr 2023:
-Tweak: Version number update for consistency with my other mods. No internal changes since the last version.

v4.2.0805, 08 Feb 2022:
-Bug-fix: The Teleport Button on the Transporter Room was broken. i.e. The previous version broke the mod. Fixed now.

v4.2.0804, 02 Feb 2022:
-Tweak: Teleport selection now performed purely in Lua instead of from a conversation menu with the "player.computer". This should prevent the bug that locks the conversation menu open from some mods that add conversation topics without any restrictions (e.g. not actor-specific or topic-specific).

v4.2.0, 10 Dec 2021:
-Tweak: Support for Social Standings and Citizenships (SSaC) mod: because SSaC may remove friendly and alliance licences, relations are checked against Relationship Points (e.g. 10+, 20+).

v4.1.0, 06 Nov 2021:
-Tweak: Limit list of destinations to player-owned ships and stations. Previously, all visible MIGHT have been shown.

v2.0.0, 11 Mar 2021:
-New feature: updated for v4.0.0 beta 11 of the base game.
-Tweaks: Cleaned-up unnecessary localisation files. Rewrote content.xml manifest file.

v1.0.2, 2 Nov 2020:
-Tweak: Set the optional immediate flag of the teleport function to true.

v1.0.1, 14 Sep 2020:
-Bug-fix: Ensure that the Teleport button is available immediately after game load.

v1.0.0, 28 Aug 2020: Initial release.
