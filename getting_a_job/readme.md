# [Getting A Job](https://github.com/archenovalis/X4Mods/tree/getting_a_job)

Life isn't easy. It's a grind. The rich get richer and the poor...slowly get richer. Owning even a single multi-crew ship is a big deal. Starting a company, having a fleet of traders, your own militia? Yeah... dream big. It will take you a while to get there. Fast cash? Become a pirate and kill everything, or die trying. Tho, maybe you could go work for your faction earn a steady paycheck. I mean why not? The turtle was faster than the rabbit, in the end. Now go find that representative.
## Features
* **Get A Job**
* Work for a faction's government, available at 12+ relationship. Receive a paycheck deposited direct to your InterGalactic Bank account every 15 minutes. Basic paycheck for joining based on faction type (major=10k, peaceful=25k, pirate=4k).

* **Ship Prices**
The cost of purchasing ships has been increased to match their hull, and scale with their size.
```
S: no changes
M: ~3-7x
L: ~3.5-13x
XL: ~4-9x
XXL: ~5.5x
```
* **Rewards Decreased**
Missions, trading inventory items, selling craftables, trading software and deployables. Gone. Not really gone, but it's not how you'll get rich. Maybe missions, but not really trading the small stuff. Go become a pirate and loot lots of stuff, that's the easy way to become rich, or dead.
```Rewards reduced by 8 to 12.5% of normal.
Average inventory prices reduced by 5 to 20% of normal.
Inventory price spreads reduced by 8 to 12.5% of normal.
```
## Requirements
[Star Wars Interworlds](https://sites.google.com/view/swinterworlds/Home)
[InterGalactic Bank](https://discord.com/channels/614576717008207901/1309028894937972747/1309028897274466374)
[Crime has consequences](https://www.nexusmods.com/x4foundations/mods/566) (v7.1.10: Disable crimes towards subordinates are reassigned to their commanders)
[Alternatives to death](https://www.nexusmods.com/x4foundations/mods/551)
[Mod Support APIs](https://www.nexusmods.com/x4foundations/mods/503)
[UI Extensions and HUD](https://github.com/kuertee/x4-mod-ui-extensions/releases)


## Installation
* Download: https://github.com/archenovalis/X4Mods/releases/tag/Getting_A_Job_v0.1
* Extract to extensions directory.
## Planned Features
* **Get A Job**
  * Paycheck increases by a (1%, 0.1%, x%)? of all qualified missions completed while employed for the faction.
  * Missions pay more: Qualified missions receive a bonus 10% bonus.
  * Retire or Quit at any time. Retire after reaching pension levels. Multiple pension levels, based on total pay received.
* **New Statuses**
  * Deserter: not completing any military or support missions within last 120 minutes.
    * Consequence: Paycheck paused until next mission is completed.
  * Traitor: while working for or after quitting/retiring, being seen by a military ship after joining and while participating in an enemy faction's mission. Receive bribes to switch allegiance, become a spy for another faction.
    * Consequence: No more paycheck or pension. Relation set to -25 (spy: -30)
  * Spy: (requires relationship 25), allows joining enemy factions (will still become a traitor if participating in a military mission against your primary faction, and traitor status by the other faction as normal).
    * Spy missions: Occasional mission to return home (every (2,4,8)? hours; don't get spotted), and station sabotage (ie: before raids). 
    * Consequence: Spy bonus added to paycheck from main faction plus paycheck from other faction. Benefits your faction, harms the spied upon faction.
* **Player Economy Changes**
  * Research costs increased to 2x module's and 10x ship's sell price (same as buying blueprint from faction rep).
  * Contraband pays much more when working for a faction that produces it.


## Changelog
- v0.1: Early player economy changes are complete.
- v0.2: Basic Paycheck implemented