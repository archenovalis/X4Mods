NPC reactions
https://www.nexusmods.com/x4foundations/mods/497
by kuertee

Updates
=======
v7.1.16, 03 Dec 2024:
-New feature: Player's fleet follows the player: When taking control of a ship that is one of your immediate subrodinates, your other subordinates will auto-assign themselves to your new ship. Enable this in the mod's Extension Options. This is disabled by default.

Mod effects
===========
-Conversations with NPCs may produce a rumour (mission, anomaly, lockbox, data vault, reputation increase).
-Bar patrons. Between 1 and 4 hireable NPC of each type of profession (engineers, marines, pilots, and managers) of up to elite skills will be generated at bars.
-Bridge crew: Helm alerts of new contacts. Tactical alerts of shield damage. Engineering alerts of engine failures.
-NPC Constructors will request for your available build jobs.
-NPC Taxi: Hire a taxi from a ship console, bar patron or an NPC pilot of a ship.
-Bank loans: Station managers offer 1,000,000 Cr loans.

Requirements
============
SirNukes Mod Support APIs mod (https://www.nexusmods.com/x4foundations/mods/503) - for Lua Loader and Simple Menu Options
Kuertee's UI Extensions mod (https://www.nexusmods.com/x4foundations/mods/552) - Modded Lua files with callbacks to allow more than one mod to change the same UI element.

Bridge crew
===========
Your bridge crew will alert you of the following events.

Helm will raise the alarm, "Enemy spotted.", when:
a new enemy ship is detected by your radar when:
- the enemy ship is sized L or XL,
- or the enemy is the first enemy contact in the engagement,
- or a minute has passed since the last alert,
- or the enemy is larger than your ship AND 30 seconds have passed since the last alert. (Configurable in the Extensions Options.)

Tactical will raise these alarms:
- "Shields hit." when shields fall below 75%,
- "Taking shield damage." at 50%,
- "Shields are down." at 25%.

Engineering will raise the alarm, "Engine needs fixing.", when:
- an engine fails.

Helm, Tactical and Engineer are randomly chosen from NPCs on the bridge. If there are no NPCs on the bridge, the crew is randomly chosen from the service crew. Because NPCs move quite often, these personnel will change during engagements. (I've actually not been able to stop NPCs from walking off. I've been trying ever since the "Bar patrons" feature was released.)

Without service crew, alerts will not be raised.

Bridge crew: AI Pilot
=====================
Features:
1. The AI pilot of your last controlled ship will always get up from the seat when you enter.
2. The "Give order." conversation option with any of your AI pilots will open the map with their ship pre-selected so that you can directly give them an order.

Report Enemies
==============
Ships on Explore, Patrol, Police, and Protect orders can report on detected enemies.
This is similar to the Alerts set in the Global Orders menu. But no Alerts need to be set for Report Enemies to work.
Enable this behaviour in the ship's Behaviour menu when first giving the order.
By default, ships will send a radio broadcast when large enemies (L and XL) are detected.
Small to frigate class ships reports are sent as a Notification.
And all reports are logged.

Recommendation: Get the 5.1.0303 version of UI Extensions to enable the Logbook button on the Information menu. A general impression of events in a sector can be accessed easily with this feature.

Scouts
======
Ships on Explore, Patrol, Police, and Protect orders can be set to flee from all enemies.
This allows for creation of true scouts that can be used as early warning systems.

Bar patrons
===========
Between 1 and 4 hireable NPC of each type of profession (engineers, marines, pilots, and managers) of up to elite skills will be generated at bars.

NPC constructors
================
After the Station Configuration Menu is closed all the way to the HUD, available NPC construction vessels will ask "Need a constructor?" via Comm. Awarding them the job will cost the standard fee for hiring construction vessels.

NPC construction vessels that you own will request for the jobs first before NPCs from friendly or neutral factions.

NPC SOS
=======
Accepting a request for back-up creates a mission. Your reward is based on how many enemies you destroy. And this reward is additional to the general bounty given to you by the sector's faction authority.

NPC taxi
========
Request for a transport at a Ship Console or from a bar patron. Or board an NPC ship and talk to the pilot.

This is a good way to simply sit back (Stand behind the pilot is more like it), relax, and see the galaxy. Or use this to enter an enemy station, or dock on an enemy ship.

The NPC may have trouble docking. If the NPC gets stuck trying to dock, disembark at your destination automatically by using the Transporter Room. The "Disembark" button becomes available when the NPC pilot announce that you've arrived at your destination.

Bank loans
==========
Station managers offer 1,000,000 Cr loans with an interest of 1% per hour calculated every 5 minutes. Only station managers of factions that you have a relationship with of 10 or more offer these bank loans.

All loans are listed in the Account Management menu.

Conversations
=============
Clicking on an NPC or contacting an NPC via the Comm command initiates a conversation.

The chance a conversation produces a meaningful rumour increases by 1% at every new conversation.
Conversing with an NPC of the same race gives a 2.5% bonus to this chance.
Conversing with an NPC from a friendly faction, another 2.5% bonus.
Conversing with an NPC from a friendly faction while in an enemy sector, a further 2.5% bonus.
Conversing while in a bar, a further 2.5% bonus.
These bonuses can be customised in the mod's Extension Options.

If a conversation produces a meaningful rumour, one of these conversation topics becomes available:
-(Chat about the wars/life in space/science/the galaxy): A generic mission based on the NPC's profession and/or role. There is a 60% chance for this type of rumour.
-(Chat about politics): Increases your relation with the NPC's faction. 15% chance.
-(Chat about lockboxes): The location of a lockbox. 15% chance.
-(Chat about anomalies): The location of an anomaly. 5% chance.
-(Chat about data vaults): The location of a data vault. 5% chance.
An NPC can offer only one meaningful rumour per hour.

When a conversation produces a meaningful rumour, the chance for the next meaningful rumour is reset to 0%.
However, a base chance is increased by 1%.
This can be considered to be a 'conversation skill', 'speech skil', 'charisma attribute', etc.
This 'conversation skill' is added to the chance for the next meaningful rumour.
This 'conversation skill' starts at 10% and is capped at 50%.

This 'conversation skill' degrades by 0.25% every hour you don't have at least one direct (i.e. face-to-face) conversation.
This should be negated by your day-to-day activities like: checking with traders for argnu beef, picking up passengers, talking to faction representatives, etc.
This penalty can be customised in the mod's Extension Options.

Generic missions
================
Depending on the NPC's profession and/or role, the generic mission offered will be one of following:
-(Chat about the wars): This will produce combat-type missions. NPC's who are marines, officers, pilots, or similar professions offer these types of missions.
-(Chat about life in space): Economic-type missions. Offered by any other NPC.
-(Chat about science): Engineering-type missions. Offered by any other NPC.
-(Chat about the galaxy): Any of the three above. Offered by faction representatives and black marketeers.

Mod Support APIs compatibility
==============================
These are optional features that are available when SirNuke's Mod Support APIs mod (https://www.nexusmods.com/x4foundations/mods/503) is installed.

When installed, these mod options can be customised:
-No direct conversation penalty
-Same race bonus
-Friendly faction bonus
-Friendly faction in enemy sector bonus
-In bar bonus

When installed, the cost of accepting NPC construction vessel contractors will be taken from the base game's configuration file - which can be changed by a 3rd party mod. It's simply impossible for my mod to determine how much construction vessels cost without SirNuke's mod installed. When it's not installed, the cost is set at 50000 credits - the default cost at the time of this release.

Note that the cost of hiring construction vessels via the map (as per the base game) will be as normal. I.e. whatever cost is as set by the base game or by another 3rd party mod.

Install
=======
-Unzip to 'X4 Foundations/extensions/kuertee_npc_reactions/'.
-Make sure the sub-folders and files are in 'X4 Foundations/extensions/kuertee_npc_reactions/' and not in 'X4 Foundations/extensions/kuertee_npc_reactions/kuertee_npc_reactions/'.
-If 'X4 Foundations/extensions/' is inaccessible, try 'Documents/Egosoft/X4/XXXXXXXX/extensions/kuertee_npc_reactions/' - where XXXXXXXX is a number that is specific to your computer.

Troubleshooting
===============
Do not change the file structure of the mod. If you do, you'll need to troubleshoot problems you encounter yourself.

Open the Chat window by tapping the tilde (`) key, the key above the Tab key.
Disable all sub-mods by typing "debug npcr disable" in the Chat Window.
Re-enable all sub-mods by typing "debug npcr enable" in the Chat Window.

Uninstall
=========
-Delete the mod folder.

Debugging
=========
(1) Allow the game to log events to a text file by adding "-debug all -logfile debug.log" to its launch parameters.
(2) Enable the mod-specific Debug Log in the mod's Extension Options.
(3) Play for long enough for the mod to log its events.
(4) Send me (at kuertee@gmail.com) the log found in My Documents\Egosoft\X4\(your player-specific number)\debug.log.

Credits
=======
By kuertee.
German localisation by Herman2000.
Russian localisation by KotMurzilka1974.
Chinese localisation by ycy2750617.

History
=======
v7.1.13, 02 Nov 2024:
-Bug-fix: Scouts will not flee from non-dangrous enemies.

v7.1.07, 17 Sep 2024:
-Tweak: Mission offers from conversations are offered from the faction of the NPC 75% of the time. At other times, the mission is offered by a random faction. Previously, all mission offers are from random factions regardless of the NPC's faction.

v7.1.03, 18 Jul 2024:
-Tweak: NPC Taxi: A cutscene is shown on the Target Monitor when the taxi approaches the station.
-Bug-fix: Disembarking from the cutscene wasn't updating the mission objective to "Rehire Taxi".

v7.1.02, 13 Jul 2024:
-Tweaks: Bridge crew: ensure npc is player-owned.

v7.1.01, 7 Jul 2024:
-Bug-fix: Bridge Crew: "We've arrived at our destination." during autopilot were sometimes skipped.

v7.1.00, 3 Jul 2024:
-Bug-fix: In lua, changed the use of the obsolete GetSoftTarget to GetSoftTarget2.

v7.0.02, 29 Jun 2024:
-Tweak: 7.00 hf 1 compatibility. Disabled in Timelines scenarios.

v6.2.013, 25 Feb 2024:
-Compatibility: With Mycu's Verbose Transaction Log mod, money transfers from this mod will be labeled: Bank loan, Bank loan payment, Construction ship hire, Taxi hire in the Transaction Log menu.

v6.2.011, 18 Feb 2024:
-New feature: Support for More rooms mod. (Hopefully working.)
-Tweak: Player-ship radar contact reports obey the Report enemies settings.
-Tweak: Taxi: When hiring a taxi when in conversation with an NPC pilot, the pilot doesn't say "Wel'll be undocking soon." twice anymore. Previously, they said when you confirmed payment then again just before take off.

v6.2.007, 4 Dec 2023:
-New feature: Bridge Crew: announces when your autopilot reaches its destination.
-Tweak: Bridge Crew: Detected criminal mass traffic are not logged to the logbook.
-Tweak: Bar Patrons: NPCs from pirate factions in bars.

v6.2.001, 10 Sep 2023:
-Tweak: 6.2 compatibility.
-Bug-fix: Construction ships requesting for jobs were decling after you approve the job.
-Bug-fix: Bridge Crew: alerts were not working when you have no AI pilot assigned to your ship.
-Tweak: Bar Patrons: Terran bars will not have NPCs that have less than neutral relationship the Terran faction.

v6.1.004, 01 Aug 2023:
-Bug-fix: Reports of enemy drones and lasertowers were getting logged into the player's log.

v6.1.003, 29 Jul 2023:
-Tweak: Enemy reports from your bridge crew are now logged like enemy reports by your NPC ships.
-Tweak: Kuda 6.1.002 compatibility.
-Chinese localisation: Thanks to ycy2750617!

v6.1.001, 28 Jun 2023:
-Bug-fix: Prevent finding lockbox mission from producing errors in the log.

v6.0.002, 13 Apr 2023:
-Bug-fix: Tides Of Avarice compatibility: Axiom will now not get-up from the controls when he needs to fly you to his destination.

v6.0.0004, 18 Feb 2023:
-New feature: The ship you requested to dock on will stop their flight and wait for you to dock.

v5.1.0313, 31 Oct 2022:
-Bug-fix: Clean-up of data of loans at destroyed (or removed) stations was not happening causing the UI to crash.

v5.1.0308, 29 Sep 2022:
-Bug-fix: Ships weren't obeying their "Report enemies" behaviour options.

v5.1.0306, 18 Sep 2022:
-Tweak: Compatibility with Kuda v5.1.0305's changes to Escort AI.

v5.1.0304, 3 Sep 2022:
-Bug-fix: Escorts of ships set to not attack enemies were attacking.

v5.1.0303, 1 Sep 2022:
-New feature: Ships on Explore, Patrol, Police, and Protect orders can report on detected enemies.
	This is similar to the Alerts set in the Global Orders menu. But no Alerts need to be set for Report Enemies to work.
	Enable this behaviour in the ship's Behaviour menu when first giving the order.
	By default, ships will send a radio broadcast when large enemies (L and XL) are detected.
	Small to frigate class ships reports are sent as a Notification.
	And all reports are logged.
-New feature: Ships on Explore, Patrol, Police, and Protect orders can be set to flee from all enemies.
	This allows for creation of true scouts that can be used as early warning systems.
-Bug-fix: NPC Taxis: Remove the "Call For Transport" button from the dock consoles when the feature is disabled.
-Tweak: NPC Constructors: Remove busy constructors to prevent them requesting for your build jobs then rejecting them.

v5.1.0301, 17 Jul 2022:
-New feature: The "Hold Position" order that was added to your last controlled ship can now be disabled. Note that I still find it enabled better than the base game's "Wait for signal" order.
-New feature: Star Wars Interworlds support: NPC Constructors should now request your build jobs. This wasn't working on SWI in previous versions.

v5.1.0009, 23 May 2022:
-Tweak: Taxis: When asking to fly to the nearest shipyard/wharf, allow stations owned by enemies of the player.
-Bug-fix: Taxis were accepting the job even if the player can't afford the fee.
-Bug-fix: NPC Construction Ships does not ask to build your stations that have been destroyed.

v5.0.0013, 30 Mar 2022:
-Bug-fix: Taxi: Reveal the sectors the Taxi you're in traverses unknown sectors.
-Bug-fix: Bar Patrons: They were constantly moving from one  part of the bar to another.
-Bug-fix: Taix: Some M-sized taxis were not detecting when you've entered their cockpit.
-Bug-fix: Bridge Crew: Do not target the enemy after interacting with the alert unless you're in control of the ship.

v5.0.001, 18 Mar 2022:
-Removed feature: SOS Missions from NPC has been removed because it's been made obsolete by the same mission in my other mod, Emergent Missions.
-Bug-fix: Bar patrons were walking out of bars. They're suppose to walk around in the bar.
-Bug-fix: The conversation counter (which determines if an NPC has rumour to share) wasn't getting reset when you decline to listen to the rumour. This resulted in every NPC that you converse with having a rumour if you never activate the rumour topic.
-New feature: Bridge crew: Your last ship will wait where you last left it UNTIL you take control of another ship at which time they'll proceed with their queued orders. I know this was a feature in the base game, but I found it broken during the 5.0 beta. Egosoft might have fixed it since. Even if they had, this feature still works as override of it. Also, the NPC will never ask for you signal to them to proceed with their orders as in Egosoft's previous version of this feature. (Note that that previous version also gave an automatic and quiet signal when you took control of another ship - like in this feature. So why add this feature? Because I know it works and don't want to chase after my ship again in the future in case Egosoft breaks their feature again. :D)

v4.2.0804, 2 Feb 2022:
-Tweak: SETA support: prevent all comms from this mod while SETA is active.
-Tweak: Bridge crew selection: will select anyone on the bridge or cockpit when an alert is required. Previously, the mod "tried" (but wasn't totally successful) in assigning NPCs on the ship to a dedicated crew position (helm, tactical, engineer).

v4.2.073, 4 Jan 2022:
-New feature: Bridge crew: "Give order." conversation option with any of your AI pilots will open the map with their ship pre-selected so that you can directly give them an order. This is more tactile than the base game's actions to give an AI pilot an order: open map, select ship, give order.

v4.2.072, 4 Jan 2022:
-Bug-fix: New game bug: Auto-get-up variable not initialised. You don't need to start a new game. You can continue playing with your current game. The bug from the previous version only didn't initialise the variable.

v4.2.071, 3 Jan 2022:
-Bug-fix: The mod was creating its rooms and npcs when you arrive at the station instead of when you actually dock or teleport to it.

v4.2.07, 2 Jan 2022:
-Bug-fix: Teleporting in and out of stations wasn't detected, so the mod's custom rooms and NPCs were not created when teleporting into a station.

v4.2.06, 30 Dec 2021:
-Tweak: Ship-class-based AI auto-get-up Extension Options.

v4.2.02, 16 Dec 2021:
-New feature: Extension Options that disables the feature that makes the AI pilot of the last ship you controlled to get up when you enter the cockpit.

v4.2.01, 13 Dec 2021:
-New feature: NPC Bridge Crew: The AI pilot of the last ship you piloted will get up out of their seat when you enter the cockpit - saving you those precious several seconds!
-Bug-fix: Bar Patrons: Populate all the bars. Several bars may actually be spawned at a station, but only one is available from the Transporter Room. E.g.: One bar is always spawned for the blackmarketeer. But until he becomes available, the bar is removed from the Transporter Room panel. But if a taxi mission is created at the station, a secondary bar MAY be created. Several taxi missions from one station may spawn several bars. In this version, the Bar Patrons feature will spawn at all bars instead of the first random bar the feature found first in previous versions.
-Bug-fix: Standardised the event listeners for: arrive at station, dock, undock, leave station in my mods that need them with these events: attention change, dock, undock, teleport. In previous versions, these events were handled inconsistently that resulted in intermittent bugs like: (in Reputations and Professions) the Guild Network button become disabled after docking even if it was available before docking, (in High-security Rooms Are Locked) the mission NPC not getting moved to an unlocked room, (in several mods) mod NPCs, like the Mod-Parts Trader not getting spawned in their rooms, etc.

v4.2.0, 10 Dec 2021:
-Bug-fix: Clean-up mod-specific NPCs at stations after the player teleports. Previously, they were cleaned-up only when the player leaves the station's vicinity.
-Bug-fix: Unpaid bank loans crimes were getting lost after exiting the game.
-Tweak: Support for Social Standings and Citizenships (SSaC) mod: because SSaC may remove friendly and alliance licences, relations are checked against Relationship Points (e.g. 10+, 20+).

v4.1.0, 06 Nov 2021:
-New feature: Unpaid Loans is a crime if you have my other mod, Crime Has Consequences mod, installed.
-Tweak: The bank loans UI is now shown beside the Accounts UI.
-Tweak: The NPCs Request Backup feature is disabled if my other mod, Emergent Missions, is installed.
-Bug-fix: Bridge crew: Stop the video comm when you acquire a new target.

v2.2.4, 09 Sep 2021:
-Bug fix: Re-acquire bridge crew if the game re-instantiates the NPCs on the ship.

v2.2.3, 11 Aug 2021:
-Tweak: Request back-up missions now reward you a minimal value if the ship escapes without you destroying any of their enemies.
-Tweak: Bridge crew: time-outs for hit detection for reporting on hull and shield levels.

v2.2.2, 26 Jul 2021:
-Bug-fix: silence debug logs.

v2.2.1, 25 Jul 2021:
-New feature: Accepting a request for back-up now creates an actual mission. Your reward is based on how many enemies you destroy. This reward is additional to the general bounty given to you by the sector's faction authority. Previously, accepting a request for back-up only added a Guidance Mission to the ship.
-Tweak: Manager's bank loans are only available if your relationship with the faction is 10 or more.

v2.2.0, 11 Jul 2021:
-Tweak: Removed the "Dock at nearest shipyard/wharf" when speaking to your ai pilot. It clutters up the default converstation topics.

v2.1.9, 03 Jul 2021:
-Tweak: Bridge Crew: I removed my changes (i.e. diffs) to Egosoft's code that forced bridge crew members to stay on the bridge. 4.1beta1 showed that they were changing that portion of the code significantly enough that I decided to remove it and re-visit when 4.1 is released. With this tweak, bridge crew will move around the ship as normal. You'll sometimes see them at the ship's docking bays, for example.

For both v4.0 and v4.1beta1 of the game.
This version may or may not work in other v4.1betaX versions.
v2.1.8, 19 Jun 2021:
-Compatibility: Update so the previous changes for v4.1beta1 of the game work in v4.0 of the game.
-Bug-fix: The handling of the possibility of a bridge crew getting re-assigned elsewhere by the player was running when in your spacesuit.

For v4.1beta1 of the game:
v2.1.7, 15 Jun 2021:
-Compatibility 4.1beta1: Station seed property used in creating rooms.
-Compatibility 4.1beta1: NPC State Machine for AI pilots in player ships.
-Bug-fix: Bridge crew getting disabled intermittently while in flight - requiring the player to get up and then re-take the controls.
-Bug-fix: Bridge crew: handle when crew changes - e.g. when their post is changed by the player.

For v4.0 of the game:
v2.1.6, 7 Jun 2021:
-Bug-fix: Player Info menu sometimes stalls when rendering the bank loans.

v2.1.5, 29 May 2021:
-Tweak: Better selection of bridge crew. Better prioritsing of NPCs already on the bridge. Better method of making them stay on the bridge.
-Tweak: Rumours now stick on the Conversation Menu until you select it or it expires.
-Tweak: Bar Patrons now move around the bar. Previously, they were stuck in their starting positions.
-Bug-fix: Data vault and anomaly rumours were broken. They would be presented as rumours in the Conversation Menu but their missions weren't getting created.
-Bug-fix: Various bugs when the mod, Extended Conversation Menu, is installed.

v2.1.4, 4 May 2021:
-New feature: Bridge crew: Radar contacts can be targeted when you interact (key F) with the alert video comm.
-Tweak: Changing the target will remove the video comm immediately.
-Bug-fix: Extensions Options for Bridge crew wasn't working.

v2.1.3, 29 Apr 2021:
-Bug-fix: Hiring bar patrons was broken. It was a bug introduced by the previous version which made the bar patrons stay in the bar, rather than walking all around the station. Fixed now in this version.
-Bug-fix: The option for using the older cutscene, ShowPilot, for video comms wasn't getting used.

v2.1.2, 28 Apr 2021:
-Bug-fix: Brdige crew: in the previous version, bridge crew wasn't getting set for your first engagement. It required a second engagement (i.e. you to move to another sector or enter then leave Travel Mode) for the bridge crew to be set.
-Tweak: Bar patrons: You can limit the races of NPCs that spawn in bars to the races internally listed in the station's workforce. In previous versions, races were totally random - within the limits of factions neutral to the station.

v2.1.1, 25 Apr 2021:
-New feature: Enable/disable the mod's different packages: Rumours, Bank loans, Bar patrons, Bridge crew, NPC SOS, NPC Constructors, NPC Taxi.
-Bug-fix: Bridge crew: video cutscene was trying to initiate with uninstanced actors, causing the the video comm to get stuck on the interference pattern.
-New feature: Brige crew: They now stay on the bridge, per engagement. Engagements are separated by entering travel mode, changing sectors and exiting ship controls.
-New feature: Bridge crew: "Captain." greeting - just so you know your crew is ready. (And for me, as the developer, that the event cues are in the correct "waiting" state.)
-Tweak: Better implementatino of "Extended conversation menu". Some conversation options are based on conditions. In the previous version, all conversations are sent to ECM (if it is installed). The problem is when no conversation options are based on those conditions, which sometimes leaves the conversation empty, requiring the player to Escape out of it.

v2.1.0, 22 Apr 2021:
-New feature: Bridge crew: Helm alerts of new contacts. Tactical alerts of shield damage. Engineering alerts of engine failures. Read more below.
-New feature: Compatibility with iforgotmysocks' Extended Conversation Menu (ECM) - if used. ECM is optional.
-New feature: Now uses Egosoft's new Cutscene for comms that shows the interior of the ship.
-Bug-fix: Cost of a taxi was not getting calculated when speaking to an NPC pilot on the bridge of his ship.
-Bug-fix: You are now allowed to have multiple NPC SOS Guidance Missions. Be sure to use my other mod, UI Extensions, that allows multiple Guidance Missions.

v2.0.3, 18 Apr 2021:
-Bug-fix: Was using a text reference from "Crime has consequences". Fixed in this version.
-Bug-fix: Destroys unused taxis on game load. Previously, some taxis that you do not take were not getting deleted because: my deletion loop deletes from the beginning of the list taxis not taken - which then shifts the list one place. the next deletion is of the next taxi, skipping a taxi because of the shift. the best practice is to delete from the end of the list - which prevents this bug, which this version now does. Note that taxis are created every time you speak to a bar patron so that their conversation options, if the bar patron was randomly chosen to "know" a pilot, include the taxi's reference.

v2.0.2, 21 Mar 2021:
-Bug-fix: Bank loans were not getting calculated still (becasue I'm stupid sometimes)! Fixed now.

v2.0.1, 19 Mar 2021:
-Bug-fix: Bank loans had no interest calculation.

v2.0.0, 11 Mar 2021:
-New feature: updated for v4.0.0 beta 11 of the base game.
-Tweaks: Cleaned-up unnecessary localisation files. Rewrote content.xml manifest file.
-New feature: Bar patrons: Between 1 and 4 hireable NPC of each type of profession (engineers, marines, pilots, and managers) of up to elite skills will be generated at bars.
-New feature: NPC SOS hails: NPCs that request backup will hail you via comms. A Mission Guidance can be created to them when you interact with their hail.
-New feature: Bank loans: Station managers offer 1,000,000 Cr loans.

v1.3.3, 6 Nov 2020:
-Bug-fix: Taxi service: The re-hire mission update, after you disembarked at your destination, wasn't getting set.

v1.3.2, 2 Nov 2020:
-Updates: Taxi service: new code for the main taxi to destination sequence. Bug-fixes and new features as described below.
-New feature: Taxi: All taxis are in a custom Taxi Service faction.
-Bug-fix: Taxi service: The Taxi Service faction allows all taxis to dock on any station and ship.
-Bug-fix: Taxi service: Taxis were previously cancelling their taxi orders. The Taxi Service faction allows us full control of the taxis.
-Bug-fix: Taxi service: If the taxi needs to land on another ship, that code sends the wait order to the receiving ship. Previously, I was relying on the base game's behaviour of ships waiting for other ships to dock with them. This was unreliable. This new version prevents this bug from occuring.
-New feature: Taxi service: Upon disembarking, taxis now wait for you (for 5min) - incase you want to re-hire them. This is required because the Ship Console is disabled on enemy stations and ships.
-Bug-fix: Taxi service: Gate distance is now added to taxis hired from black marketeers.
-Tweak: Taxi service: Added speed to the ETA notification.
-Bug-fix: NPC construction ships: Jobs are cancelled when the station is destroyed.
-Bug-fix: NPC reactions: the finding of galaxy missions are extended to further clusters if none are found in nearby clusters.
-Update: Pilot cutscene caption standardised with my other mods. I.e. name, faction, ship/station, caption.

v1.3.1, 14 Sep 2020:
-New feature: Gate distance multiplier for the cost of taxis.
-Bug-fix: The list of available taxis should now only include those piloted by NPCs. Previously, drones, laser towers, and such were getting listed.
-Bug-fix: The player can now enter/exit the taxi while the taxi is still docked without the taxi AI terminating. Previously, the taxi AI would quit once the player exits even if the taxi had not left the dock.

v1.3.0, 29 Aug 2020:
-Tweak: NPC construction ships: convo of job request.
-Tweak: Uses UI Extensions and HUD mod for Lua changes.
-Bug-fix: NPC reactions: Rumours about military, economic, and scientific missions were generating only in friendly sectors. Now in neutral sectors, too.
-Bug-fix: NPC reactions: Declined missions do not stick in the Accepted Missions lists anymore.
-Tweak: NPC reactions: Disabled on enemies.
-Tweak: NPC reactions: Disabled on mission actors.
-New feature: NPC taxi: Call for transport from a ship console on a dock or from a patron in a bar. Or board an NPC ship and ask the pilot to transport you.

v1.2.0, 24 Jun 2020:
-New feature: Available NPC construction vessels (your employees first, then from friendly or neutral factions) will request jobs from you.
-New feature: Conversing while in a bar adds a 2.5% bonus to the chance a conversion produces a meaningful rumour.

v1.1.3, 6 Jun 2020:
-Tweak: get_safe_pos tweaks to ensure objects are inside the search area.
-Tweak: Ensure Init cue is in waiting state.
-Tweak: Cleaned-up cue instantiations.

v1.1.2, 25 May 2020:
-Bug fix: lockbox, data vault and anomaly missions were broken in the previous version.

v1.1.1, 23 May 2020:
-Bug-fix: The random chance of a meaningful rumour in the previous version was always 100%.

v1.1.0, 22 May 2020:
-Added this rumour topic: (Chat about politics): Increases your relation with the NPC's faction. 15% chance.
-Conversing with an NPC from the same race gives a 2.5% bonus to the chance of a meaningful rumour.
-Conversing with an NPC from a friendly faction, another 2.5% bonus.
-Conversing with an NPC from a friendly faction while in an enemy sector, a further 2.5% bonus.
-An NPC can offer only one meaningful rumour per hour.
-Generic missions are categorised as: combat, economic, engineering. The type of mission offered will be based on the NPC's profession and/or role.
-Your 'conversation skill' degrades by 0.25% every hour you don't have at least one direct (i.e. face-to-face) conversation. This should be negated by your day-to-day activities like: checking with traders for argnu beef, picking up passengers, talking to faction representatives, etc.
-Extension options support: Customise the penalties and bonuses above. Read below for more info.

v1.0.0, 12 May 2020: initial release.