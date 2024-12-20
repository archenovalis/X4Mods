Crime has consequences
https://www.nexusmods.com/x4foundations/mods/566
by kuertee

Updates
=======
v7.1.16, 03 Dec 2024:
-New feature: Scans of targets of the same faction as the mission giver are no longer crimes.

Mod effects
===========
Crime has witnesses: committed crimes are recorded but are not reported until witnesses near one of their faction's station. Only ships and stations of the same faction of the victims of crimes can be witnesses.
Distress drones carry all of their ship's recorded (but unreported) witnessed crimes.
Station witnesses report the crime immediately.

Reported crime has consequences: ships are fined, then impounded, then forfeited.
Pay fines at the Fines and Forfeiture office to reacquire ships before their forfeiture.

Note that the base-game's auto-eject feature is disabled with this mod - regardless of whether it is enabled in the game's settings. It disrupts this mod's impound ship feature. For this override to not "stick" to all your games (i.e. in case you uninstall the mod in the future), save the game from the Options Menu. When opening the Options Menu, this override is removed - preventing it from being saved in your game. Auto-save and quick-save unfortunately saves it in your game - locking it in to your game even after this mod is uninstalled.

Recommended companion mods
==========================
Reputations and Professions (https://www.nexusmods.com/x4foundations/mods/636): role-playing mod that adds 4 Reputations (Defender, Vigilante, Mercenary, Pirate), and 8 Professions (Courier, Engineer, Miner, Saboteur, Spy, Trader, Builder, Shipwright).
Social Standings and Citizenships (https://www.nexusmods.com/x4foundations/mods/804): Friendly and alliance licences require citizenship. Poor social standing limits citizenship status.
Hacking Outcomes (https://www.nexusmods.com/x4foundations/mods/495): Stations with hacked security consoles cannot report you to sector security for 30 minutes.

Requirements
============
SirNukes Mod Support APIs mod (https://www.nexusmods.com/x4foundations/mods/503)
Kuertee's UI Extensions mod (https://www.nexusmods.com/x4foundations/mods/552)

Crimes
======
Ships that commit these crimes will incur fines. Fines incurred while in a spacesuit will be transferred to the first ship the player enters.

-Attacks: Attacks incur fines after they affect the player's relationship with the factions of their victims. The mod follows the base game's tolerance to initial attacks.
-Boardings / Claims on ships that were victims of attacks
-Kills
-Bomb attacks
-Illegal cargo: Ships that carry illegal cargo will receive fines when they do not comply with police requests (attack or escape).
-Illegal plot claims: NPC patrols will fine the player for stations they find without licenses.

When within 25km of large operations, fines are 10% of their normal value. Large operations are station attacks and ship boardings. During large operations attacks and kills of drones and laser towers are not reported as fines.

Crimes charged to the commander are not charged again to their wingmen. However, crimes charged to wingmen will be charged again to their commander when their commander joins the attack.

Self-defense attacks and kills are not charged as crimes.

Hacking Outcomes compatibility
==============================
Hacking Outcomes (https://www.nexusmods.com/x4foundations/mods/495) compatibility. Stations with hacked security consoles cannot charge you for crimes.

Ship impounds
=============
Factions will impound ships with fines when the ships dock on their stations. Spacewalk to the station to avoid getting impounded. Or use the Taxi Service from my mod, NPC Reactions (https://www.nexusmods.com/x4foundations/mods/497), to enter stations without your ship.

During attacks, factions will impound ships, including the player's ship, when their hull drops below 25%.

Enemy factions can impound your ships. Because you cannot dock on enemy stations, my NPC Reactions mod's Taxi Service feature is the only way for you to visit the Fines and Forfeiture Office of enemy factions.

NOTE: Similar to my "Alternatives to death" (ATD) mod (https://www.nexusmods.com/x4foundations/mods/551), the ship impounds feature of "Crime has consequences" will prevent your ship from getting destroyed, providing your ship has fines and is being attacked by a faction that owns those fines. This effectively prevents the game from ending on the "Game Over" screen. This feature overrides the death features in ATD. But those features can still activate on attacks on your ship by factions that don't have charges against your ship. In late-game stages, these factions will be the Khaak and Xenon - unless you set the option that enemy factions don't charge you with crimes. In this case, your ship can still be destroyed by enemy factions.

NOTE: Cargo of recovered ships that were impounded may not be available for sale until after a save-then-load of a game.

Fines and Forfiture office
==========================
Pay fines to re-acquire impounded ships at the Fines and Forfeiture offices located in defense stations.

Impounded ships will be forfeited to the faction that impounded if their fines are not paid after 14 hours.

3rd-party mod API: Disable a crime
==================================
1. Use this code to disable a crime-type, where X is one of the crime-types listed below:
<cue name="DisableCrime">
	<conditions>
		<event_cue_signalled cue="md.Setup.GameStart" />
		<event_game_loaded />
	</conditions>
	<cues>
		<cue name="DisableCrime_interval" instantiate="true" checkinterval="5s">
			<actions>
				<do_if value="@md.kuertee_chc.DisableCrime.exists">
					<run_actions ref="md.kuertee_chc.DisableCrime">
						<param name="Crime" var="X" />
					</run_actions>
					<reset_cue cue="parent" /><!-- readies DisableCrime for the next event_game_loaded and cleans this interval altogether -->
				</do_if>
				<cancel_cue cue="this" /><!-- cleans this interval instance -->
			</actions>
		</cue>
	</cues>
</cue>

2. Use this code to re-enable a crime-type, where X is one of the crime-types listed below:
<set_value name="$crimeType" exact="X" />
<run_actions ref="md.kuertee_chc.EnableCrime">
	<param name="Crime" value="$crimeType"/>
</run_actions>

Currently, only these crime-types can be enabled/disabled:
-Bomb attacks: md.kuertee_chc.kCHC.$crime_bomb_attack
-EMP attacks: md.kuertee_chc.kCHC.$crime_emp_attack

Request new crime-types, when you need them.

3rd-party mod API: Custom crimes
================================
1. Register the custom crime:
For readability, $crime_X should be rewritten as "$crime_bribery" or "$crime_stealing_a_loaf_of_bread" or whatever the crime is.
<do_if value="@md.kuertee_chc.kCHC.exists">
	<do_if value="not $crime_X?">
		<run_actions ref="md.kuertee_chc.CustomCrimes_Add" result="$crime_X" comment="$crime_X.$id = id of the crime">
			<param name="Cue" value="X" comment="X = 3rd-party cue" />
			<param name="Name" value="Y" comment="Y = crime name" />
			<param name="FineLevel" value="Z" comment="Z = fine level. e.g. 'level.easy'" />
			<param name="FineMult" value="1" />
		</run_actions>
	</do_if>
</do_if>

2. Charge the player with the custom crime:
<do_if value="@md.kuertee_chc.kCHC.exists">
	<set_value name="$crimeId" exact="X" comment="X is the $crime_X.$id retruned from registring the custom crime" />
	<set_value name="$victim" exact="Y" comment="Y is a ship or station" />
	<set_value name="$isSelfDefense" exact="Z" comment="Z is whether this is crime is in self-defense, an uncharged but recorded crime." />
	<signal_cue_instantly cue="md.kuertee_chc.CrimeConfirm" param="table[
		$crime = $crimeId,
		$criminalShip = if player.ship then player.ship else player.entity,
		$victimShipStation = $victim,
		$victimFaction = $victim.owner,
		$isSelfDefense = $isSelfDefense
	]"/>
</do_if>

3. These are the relative amounts for the FineLevel value. And you can set the FineMult to refine the amount.
level.trivial = about $75 k
level.veryeasy = about $90 k
level.easy = about $120 k
level.medium = about $800 k
level.hard = about $3 M
level.veryhard = about $30 M
level.impossible = about $100 M

Configure the mod
=================
Modify these features in the Extensions Options screen:
-value of fines for each type of crime
-multiplier of fines within large operations. Currently, fines are 10% of their normal rate within 25km of a large operation.
-impound ship with record on dock (default: on), impound player ship with record on dock (default: on), impound player ship on dock on any fines (default: off)
-hull percentage to impound ship with record (default: 25%), impound player ship with record on attack (default: on), impound player ship on attack on any fines (default: off)
-hours to forfeit impounded ships
-wingmen's crimes on the same targets as their commander's are separate crimes (default: false).
-accumulate crimes on enemy factions (default: true)

For heftier fines overall, I recommend these settings. Set them one at a time, to get a feel for their expense.
-let stations impound the player ship on any fines on dock
-set wingmen's crimes to be separate from their commander's
-set the fines within large operations to a range of 0.5 to 1
-lastly, tweak the value of fines

How the mod works
=================
Initially, I thought it would be a simple system to set fines when the player's relationship changes caused by crime events (e.g. relationchangereason lookup). That's how the early versions worked. This version is a little bit more complex. I had to generate a "black box" of events for each ship, allowing us: (1) the detection of self-defense attacks and kills and (2) the availability of data for each crime for each ship. Look at the screenshots of the Fines and Forfeiture Map UI panel for examples of this detailed data.

And here are some of the systems built into the mod:
-Self-defense: A list of who attacked who first.
-Boarding operations (large operation): Boarding events are generated directly from the base game's boarding system.
-Station attacks (large operation): Attacked stations are automatically added to the large operation list.
-Attacks are not initially crimes. A stray bullet hitting a friendly is common in firefights. Attacks are monitored and only become crimes when (eventually) the targets' relations change on sustained attacks. Attacks on "red" targets are automatically reported.
-Crimes committed while spacewalking: The spacesuit has a "black box" also - which is transferred to the ship the player first enters.
-Alternatives to death (https://www.nexusmods.com/x4foundations/mods/551) is my other mod which prevents the game from reaching the game over screen. If the player does die, their clones/relations who don't inherit your properties also lose the fines on ships with records - UNTIL they inherit those ships.
-Impounded ships: The player is automatically ejected from the controls when the ship is impounded. There is a galaxy-wide law that forces all wharves and shipyards to install systems on ships that prevent impounded ships from being controlled by the player. The same law forces NPCs to fly the ship to the nearest wharf, shipyard, or defense station. Impounded ships are prevented from destruction, which sets this mod as another alternative to death. Impounded ships take precedence over any alternatives from my "Alternative to death" mod.
-Fines and Forfeiture Map UI panel: A new Map UI panel that works just like any properties panel. The objects listed are selectable and interactable.

My experience (with Alternatives to Death)
==========================================
(I tested the mod with a boarding operation for two weeks to tweak the value of fines, find and fix bugs and tweak the experience. This was my experience in one of these tests.)

With my corvette leading 3 capital ships, we descended upon a large freighter to board it. Taking out its turrets incurred us fines and criminal records. And our capital ships that launched boarding pods incurred separate fines and records.

As we were protecting the boarding pods, my corvette was damaged sufficiently for the freighter's defenders to impound my corvette. I was ejected from the controls while my relief pilot, compelled by law, flew the corvette to the impound lot in the nearest defense station. As I jumped off the corvette to spacewalk to one of my nearby capital ships, I was shot down by one of the freighter's defenders.

(Because of my "Alternative to death" mod,) A clone was activated and I became them.

When I eventually inherited my previous self's ships and stations, the fines and criminal records attached to those ships transferred to me. My pre-self's crimes didn't pay. I did. But 2 million in fines attached to a corvette and 3 capital ships, is a small price to pay for a large freighter worth more than 2 million.

Install
=======
-Unzip to 'X4 Foundations/extensions/kuertee_crime_has_consequences/'.
-Make sure the sub-folders and files are in 'X4 Foundations/extensions/kuertee_crime_has_consequences/' and not in 'X4 Foundations/extensions/kuertee_crime_has_consequences/kuertee_crime_has_consequences/'.

Uninstall
=========
-The base-game's auto-eject feature is disabled with this mod - regardless of whether it is enabled in the game's settings. It disrupts this mod's mod's impound ship feature. For this override to not "stick" to all your games (i.e. in case you uninstall the mod in the future), save the game from the Options Menu. When opening the Options Menu, this override is removed - preventing it from being saved in your game. Auto-save and quick-save unfortunately saves it in your game - locking it in to your game even after this mod is uninstalled.
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
CHC icon by Forleyor.
German localisation by LeLeon.

History
=======
v7.1.10, 17 Oct 2024:
-New feature: The "Reported by"/"Reported at" data are listed in the log book's crime entry. If the crime was committed near a station, then the station would have been a witness to the crime, and so "Reported by" and "Reported at" will be the same. In these cases, only "Reported by" will be listed.
-Tweak: Code clean-up: removed all old code that reported crimes instantly - before the Crime Has Witnesses features of v7.1.09x.

v7.1.09, 10 Oct 2024:
-New feature (from 7.1.08x beta): Crime has witnesses: committed crimes are recorded but are not reported until witnesses near one of their faction's station. Only ships and stations of the same faction of the victims of crimes can be witnesses.

v7.1.082 beta, 30 Sep 2024:
-Tweak: Crime reporting (i.e. when you are fined) on the player's ship are now timed when the NPC warns you - if that scene will be played. If no scene will play, then the crime will be reported when the ship or their drone nears one of their faction's station or a faction station is nearby.
-Bug-fix: Multiple records of the same crime were getting witnessed (i.e. recorded, but not reported) if their self defense tags were different.
-Tweak: Distress drones were witnessing (i.e. recording, but not reporting) destruction of the ship that launched them even if the ship is out of the drones' radar range.
-Bug-fix: Player attack/kill crimes were not getting tagged as self defense when they should.
-Bug-fix: Hacking Outcomes compatibility stopped working after the v7.1.08x beta.

v7.1.081 beta, 24 Sep 2024:
-Bug-fix: Kills were not getting reported after the first.
-Bug-fix: Distress Drones were not reporting the crime if their ship is destroyed.
-Bug-fix: Destroying Distress Drones shouldn't result in a kill crime.

v7.1.08 beta, 23 Sep 2024:
-New feature: Crime has witnesses. In this beta version, crime reporting is delayed. The victim of the crime or its Distress Drone needs to near one of its faction's station to report the crime. Note that a crime may and is very likely to have many witnesses. Ships of the same faction that is within its maxradar range of the victim will be witnesses. Station witnesses will immediately report/log the crime.

v7.1.07, 17 Sep 2024:
-Bug-fix: Paying fines of an individual ship from the Map menu wasn't tagging your personal fine as paid when your ship's name was changed since the crime was recorded.

v7.1.05, 3 Aug 2024:
-Bug-fix: Unresponsive Criminal Record list in the Factions menu.

v7.1.01, 7 Jul 2024:
-Bug-fix: Disembarking from a non-player owned ship into a station (e.g. as a taxi passenger) would sometimes break the next impound operation.

v7.0.02, 29 Jun 2024:
-Tweak: 7.00 hf 1 compatibility. Disabled in Timelines scenarios.

v6.2.013, 25 Feb 2024:
-Compatibility: With Mycu's Verbose Transaction Log mod, money transfers from this mod will be labeled: Fines, Fines for one ship, Bribe for ship release in the Transaction Log menu.

v6.2.011, 18 Feb 2024:
-Bug-fix: fines for lasertowers were getting set at the ship-amount.
-Bug-fix: impounded ship not getting released to player after payment.

v6.2.006, 28 Oct 2023:
-Bug-fix: Crimes were only getting applied to small ships. In this version other sized ships can be charged with a crime.

v6.2.001, 10 Sep 2023:
-Tweak: 6.2. compatibility.

v6.1.001, 28 Jun 2023:
-Bug-fix: The rooms for the Fines and Forfeiture office weren't getting created in Boron stations.

v6.0.002, 13 Apr 2023:
-Tweak: Version number update for consistency with my other mods. No internal changes since the last version.

v6.0.0007, 3 Apr 2023:
-Tweak: Compatibility with 6.0 beta 7.
-Bug-fix: Setting fines to the player entity now lists the fine. Note that the fine will be transfered to the first owned-ship that they enter.

v6.0.00041, 28 Feb 2023:
-Tweak: Compatibility with 6.0 beta 4.
-Note: This version is only for 6.0 beta 4 and newer.

v6.0.0004, 18 Feb 2023:
-Bug-fix: Factions without no stations (e.g. Fallen Families) will collect their fines at Fines and Forfeiture offices in stations friendly to them.
-Bug-fix: Add Fines And Forfeiture Office to shipyards, wharves, equipment dock, headquarters and faction headquarters. I was mistaken in believing that all those are also classed as defense stations.
-Bug-fix: Player criminal record were sometimes getting disconnected to their crime - preventing you from paying them. Loading the game will add these disconnected fines back, so that you can clear your outstanding criminal record.
-Note: This version should work with 6.x and 5.x of the base game.

v5.1.0301, 17 Jul 2022:
-Bug-fix: Proper support for Reputations and Professions' sanctioned attacks on Emergent Missions' Search And Destroy missions.
-Bug-fix: Fines (esepcially from illegal cargo/wares crimes) were getting attributed to the incorrect ship, sometimes even to a station that you docked on even if you don't own the station.

v5.1.0009, 23 May 2022:
-New feature: Support for full sactioned attacks on Search And Destroy missions from Emergent Missions mod and Reputations And Professions mod.
-Bug-fix: Crimes by your AI ships in low attention were getting ignored.
-Tweak: When the option to attribute crimes to the ship's commander also applies to victims. I.e. attacks on wingmen will be considered attack on their commander.
-Tweak: Attack times for self-defense determination are now from AIScripts instead of from MD events.

v5.0.0013, 30 Mar 2022:
-New feature: Support for Reputations and Professions (RAP) mod and Emergent Missions (EM) mod of sanctioned attacks on Search and Destroy targets. The factions of these targets will not charge you with crimes if immunity is arranged by RAP's Bounty Hunters Guild.
-New feature: Illegal activities can be sanctioned. For modders: set $kCHC_isSanctioned to true on the ship's ".assignedaipilot" or ".defencenpc" entities.
-Bug-fix: Impounded ships were not reporting that they've been impounded either via video comm or on the player log.

v5.0.0011, 19 Mar 2022:
-Bug-fix: Paying individual ship's fines was not removing that ship's crime data.
-Tweak: When the ship you're on is impounded, and you ride with it to its impound location, reveal unknown sectors.

v5.0.001, 18 Mar 2022:
-Tweak: Player criminal record is now listed in date descending order.
-Bug-fix: An illegal scan crime will be charged by the faction you revealed rather than by their cover faction - if the scan was successful.

v4.2.0806, 14 Feb 2022:
-Tweaks: Consider ships under cover when charging fines. Crimes against ships that are undercover and have been scanned (and so their true factions revealed) will be charged by their true owner - rather than their fake owner. The previous version only checked this on illegal scan activities. In this version, all crimes check for this.

v4.2.0805, 08 Feb 2022:
-Bug-fix: UI: Remove the fines entry when you pay the fines. The previous version didn't fix this bug.

v4.2.0804, 02 Feb 2022:
-Bug-fix: Prevent you from paying the fine twice in the map menu by removing the button immediately after you click it. Previously, it would stay on until the menu refreshed (which is whenever the game decides to refresh it), which allowed you to click it again causing the fines to be incorrectly calculated.
-Bug-fix: Attacks on drones attached to the Hatikva mission do not generate crimes. The mod was previously targeting the wrong variable for those drones.

v4.2.0801, 24 Jan 2022:
-Tweak: The ship's "true owner" charges with you the illegal scan - in case the ship was disguised. i.e. pirates.

v4.2.08, 20 Jan 2022:
-Bug-fix: Paying the fine of individual ships now updates your criminal record. Previously, your criminal record was only updated whenever you pay your fines with the faction all at once at the Fines and Forfeiture Office. Updating to this version will set any unpaid fines in your criminal record as being paid - WITHOUT removing the fine. You'll still need to pay the fine.
-Tweak: Scanning ships is not illegal in unowned sectors, player-owned sectors, or the player has a police licence with the sector's owner. Previously, it was illegal when the ship complains to the player.

v4.2.074, 7 Jan 2022:
-Tweak: Scanning is not a crime if the sector has no owner, if you own the sector, or if you own the police licence of the faction that owns the sector. Previously, scanning was considered illegal when the ship complains about it.

v4.2.071, 3 Jan 2022:
-Bug-fix: The mod was creating its rooms and npcs when you arrive at the station instead of when you actually dock or teleport to it.

v4.2.07, 2 Jan 2022:
-Bug-fix: Teleporting in and out of stations wasn't detected, so the mod's custom rooms and NPCs were not created when teleporting into a station.

v4.2.06, 31 Dec 2021:
-Bug-fix: Paying all your fines at one time doesn't set the criminal record as paid of ships that have been destroyed.

v4.2.02, 16 Dec 2021:
-New feature: Bribe the station manager to release any impounded ships on the station for half the fines. The fines are not clerared. Impounded ships are simply released.

v4.2.01, 13 Dec 2021:
-Bug-fix: Standardised the event listeners for: arrive at station, dock, undock, leave station in my mods that need them with these events: attention change, dock, undock, teleport. In previous versions, these events were handled inconsistently that resulted in intermittent bugs like: (in Reputations and Professions) the Guild Network button become disabled after docking even if it was available before docking, (in High-security Rooms Are Locked) the mission NPC not getting moved to an unlocked room, (in several mods) mod NPCs, like the Mod-Parts Trader not getting spawned in their rooms, etc.

v4.2.0, 10 Dec 2021:
-New feature: Player criminal records. Listed in the Factions menu. This feature is not retro-active. It will only log current, unpaid and new crimes committed by the player.
-Tweak: Support for Social Standings and Citizenships (SSaC) mod: because SSaC may remove friendly and alliance licences, relations are checked against Relationship Points (e.g. 10+, 20+).
-Bug-fix: Clean-up mod-specific NPCs at stations after the player teleports. Previously, they were cleaned-up only when the player leaves the station's vicinity.
-Bug-fix: Custom crimes data (e.g. Unpaid bank loans from my mod, NPC Reactions) were getting lost after exiting the game.

v4.1.01, 12 Nov 2021:
-Bug-fix: Impounded ships with no crimes (e.g. when your ship is impounded when you dock while your other ships have crimes) are now listed in the menu.
-Bug-fix: "Pay this fine" button now unavailable if payment will lock an impounded ship.

v4.1.0, 06 Nov 2021:
-New feature: Custom crimes: 3rd-party mods can add new crimes to this mod. Read the section, 3rd-party mod API: Custom crimes, below.
-New feature: Support for NPC Reactions: Unpaid Loans crimes.

v2.1.2, 09 Sep 2021:
-Bug-fix: Clean crimes by ships list of ships that have become invalid - especially after death process of Alternatives To Death mod.

v2.1.1, 11 Aug 2021:
-Bug-fix: Clean crimes by ships list of ships that have become invalid.

v2.1.0, 25 Jul 2021:
-Bug-fix: The base-game's auto-eject feature is disabled with this mod - regardless of whether it is enabled in the game's settings. It disrupts this mod's mod's impound ship feature. For this override to not "stick" to all your games (i.e. in case you uninstall the mod in the future), save the game from the Options Menu. When opening the Options Menu, this override is removed - preventing it from being saved in your game. Auto-save and quick-save unfortunately saves it in your game - locking it in to your game even after this mod is uninstalled.
-Bug-fix: Several compatibility problems with my other mod, Alternatives to death, were fixed.

v2.0.9, 03 Jul 2021:
-Tweak: Better compatibility with Alternative to death (ATD). Previously, if you were being attack by a faction who can impound your ship, ATD's countdown to destruction is disabled. In this version, ATD's countdown will show as normal, but destruction will not occur if the ship can be impounded, as usual when both ATD and CHC are installed. Instead, the ship will be impounded, as usual when both ATD and CHC are installed. With this tweak, ATD's countdown and "take evasive manouvers" HUD notification will be active.
-Compatibility: 3rd-party mods can disable/re-enable crime-types.

For v4.1beta1 of the game:
v2.0.8, 15 Jun 2021:
-Compatibility: Station seed property used in creating rooms for 4.1beta1.

For v4.0 of the game:
v2.0.7, 29 May 2021:
-New feature: Disable crime accumulation with pirates. By default this is enabled. Disable this in the Extensions Options. Pirates are factions with their relationship to the player locked at a negative value. I think the base game has the Scale Plate locked at -5, so they are pirates. But Duke Buccaneers are locked at +10, so they are not pirates. (Pirate faction detection is not straightforward. And I only found the method described just recently.)
-New feature: Add Fines and Forfeiture Offices to stations tagged as a pirate base.
-New feature: Ships scans in your territory (zone and/or sector) are no longer illegal.

v2.0.6, 15 May 2021:
-Bug-fix: "No fines" is listed if no ships are listed but there are still faction fines. Note that ships' fines persist even after the ship has been destroyed.

v2.0.5, 25 Apr 2021:
-Tweak: Better implementatino of "Extended conversation menu". Some conversation options are based on conditions. In the previous version, all conversations are sent to ECM (if it is installed). The problem is when no conversation options are based on those conditions, which sometimes leaves the conversation empty, requiring the player to Escape out of it.
-Bug-fix: After "respawning" as either a clone or descendant with my other mod, "Alternatives to death", your crimes cleared - until you re-inherit back those ships with fines attached to them. The problem is when the ship you died in has a fine. The ship has become invalid but the mod still tries to apply the fines. In this version, the fines are simply added to your account without it being applied back to the ship.

v2.0.4, 22 Apr 2021:
-New feature: Support for iforgotmysocks' "Extended conversation menu" - if installed.
-New feature: Now uses Egosoft's new Cutscene for comms that shows the interior of the ship.
-Bug-fix: When paying off all your fines at the Fines Office and you have multiple ships with fines, only one ship's fines were getting cleared. This bug would present itself only when you go and pay the next fine. The UI would list no ships even, if internally, the fines of some persisted. fixed in this version.

v2.0.3, 18 Apr 2021:
-Bug-fix: Fines were getting attached to player NPC pilots that capture ships. Fines should always be attached to ships. Fixed in this version.

v2.0.2, 21 Mar 2021:
-Bug fix: Ships with no AI pilot that are docked on an impounded ship will also be impounded.

v2.0.1, 21 Mar 2021:
-Bug fix: Ships to be impounded will undock all ships docked on them. This prevents the possible crashes when the player tries to access a docked ship that is docked in an impounded ship. On game load, if there are impounded ships with ships docked on them, the impounded ships will be released back to the player. (Their fines will be retained.)

v2.0.0, 11 Mar 2021:
-New feature: updated for v4.0.0 beta 11 of the base game.
-New feature: pay fines of ships that are not impounded from the UI.
-Tweak: do not impound player ship until dock when no ai pilot.
-Tweak: standardised ship names (idcode, type, model name) in the UI.
-Bug fix: impounded ships without crimes are now listed in the ui.

v1.1.3, 28 Dec 2020:
-New feature: Hacking Outcomes (https://www.nexusmods.com/x4foundations/mods/495) compatibility. Stations with hacked security consoles cannot charge you with crimes against it nor report you to sector security for 1 hour.
-Removed feature: Hacked security consoles prevented stations from issuing fines for your attacks against them. Use Hacking Outcomes if you want this feature. It's more full-featured in that mod.
-Bug-fix: Bomb and EMP attacks triggered from within a ship were still corrupting the crime data - preventing you from paying off your crimes after that ship has been impounded IF (and only IF) no other ships have fines with the same faction. If other ships have fines with the same faction, this bug doesn't occur. This bug should be fixed now in this version.

v1.1.2, 22 Dec 2020:
-New feature: Hacking a station's security computer will prevent them from charging you for your bomb and EMP attacks if they are triggered within 10 minutes. NOTE: that the base game will force the station to perform as normal - report your attack. I didn't find a method to prevent this native behaviour, unfortunately. The station will respond to your bomb and EMP attacks as normal. But the mod will not log them as a crime.
-Bug-fix: Bomb and EMP attacks via spacesuit would corrupt the internal crime data if triggered from within a ship. This caused the ship to not be listed in the menu and prevented you from paying for its fine.

v1.1.1, 19 Dec 2020:
-Tweak: CHC icon designed by Forleyor.

v1.1.0, 8 Dec 2020:
-Bug-fix: Compatibility with Alternatives to Death (ATD): CHC was removing the player's ship's protection from destruction set in ATD - leaving the ship destructible, which then prevents ATD from saving the player from the Game Over screen.
-Bug-fix: Previously, when an enemy releases your ship from their impound lot their station immediately attacks your ship. In this version, your ship will fly to the nearest neutral station before changing ownership to you.
-Bug-fix: Removed the delay between the ships getting confiscated and the ship flying to the nearest impound lot.

v1.0.1, 7 Nov 2020:
-Bug fix: Forfeiture of ship default to 0 hours - which is no forfeiture. This version changes your setting and sets the default to 14 hours. Re-set this to your liking.
-Bug-fix: Your stations were getting charged with attack and kill crimes.
-Bug-fix: Illegal cargo crimes on players were converting to attack crimes.

v1.0.0, 6 Nov 2020: Initial release.
