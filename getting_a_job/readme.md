# [Getting A Job](https://github.com/archenovalis/X4Mods/tree/getting_a_job)

Life isn't easy. It's a grind. The rich get richer and the poor...slowly get richer. Owning even a single multi-crew ship is a big deal. Starting a company, having a fleet of traders, your own militia? Yeah... dream big. It will take you a while to get there. Fast cash? Become a pirate and kill everything, or die trying. Tho, maybe you could go work for your faction earn a steady paycheck. I mean why not? The turtle was faster than the rabbit, in the end. Now go find that representative.
## Features
* **Get A Job**
* Work for a faction's government, available at 12+ relationship. Receive a paycheck deposited direct to your InterGalactic Bank account every 15 minutes. Basic paycheck for joining based on faction type (major=10k, peaceful=25k, pirate=4k).
* Paycheck increases by a 1% of all work missions while employed for a faction.
* Work missions pay more: 40-250% bonus (major=100%, peaceful=40%, pirate=250%).

* **Ship Prices**
The cost of purchasing ships has been increased to match their hull, and scale with their size. Selling prices of used ships reduced.
```
S: no changes
M: ~3-7x
L: ~3.5-13x
XL: ~4-9x
XXL: ~5.5x
```
* **Rewards Decreased**
Missions, trading inventory items, selling craftables, trading software and deployables. Gone. Not really gone, but it's not how you'll get rich. Maybe missions, but not really trading the small stuff. Go become a pirate and loot lots of stuff, that's the easy way to become rich, or dead.
```
Mission pay reduced by 16 to 6.25% of normal.
Average inventory prices reduced by 5 to 20% of normal.
Inventory price spreads reduced by 8 to 12.5% of normal.
```
## Requirements
[Star Wars Interworlds](https://sites.google.com/view/swinterworlds/Home) (!! STAR WARS !!)
[InterGalactic Bank](https://discord.com/channels/614576717008207901/1309028894937972747/1309028897274466374) (Money goes into your account, not teleported to your pocket)
[Kuertee: Crime Has Consequences](https://www.nexusmods.com/x4foundations/mods/566) (don't break the law, selling stolen ships is a crime)
[Kuertee: NPC Reactions](https://www.nexusmods.com/x4foundations/mods/497) (tip: use the taxi service to get onto enemy stations)

## Required Utility Mods
[Kuertee: UI Extensions and HUD](https://github.com/kuertee/x4-mod-ui-extensions/releases)
[Mod Support APIs](https://www.nexusmods.com/x4foundations/mods/503)

## Planned Requirements
[Kuertee: Alternatives to death](https://www.nexusmods.com/x4foundations/mods/551) (descendants will inherit your assets, not your paycheck. some accounts will have different amounts of inheritance tax. death causes you to lose your pocket money, keep it safe in an account)
[Teleport From Transporter Room](https://www.nexusmods.com/x4foundations/mods/553) (but only if you have the technology)
[Escape Pod](https://www.nexusmods.com/x4foundations/mods/596) (abandoned; i'll update/integrate it eventually)

## Installation
* Download: https://github.com/archenovalis/X4Mods/releases/tag/Getting_A_Job_v0.5
* Extract to extensions directory.
## Planned Features
* **Get A Job**
  * Retire or Quit at any time. Retire after reaching pension levels. Multiple pension levels, based on total pay received.
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
- v0.7: NPC Reactions, Teleport from Transporter Room, and Alternatives to Death modified and integrated, Escape Pod created