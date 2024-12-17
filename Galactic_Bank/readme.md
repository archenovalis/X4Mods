## Features

- Banking Clan has Vault Stations in major faction home sectors.
- Branch Offices are found in stations located within major faction-owned sectors.
- Interest Rate, Compounding Period, and Withdrawal Fee are set by player's reputation with Banking Clan.
- Banking Clan's ships transport credit lootboxes between vaults.
- Credit loot boxes drop from Banking Clan ships (do nothing for now, collect them for future profits).


## Requirements
- [SirNukes Mod Support APIs](https://www.nexusmods.com/x4foundations/mods/503)
- [SW Interworlds](https://sites.google.com/view/swinterworlds/Home)


## Planned Features
- Change Compounding Period to be based on Banking Clan Standing (Building Defense Stations near Vault Stations)

- Loot Boxes
 - Credit loot boxes drop from Banking Clan owned objects (including destroying a vault, but destroy a vault and everyone with a vault gets mad, super mad)
 - Rewards and reputation for finding and turning in the credit loot boxes.
 - Chance of large reputation decrease for opening credit loot boxes (unknown amount of credits, usually a lot, might not be; same large reputation decrease regardless of amount)
 - Use a Security Bypass to attempt to open it without risk. Might succeed on first try. Might require multiple.

- Closed Bank Offices
Branch offices will only be in stations owned by major factions with a functioning branch vault station.

- Bounty Hunters-
Bounty hunters will hunt you when your banking rep hits -10. Factions with vaults will drop to and freeze at -10 when you hit -20 banking rep.

Download: https://github.com/archenovalis/X4Mods/releases/tag/Galactic_Bank_v0.7


## Changelog

beta 1.0: Galactic Bank Offices are found in all stations.
Interest Rate, Compounding Period, and Withdrawal Fee are set by player's reputation with Banking Clan
  (Withdrawal fee is nerfed until Banking Clan have their own stations.)

beta 1.1: 
Banking Clan Vault Stations
Vaults are rebuilt within the same faction
Credit loot boxes drop from Banking Clan ships
Banking Clan has ships that transport credits between vaults

beta 1.11 spicy fix:
cleaned up
removed 2 (lag causing?) docks from vault station
should now be save compatible (faction relations updated upon install)

beta 1.12:
should now be save compatible

v0.6:
lots of changes. don't install this on top of a prior version. next patch will allow overwrite the old version.
added bank transfer api
added accounts for factions that can't or won't openly use the banking clan's vaults (sith, pirates, hapes, etc)
disabled bank loans NPC Reactions

v0.65:
icons, cleanup, menu improvement
still needs a clean install, v0.7 will overwrite beta installs

v0.7:
added sw credits icon
started implementing loot box opening
added more loot box wares
started testing dropping loot boxes when vaults are destroyed
added inheritance tax (for use with kuertee's alternatives to death)
should be compatible with prior versions