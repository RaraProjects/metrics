Update 11/10/24: New updates coming (hopefully) in November. You can see a preview on the Testing branch.

## Introduction
![image](https://github.com/user-attachments/assets/8a158cf7-21e7-4835-b4a4-ada65169cad4)<br>

Metrics is a DPS parsing tool at it's core, but it can take you much deeper into the data than the typical parser. There are views to keep things simple if that's all you want, but for those hungry for the most specific of data, Metrics tries to provide that in the most complete, aesthetically pleasing, and usable way possible.

Each of the modules described below can be displayed in either a single window with each module contained within its own tab or you can enable multi window mode to show multiple modules at once and house them in different areas of the screen simultaneously. If you use multi window mode just use the hub bar to toggle certain windows on and off.

[Join the Discord](https://discord.gg/u5yqUbR6R7) to ask questions, discuss feature requests, be alerted to updates, and report bugs.

## How to Install
Metrics uses Github's release feature to distribute the code. Within the Releases page you can see the current and previous releases and pre-releases. Each release should have patch notes specific to that release. I publish pre-releases in between major releases. So, if you want to try out newer features sooner you can check those out. Pre-releases are _usually_ mostly stable.

1. On the right side of the Github page (to the right of all the files) there is a section called "Releases".
2. Click the release that is marked as "Latest".
3. Inside the release there is a file called metrics.zip. Download that. You don't need the "Source code" files.
5. Go to your download location and extract metrics.zip. You should end up with a folder called "rsvp".
6. Put that "rsvp" folder in your addon folder. For Horizon it's probably something like ~/HorizonXI/Game/addons.

## Module Overview<br>
1. [Parse](#parse)
2. [Focus](#focus)
3. [Battle Log](#battle-log)
4. [XP](#xp)
5. [Report](#report)
6. [Settings](#settings)

## Parse
![image](https://github.com/user-attachments/assets/8a158cf7-21e7-4835-b4a4-ada65169cad4)<br>
_Parse - Full Mode_

This screen resembles your typical parser. It shows things like DPS, total damage, accuracy, and various other damage breakdown columns. There are three different modes to view the parser depending on how much detail you want to see at the time (and how much screen space you are willing to commit to that data).

### Overview
1. Members are ranked and displayed in decending order. You will always be shown even if you aren't in the visible ranks.
2.Supports showing up to 18 party and alliance members.
3. Track your total and recent accuracy. Recent accuracy is your accuracy as of the last {X} amount of hits. The amount of hits to look back, {X}, is configurable. It's beneficial to know this because you will be able to see sudden dips in accuracy (blind, food loss, etc.) much faster with the smaller lookback window. The running accuracy column is called **%A.{X}**.
4. Various columns can be toggled in and out to show a breakdown of where you and your affiliates' damage is coming from. This includes pet damage, healing, deaths, etc.
5. The active timer tracks how long actions have been actively taking place. If 5 seconds pass with no one affiliated with you taking an action, then the duration timer will pause automatically and then subsequently restart automatically upon the next action by someone in your party or alliance. Data collection is not affected by this timer.
6. A mob filter allows you to pick a mob and only see the damage that everyone did to that specific mob. The filter acts on mob name and not individual mobs. So, if you set it to "Pugil" you will see the damage that all players in the parse did to any mob that has "Pugil" in the name even if that was several individual mobs.
7. Skillchain damage can be included or excluded in the parse totals. You will still be able to see skillchain damage on player specific overviews even if you exclude it from the parse data.
8. Player names can be masked by replacing the name with the player's job to make it easier for taking screenshots with privacy in mind.

### Available Columns
| Setting Name | Header | Description |
|----------|----------|----------|
| Focus Jump | Focus | Allows you to jump directly into the Focus view for that player. |
| Show Jobs | Job | Player's main job level and sub job level. The jobs are color coded with job colors. |
| Always Present | Name | The player's name. The name is color coded with job colors. |
| Always Present | Total | The total damage the player has done. |
| Always Present | %Total | The percent of total party damage the player has done. |
| Melee Delay | s/Melee | The average amount of seconds between each melee attack. The speed of your last three melee attacks is averaged together. Delays longer than 15 seconds are discarded. |
| DPS | DPS | Damage per Second. See DPS explanation for more details. |
| Acc. Recent | %A.# | Recent accuracy for the last # of melee/ranged attempts.  |
| Acc. Combined | %A-Total | Total accuracy of melee/range attempts since the parse has been running. |
| Total Crit | %Crit | Combined melee/ranged critical hit rate. |
| Melee Damage | Melee | Total melee damage. |
| Acc. Melee | M.Acc | Total melee accuracy. |
| Melee Crit | %M.Crit | Melee critical hit rate. |
| WS Total | WS | Total weaponskill damage. |
| WS Average | WS Avg | Average weaponskill damage across all weaponskills used. |
| WS ~TP | WS ~TP | Average TP spent across all weaponskills used. |
| WS Accuracy | WS Acc | Average WS accuracy across all weaponskills used. |
| Include SC Damage | SC | Total skillchain damage. This is only available if skillchain damage is enabled. |
| Ranged Damage | Ranged | Total ranged attack damage. |
| Acc. Ranged | R.Acc | Total ranged accuracy. |
| Ranged Crit | %R.Crit | Ranged critical hit rate. |
| Shot Distance | R.Dist | Average ranged attack distance from target. |
| Nukes | Magic | Total magic damage. |
| Abilities | JA | Total job ability damage. |
| Pet Accuracy | P.Acc | Pet melee accuracy. |
| Pet Melee | P.Melee | Total pet melee damage. |
| Pet Ranged | P.RA | Total pet ranged damage. |
| Pet WS | P.WS | Total pet weaponskill damage. This would be BST pet TP moves. |
| Pet Ability | P.JA | Total pet ability damage. This would be SMN rage blood pacts. |
| Healing | Healing | Total healing done. |
| Damage Taken | DT | Total damage taken. |
| Deaths | Deaths | Total amount of deaths for this player. |

### DPS Calculations
There are two types of DPS calculations available to you: Average and Recent. You can toggle between the two types in the Parse settings window.

#### Recent DPS
* Your DPS window is comprised of {Y} amount of buckets.
* Every {X} amount of seconds a snapshot is taken of the damage you've done in that time and stored in a bucket.
* The damage from each bucket is summed and averaged over the total DPS window (X * Y seconds).
* Example:
  * Snapshot taken every X = 3 seconds.
  * A DPS window with Y = 3 buckets.
  * Total DPS window = 9 seconds.
  * The damage you do (or don't do) will affect your DPS every 3 seconds. If you do nothing your DPS will drop to zero in 9 seconds.
 
#### Average DPS
Takes the total amount of damage the player has done and divides it by the active timer. The active auto-pauses after 5 seconds of inactivity in your party so the DPS won't be affected by travel time etc.

### Overview
![image](https://github.com/user-attachments/assets/1ea7ed96-9051-40f9-bd50-6ca49414e087)<br>
_Parse - Overview_

For a more detailed view of parse items, you can open the parse overview with the Overview button on the parse window. From the overview you can toggle various views that include: Melee, Ranged, Weaponskills, Nuking, Pets, Healing and Defense. This view will rank players along with their individual actions giving you view that is hybrid of the Parse and Focus windows. A Mobs Defeated view is also available if you want to see how many of each mob you've killed. Note: One known weakness of the Mobs Defeated counter is that it cannot count mobs that die to a DoT (for now) since there isn't player associated with the action.

## Focus
![image](https://github.com/user-attachments/assets/47477d68-0aaa-41c7-982f-df0482ab500a)<br>
_Focus - Overview_

Focus your attention on a specific player in the parser--including yourself--and then drill down into the various aspects of your actions such as Melee, Ranged, Weaponskills, Skillchains, Magic, Abilities, Pets, Defense, etc. The focus view starts on an Overview tab that shows some job specific highlights for that specific job.

### Melee
![image](https://github.com/user-attachments/assets/7024a9bd-acad-4d55-af7b-dc088a7b4430)<br>
_Focus - Melee_

This tab should show you most of the melee information you would be interested in. Main-hand and off-hand breakdowns are available. Some other interesting metrics not pictured in the example screenshot include: Kick Attacks, Counter, En-damage, En-Spell, En-Drain, En-Aspir, mob damage absorption, and shadow absorption. Multi-Attack supports all the way up to 8 multi-attacks for the Kraken Club.

### Ranged
![image](https://github.com/user-attachments/assets/a768dd42-84c9-4127-8924-26f49ef6281a)<br>
_Focus - Ranged_

Pretty much the same deal as melee but ranged stats. Additional not pictured metrics include: En-Damage and En-Drain.

### Weaponskills and Skillchains
![image](https://github.com/user-attachments/assets/0c4c07ce-9e19-4cf6-9b18-75647ddb5bc6)<br>
_Focus - Weaponskills_

This tab breaks down your weaponskill and skillchain damage both in total and by individual weaponskill and skillchain. You can also keep track of how many skillchains you've opened or closed.

### Magic
![image](https://github.com/user-attachments/assets/332a7d81-7a69-496b-9a44-1f4285e597b2)<br>
_Focus - Magic_

The Magic tab works about as you would expect after reading through the other tabs. It contains quite a bit of information. Different spell types like nuking, enfeebles, debuff removal, healing, etc. each have their own section. There is overall breakdown of not only damage, but also MP spent which allows for an interesting DMG/MP metric i.e. how much damage are you getting for your MP spent per spell. Bursts and overcure are also available for nuking and healing respectively.

| Term | Description |
|----------|----------|
| DMG/MP | Capturing the damage and MP spent on a spell allows for the calculation of damage per MP. I call this Efficacy. This stat allows you gauge how much damage you're getting for your MP. Higher efficiancy isn't _always_ better though. For example, lower tier spells may give you higher efficacy, but come at the cost of needing to cast multiple times in order to achieve the same damage (which takes up time that you could be casting other more damaging spells). |
| Overcure | This stat attempts to gauge how often you are using healing spells that are of higher tier than necessary. If another player is missing 100 HP and you cast a healing spell that can heal up to 400 HP then you overcured by 300 HP. Maybe it would have been better to cast a lower tier spell. The way this is calculated isn't straightforward as it can't be measured directly. The gist is that Metrics will keep track of the max amount of HP you have healed for using any given spell. If you heal over that amount with the same spell then the overcure will be (Max Heal Registered - HP Healed). Divine Seal cures can really boost your max so I have some limits in place to try and make sure that Divine Seal doesn't ruin the calculation. |
| Magic Bursts | If you magic burst you will be shown how much MB damage you have done, what percent of your total damage is MB damage, and what percent of your magic damage is MB damage. Additionally, a count of magic bursts is recorded for each nuking spell. |
| Resist Rates | Each enfeeble spell has a "%Land" (land rate) column. This is essentially the resist rate. If your land rate is 82% then your resist rate will be 18%. |
| Enspell | Enspell has a column called "Hits." That is how many times you struck the mob with your enspell i.e. how many times your enspell procced. |
| MP Drain | This isn't counted toward total damage. Instead, this is a measure of how much MP you've drained from mobs using spells like Aspir. |
| Spikes | This is how much damage you've caused by a mob hitting you and proccing a spike effect. |

### Abilities
![image](https://github.com/user-attachments/assets/6d484f50-9ddd-48fe-befc-dfb96fc85cd0)<br>
_Focus - Abilities_

Shows some stats for offensive and non-offensive abilities. Some not pictured scenarios include: Chakra healing, MP given via Devotion, etc.

### Pets
![image](https://github.com/user-attachments/assets/24acd671-3bd2-4874-b92f-45fbcc047f98)<br>
_Focus - Pets_

Similar to other tabs. Here are some interesting points:
1. Captures actions taken BST pets, avatars, and wyverns. Each pet gets its own tab.
2. Provides a breakdown of each ability used by the pet.
3. Handles wyvern breaths including healing breaths (which are counted toward player healing).

### Defense
![image](https://github.com/user-attachments/assets/ed26b900-fc98-4232-8c0f-dffa0a9a9005)<br>
_Focus - Defense_

This tab shows how much damage you and/or your pet has taken with a breakdown of what types of damage that total damage is comprised of. Additionally, it can show you how often mobs are hitting you with critical strikes and how often you are mitigating their attacks with evasion, parry, shield, etc and how much theoretical damage you mitigated via those actions. Healing received is also available. A list of the mobs TP moves performed against you is shown at the bottom along with relevant stats.

**Note:** I had to manually go through a couple thousand mob TP moves and pick out which ones deal damage. I used a wiki to help with this, but sometimes the wiki isn't great. If you find that there is a mob TP move that should do damage--but isn't--or a mob that shouldn't do damage--that is--then please let me know and I can update my filter list.

## Battle Log
![image](https://github.com/user-attachments/assets/79cbe95e-7dbb-47a7-b40b-d2fd28f530c1)<br>
_Example of Battle Log output._

Maintain line of sight on the more important pieces of the battle without having to deal with the game chat. Some neat features here are that you can see the TP at which a player used a weaponskill, how many mobs were hit by an AOE spell, if a nuke was a magic burst etc, if a debuff was resisted, which debuff was dispelled, which debuff was removed with Erase, etc. The jobs are color coded. The battle log can hold up to 100,000 items before starting to overwrite the old data. You can adjust the length of the battle log and filter various actions at will.

### Filterable Actions
* Melee
* Ranged
* Weapsonskills
* Skillchains
* Nukes
* Healing
* Song Buffs
* Phantom Roll (when ToAU comes out)
* Abilities
* Player Deaths
* Pet Melee
* Pet TP / Abilities
* Pet Healing
* Pet Commands
* Mob Melee
* Mob TP
* Mob Spells
* Mob Deaths

## XP
![image](https://github.com/user-attachments/assets/b0ded823-639c-4711-b6e2-4348e587e032)<br>
_Sample data for the XP module. The yellow bar is progress through the level. The red bar is progress through the dedication buff._
The XP module tracks various experience/limit point related things. Aside from the basics, here are some unique things the XP module can do:

1. The XP rate calculation is more immediate (isn't affected as much by old XP gained) and spools up within a couple kills.
2. Gives you an estimated time remaining until you level up.
3. Tracks dedication (XP boost). You can see how far along you are in your dedication buff. This saves between sessions and across characters.
4. Can show you the base XP rate of your party even if you have dedication on.
5. Tracks some unique metrics like time per kill, XP per kill, and maximum chain achieved.
6. Progress bars are available and optional. They come in full size and compact forms.

### XP Calculation
1. Calculate average XP. This is the average of the XP gained over the last 6 mobs defeated.
2. Calculate average kill time. This is the average amount of seconds it took to defeat the last 6 mobs.
3. XP/hr = (Average XP / Average Kill Time) * 3600

### Available Columns
| Column | Description |
|----------|----------|
| Job | Displays the player's main and sub job with levels and color coding. |
| Chain | Current chain and how much time is left in the current chain. |
| *XP/hr | XP per hour rate is--including dedication. |
| XP/hr | XP per hour rate minus dedication. |
| Time/Kill | Average amount of time it takes to kill an XP mob. |
| XP/Kill | The average amount of XP you're getting per mob. |
| ~TTL | Approximate time remaining until you level. |
| TNL | How many experience points remain until you level. |
| Total | How much XP you've gained this session. This can be split into base and dedication XP. |
| Max Chain | The maximum chain you were able to achieve this session. |
| Zone Time | How long you've been in the current zone. |
| Bonus | The currently active dedication item. |
| Bonus % | The currently active dedication rate. |
| Bonus Max | How much bonus XP you've gained out of the total allotment. |

## Report
![image](https://github.com/user-attachments/assets/5c504c29-70df-4e9f-8166-6691c52f849f)<br>
_Example of the Report tab._

You can use the chat report quick buttons to output some reports to the chat. You can pick the chat mode. Please be courteous to your neighbors when you use anything other than party. You can also output the database and Battle Log to a CSV for your own analysis. Currently I just output a the raw data, but I'm thinking about creating a Google doc or Excel template that can be used to build higher level summaries like in the Focus tab. The CSV will contain only the data nodes that have non-zero values keep creating files as quick as possible.

## Settings
![image](https://github.com/user-attachments/assets/7b4eba23-8c5f-4fc6-9aa6-13da233a7b1f)<br>
_Example of the Settings tab._

There are a few settings that need their own spot. One of the biggest is controlling how the window looks. The Help tab contains some chat commands and the current version number. I tend to update frequently so it's always good to know which version you're on compared to the latest version.

Multi Window mode let's you have multiple modules open at the same time in their own window and the Show Mouse option forces your mouse to be visible if your mouse often turns invisible when hovering over an ImGUI based component.
