This project seeks to provide detailed battle metrics for Final Fantasy XI. This is built for Ashita and intended to be used on the HorizonXI server.

Metrics is broken up in several windows each with its own purpose.

**Team**<br>
This screen resembles your typical parser.
<br><br>Features
1. Members are ranked in decending order.
2. The parser can be configured to show up to 18 members.
3. Various columns show a breakdown of where the player's total damage is coming from.
4. Additional columns can be toggled in such as a breakdown of pet damage and healing.
5. There are two types of accuracy: The standard accuracy that accumulates over time and a windowed accuracy that is your most recent accuracy over the past {X} amount of attack attempts. The default for {X} is 25 attempts and thus is called A-25. Having a view of your most recent accuracy is useful because you can make adjustments as the situation changes.
6. There are a few different modes: Full, Mini, and Nano. Mini mode is just a smaller version of full mode to take up less space on the screen. Nano mode is smaller still. It just shows your total damage and accuracy.
7. A mob filter allows you to pick a mob and only see the damage that everyone did to that specific mob. The filter acts on mob name and not individual mobs. So, if you set it to "Pugil" you will see the damage that all players in the parse did to any mob named "Pugil" even if that was several individual mobs.

**Focus**<br>
Set your attention to a specific player in the parser--including yourself--and then drill down into the various aspects of your actions such as Melee, Weaponskills, Skillchains, Magic, Abilities, Pets, etc.
<br><br>Melee
1. Total damage, accuracy, crit rate.
2. Main-hand and off-hand damage and accuracy.
3. Total crit damage and how much of your total damage is due to your melee critical hits.
4. Kick attack damage, accuracy, and rate.
5. Enspell damage.
6. Melee damage absorbed by mob (to heal it).
7. Shadows absorbed by melee.
<br><br>Ranged
1. Total damage, accuracy, square-hit rate, true-strike hit rate, and crit rate.
2. Total crit damage and how much of your total damage is due to your ranged critical hits.
<br>Weaponskills and Skillchains
1. Total weaponskill damage and accuracy.
2. Total skillchain damage.
3. Break down of each weaponskill and skillchain with attempts, accuracy, average damage, minimum damage, and maximum damage.
<br><br>Magic
1. Total magic damage.
2. Total MP spent and a breakdown of MP spent across nuking, healing, and other types of spells.
3. A breakdown of nuking damage including magic burst damage and damage per MP.
4. A breakdown of healing spells including overhealing and HP recovered per MP.
5. Total MP drained.
6. Enspell damage (this doesn't double count with melee).
7. A breakdown of each spell including damage, total MP used, damage/healing per MP, casts, bursts/overheal, average damage, minimum damage, and maximum damage.
<br><br>Abilities
1. How many of each ability were used.
2. Total ability damage and a breakdown of how much damage was caused by each ability used.
<br><br>Pets
1. Captures actions taken BST pets, avatars, and wyverns.
2. Provides a breakdown of each ability used by the pet similar to skillchains.
3. Handles wyvern breaths including healing breaths (which are counted toward player healing).

**Battle Log**<br>
Maintain line of sight on the more important pieces of the battle without dealing with the game chat. Some neat features here are that you can see the TP at which a player used a weaponskill or see how many mobs were hit by an AOE spell.
