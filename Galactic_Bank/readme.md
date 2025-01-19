Discord: [https://discord.gg/JbqMzcfS3Y](https://discord.gg/JbqMzcfS3Y)
Channel: [https://discord.com/channels/614576717008207901/1309028894937972747/1309028897274466374](https://discord.com/channels/614576717008207901/1309028894937972747/1309028897274466374)

The Banking Clan's InterGalactic Bank is proud to announce a once in a lifetime, hurry now before it is too late, very special, just for you, opportunity to open an account with us.

## Features
- Banking Clan has Vault Stations in major faction home sectors.
- Branch Offices are found in stations located within major faction-owned sectors.
- Bank Loans (collateral requirement based on relations)
- Interest Rate, Compounding Period, and Withdrawal Fee are set by player's reputation with Banking Clan.
- Banking Clan's ships transport credit lootboxes between vaults.
- Right click when near station to remotely access account.
- Credit loot boxes drop from Banking Clan ships (do nothing for now, collect them for future profits).
- Some minor factions have their own accounts.
- Change Compounding Period to be based on Relation with Banking Clan
- Loot Boxes
  - Credit loot boxes drop from Banking Clan transports
  - Rewards and reputation for finding and turning in the credit loot boxes.
  - Chance of large reputation decrease for opening credit loot boxes (unknown amount of credits, usually a lot, might not be; same large reputation decrease regardless of amount)
  - Use a Security Bypass to attempt to open it without risk. Might succeed on first try. Might require multiple.
- Bounty hunters will hunt you when your banking rep hits -10. Find a way onto the station to bribe the banker.

## Requirements
- [SirNukes Mod Support APIs](https://www.nexusmods.com/x4foundations/mods/503)
- [SW Interworlds](https://sites.google.com/view/swinterworlds/Home)

## Planned Features
- Bank Loans (fear the repo man)
- Lootboxes drop when destroying vaults
- Closed Bank Offices
Branch offices will only be in stations owned by major factions with a functioning branch vault station.

Download: [https://github.com/archenovalis/X4Mods/releases/tag/Galactic_Bank_v0.9.6RC](https://github.com/archenovalis/X4Mods/releases/tag/Galactic_Bank_v0.9.6RC)

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
some minor factions have their own banks
added sw credits icon
started implementing loot box opening
added more loot box wares
started testing dropping loot boxes when vaults are destroyed
added inheritance tax (for use with kuertee's alternatives to death)
should be compatible with prior versions

v0.71:
add hacking menu and lootbox opening logic (inventory lootboxes and container lootboxes)

v0.8:
at -10 relation, bank confiscates money, closes account, hires bounty hunters to hunt player 
(0.81,0.82,0.83,0.84,0.87,0.88,0.89,0.810) bug fixes
(0.84) vault no longer produces food or stores solids, now uses vault modules
(0.85) reworked bank office logic and updated wares for aiscript
(0.86) updated bank transport aiscript and factionlogic_stations
(0.88) note: create stations disabled and all banking clan objects destroyed

v0.91:
cleaned code. reset accounts (withdraw money before installing). added bribe to reopen account. added loans
(0.92) reworked aiscript. added wares to bnc transports. improved loan menu. 
(0.93) Note: Accounts Reset, withdraw before updating. bug fixes. lootboxes persist for 24hrs. bankingclan rep locked. player loses bankingclan rep when attacking/destroying bank transports. faction rep increases every 30 minutes based on amount deposited in account and every loanpayment. lose faction rep when missing a payment due to not enough funds in account
(0.94) bug fixes. debug messages added.
(0.95) Note: Accounts Reset, withdraw before updating. bug fixes
(0.96) Note: Accounts Reset, withdraw before updating. bug fixes
(0.97) bug fixes
(0.98) bug fixes, account menu updates