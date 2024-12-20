Hacking outcomes
https://www.nexusmods.com/x4foundations/mods/495
by kuertee

Updates
=======
v7.1.09, 10 Oct 2024:
-Tweak: Compatibility with Crime Has Consequences mod's new feature of crime has witnesses.

Mod effects
===========
-Data files from a hacking activity yield one of these types of meaningful data: a generic mission, a lockbox location, an anomaly location, a data vault location.
-Stations with hacked security consoles cannot report you to sector security for 1 hour.
-Crime has consequences support: Hacking the security panel allows you to release any impounded ships on the station.

Recommended companion mods
==========================
-Crime has consequences (https://www.nexusmods.com/x4foundations/mods/566): ships are fined, then impounded, then forfeited. Pay fines at the Fines and Forfeiture office to reacquire ships before their forfeiture.
-High-security rooms are locked (https://www.nexusmods.com/x4foundations/mods/540): High-security rooms (Engineering Section, Security Office) are locked. Get access from a black marketeer in the sector.

How the mod works
=================
After a hack, one of these types of missions is presented based on the hacked object:
-A combat-specific mission: when a turret control, shield generator or security panel is hacked.
-An economic-specific mission, or a lockbox location: when a production or storage panel is hacked.
-An engineering-specific mission, a lockbox location, an anomaly location, or data vault location: when an engineering panel is hacked.

Stations with hacked security consoles will not be able to report you to sector security for 1 hour.

Install
=======
-Unzip to 'X4 Foundations/extensions/kuertee_hacking_outcomes/'.
-Make sure the sub-folders and files are in 'X4 Foundations/extensions/kuertee_hacking_outcomes/' and not in 'X4 Foundations/extensions/kuertee_hacking_outcomes/kuertee_hacking_outcomes/'.

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

v6.1.001, 28 Jun 2023:
-Bug-fix: Prevent finding lockbox mission from producing errors in the log.

v6.0.002, 13 Apr 2023:
-Tweak: Version number update for consistency with my other mods. No internal changes since the last version.

v5.1.0305, 15 Sep 2022:
-Bug-fix: Long-time bug that prevented you from logging off the hacked panel - which basically locked you out of the game.

v4.2.02, 16 Dec 2021:
-New feature: Crime has consequences support: Hacking the security panel allows you to release any impounded ships on the station.

v2.0.1, 23 Mar 2021:
-Bug-fix: When trying to report your crimes, stations were incorrectly getting flagged as being hacked in the first hour of play. In regards to my other mod, Crime has consequences, this prevents any crime from being reported against you in the first hour of play.

v2.0.0, 11 Mar 2021:
-New feature: updated for v4.0.0 beta 11 of the base game.
-Tweaks: Cleaned-up unnecessary localisation files. Rewrote content.xml manifest file.

v1.1.0, 28 Dec 2020:
-New feature: Stations with hacked security consoles cannot report you to sector security for 1 hour.

v1.0.2, 27 Aug 2020:
-Bug-fix: Previously, missions that are declined stuck in the Accepted Missions list.
-Clean-up: Missions generated from previous versions of this mod are silently aborted.

v1.0.1, 6 Jun 2020:
-Tweak: get_safe_pos tweaks to ensure objects are inside the search area.
-Tweak: Remove obsolete code for finding locked data vaults.
-Tweak: Ensure Init cue is in waiting state.
-Tweak: Cleaned-up cue instantiations.

v1.0.1, 6 Jun 2020:
-Tweak: get_safe_pos tweaks to ensure objects are inside the search area.
-Tweak: remove obsolete code for finding locked data vaults.
-Tweak: ensure Init cue is in waiting state.

v1, 12 May 2020: initial release.
