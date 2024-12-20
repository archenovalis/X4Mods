# [Getting A Job](https://github.com/archenovalis/X4Mods/tree/getting_a_job)

Life isn't easy. It's a grind. The rich get richer and the poor...slowly get richer. Owning even a single multi-crew ship is a big deal. Starting a company, having a fleet of traders, your own militia? Yeah... dream big. It will take you a while to get there. Fast cash? Become a pirate and kill everything, or die trying. Tho, maybe you could go work for your faction earn a steady paycheck. I mean why not? The turtle was faster than the rabbit, in the end. Now go find that representative.
## Features
### Get A Job
Work for a faction's government, available at 12 relationship.
* Receive a paycheck deposited direct to your InterGalactic Bank account every 15 minutes. Basic paycheck for joining based on faction type (major=10k, peaceful=25k, pirate=4k).
* Paycheck increases by a 1% of all work missions while employed for a faction.
* Work missions pay more: 40-250% bonus (major=100%, peaceful=40%, pirate=250%).
### Become A Spy
Use a stealth ship to teleport onto stations and ships. Conduct sabotage missions. Help your faction by harming their enemies.
* Stealth ship mod and teleportation inventory hacker
* (Planned) Ship and station sabotage missions
* (Planned) Faction police and military ships detect when you are working for other factions
### Banking System
Paychecks and mission rewards are deposited into your bank accounts. Money in your accounts is protected from loss due to death.
* Major and some Minor factions use the Banking Clan's InterGalactic Bank. Some Minor factions have their own. Some situations might hand you cash.
* Compounding Interest is earned. Good relations with the Banking Clan can be very profitable.
* Bank Transports can be robbed for lootboxes.
* (In Development) Open lootboxes for credits, there might be risks involved, so use a security override.
* (Planned) Attacking Bank Vault Stations for lots of lootboxes.
### Slowed Early Game
* **Ship Prices**
The cost of purchasing ships from npcs has been increased, scaling with their size. Selling ships to npc stations reduced by 25-50%, further reduced by hull%.
```
S: no changes
M = 3.5x,
L = 5.2x,
XL = 7x,
XXL = 4.5x,
```
* **Mission Rewards**
Missions, trading inventory items, selling craftables, trading software and deployables. Gone. Not really gone, but it's not how you'll get rich. Maybe missions, but not really trading the small stuff. Go become a pirate and loot lots of stuff, that's the easy way to become rich, or dead.
```
Mission pay reduced by 16 to 6.25% of normal.
Average inventory prices reduced by 5 to 20% of normal.
Inventory price spreads reduced by 8 to 12.5% of normal.
```
### Death Has Consequences
But it isn't game over there are Alternatives to Death (thanks Kuertee): Clones and Descendants. Clones prevent consequences while descendants allow you to partially start over. However, clones are expensive, so when you hear your ship's abandon ship alarm, quickly get to your escape pod. Else, you'll feel the consequences of death:
```
(Planned) Faction relations are softened
Paychecks and all cash on hand are all lost
Cash in accounts are reduced by the account's inheritance tax
```

## Required Mods
* [Star Wars Interworlds](https://sites.google.com/view/swinterworlds/Home) (!! STAR WARS !!)
* [InterGalactic Bank](https://discord.com/channels/614576717008207901/1309028894937972747/1309028897274466374) (Money goes into your account, not teleported to your pocket)
## Required Utility Mods
* [Mod Support APIs](https://www.nexusmods.com/x4foundations/mods/503)
* [Kuertee: UI Extensions and HUD](https://github.com/kuertee/x4-mod-ui-extensions/releases)
## Installation
* Download: https://github.com/archenovalis/X4Mods/releases/tag/Getting_A_Job_v0.7
* Extract to extensions directory.
## Planned Features
* **New Statuses**
  * Deserter: not completing any work missions within last 120 minutes.
    * Consequence: Paycheck paused until next mission is completed.
  * Traitor: while working for or after retiring from a faction, and being seen by one of their military ships while participating in a non-ally faction's mission.
    * Consequence: No more paycheck or pension. Relation set to -25 (spy: -30)
  * Spy: (requires relationship 25), allows joining enemy factions (will still become a traitor if participating in a military mission against your primary faction, and traitor status by the other faction as normal).
    * Receive bribes to switch allegiance, become a spy for an enemy faction.
    * Spy missions: Occasional mission to return home (every (2,4,8)? hours; don't get spotted), and station sabotage (ie: before raids). 
    * Consequence: Spy bonus added to paycheck from main faction plus paycheck from other faction. Benefits your faction, harms the spied upon faction.
* **Player Economy Changes**
  * Only sell stolen ships to the prior owners enemies or pirates. Different factions pay different amounts depending upon type of ship (military or industry)
  * Research costs increased to 2x module's and 10x ship's sell price (same as buying blueprint from faction rep).
  * Contraband pays much more when working for a faction that produces it.
  * Reverse engineer ships to get blueprints.

## Changelog
- v0.1: Early player economy changes are complete.
- v0.2: Basic Paycheck implemented
- v0.21: Sell ships mechanic replaced, reduced ship sell price to 50%.
- v0.5: Work Missions implemented. Mission pay cut in half. Work mission bonus pay increased by 40-250%.
- v0.55: integrated kuertee emergent missions and faction requirements, replaced all vanilla rewards with bank transfers
- v0.60: sell ships implemented
- v0.7: NPC Reactions, Teleport from Transporter Room, and Alternatives to Death customized and integrated. Escape Pod mod created and integrated. Death causes you to lose all cash on hand, keep it safe in a bank. Clones are expensive, but no penalties upon death. Descendants will also cost reputation, starting your paycheck over (pensions will persist), and incur inheritance taxes