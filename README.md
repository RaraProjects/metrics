This project seeks to provide detailed battle metrics for Final Fantasy XI. This is built for Ashita and intended to be used on the HorizonXI server.

Metrics is broken up in several windows each with its own purpose.

**Team**<br>
This screen resembles your typical parser.

![xiloader_khKNyjxMOM](https://github.com/RaraProjects/metrics/assets/72292212/22c56167-a794-4a63-b11d-e29201370d05)<br>
Sample data for the Teams tab (with all columns expanded).

![xiloader_63jzfuUTm6](https://github.com/RaraProjects/metrics/assets/72292212/8c25378f-76c2-4bc8-9a7d-7e4986b41f2b)<br>
Sample data for the Teams tab (mini mode with pet data expanded).

![xiloader_hnwQq6vUhd](https://github.com/RaraProjects/metrics/assets/72292212/10a16453-a687-41c6-afd0-fc7970be188a)<br>
Sample data for the Team tab (nano mode).

Features
1. Members are ranked in decending order.
2. The parser can be configured to show up to 18 members.
3. Various columns show a breakdown of where the player's total damage is coming from.
4. Additional columns can be toggled in such as a breakdown of pet damage and healing.
5. There are two types of accuracy: The standard accuracy that accumulates over time and a windowed accuracy that is your most recent accuracy over the past {X} amount of attack attempts. The default for {X} is 25 attempts and thus is called A-25. Having a view of your most recent accuracy is useful because you can make adjustments as the situation changes.
6. There are a few different modes: Full, Mini, and Nano. Mini mode is just a smaller version of full mode to take up less space on the screen. Nano mode is smaller still. It just shows your total damage and accuracy.
7. A mob filter allows you to pick a mob and only see the damage that everyone did to that specific mob. The filter acts on mob name and not individual mobs. So, if you set it to "Pugil" you will see the damage that all players in the parse did to any mob named "Pugil" even if that was several individual mobs.

**Focus**<br>
Set your attention to a specific player in the parser--including yourself--and then drill down into the various aspects of your actions such as Melee, Weaponskills, Skillchains, Magic, Abilities, Pets, etc.

Melee<br>
![xiloader_r9KdfKXDZz](https://github.com/RaraProjects/metrics/assets/72292212/ca7f54c1-d7d0-46d3-9d21-4e2358e9c7d5)<br>
Sample data for the Melee tab.

1. Total damage, accuracy, crit rate.
2. Main-hand and off-hand damage and accuracy.
3. Total crit damage and how much of your total damage is due to your melee critical hits.
4. Kick attack damage, accuracy, and rate.
5. Enspell damage.
6. Melee damage absorbed by mob (to heal it).
7. Shadows absorbed by melee.


Ranged<br>
![xiloader_mEa0ScMrP7](https://github.com/RaraProjects/metrics/assets/72292212/de969188-74b1-49b8-a627-181cd3eee601)<br>
Sample data for the Ranged tab.

1. Total damage, accuracy, square-hit rate, true-strike hit rate, and crit rate.
2. Total crit damage and how much of your total damage is due to your ranged critical hits.

Weaponskills and Skillchains<br>
![image](https://github.com/RaraProjects/metrics/assets/72292212/7f084dd4-d015-4cf1-bab5-b05f91b2c82b)<br>
Sample data for the Weaponskills tab.

1. Total weaponskill damage and accuracy.
2. Total skillchain damage.
3. Break down of each weaponskill and skillchain with attempts, accuracy, average damage, minimum damage, and maximum damage.
4. You have the option of publishing a player's weaponskill and skillchain data to chat.

Magic<br>
![xiloader_oO892ysiOu](https://github.com/RaraProjects/metrics/assets/72292212/b2c62f10-7daf-4bf7-b336-b7fdc26e23e0)<br>
Sample data for the Magic tab.

1. Total magic damage.
2. Total MP spent and a breakdown of MP spent across nuking, healing, and other types of spells.
3. A breakdown of nuking damage including magic burst damage and damage per MP.
4. A breakdown of healing spells including overhealing and HP recovered per MP.
5. Total MP drained.
6. Enspell damage (this doesn't double count with melee).
7. A breakdown of each spell including damage, total MP used, damage/healing per MP, casts, bursts/overheal, average damage, minimum damage, and maximum damage.

Abilities<br>
![xiloader_pdpRM0MPry](https://github.com/RaraProjects/metrics/assets/72292212/12d55fae-f15f-4edf-8613-ebccb6063789)<br>
Sample data for the Abilities tab.

1. How many of each ability were used.
2. Total ability damage and a breakdown of how much damage was caused by each ability used.

Pets<br>
![xiloader_hFrv0Y8GAz](https://github.com/RaraProjects/metrics/assets/72292212/2e7a5008-af96-4100-b6cb-1b160b637b51)<br>
Sample data for the Pets tab.

1. Captures actions taken BST pets, avatars, and wyverns.
2. Provides a breakdown of each ability used by the pet similar to skillchains.
3. Handles wyvern breaths including healing breaths (which are counted toward player healing).

**Battle Log**<br>
![xiloader_d4z50wIayI](https://github.com/RaraProjects/metrics/assets/72292212/11e6d5ef-ea25-4914-bb8e-079e8541beb7)<br>
Sample data for the Battle Log.

Maintain line of sight on the more important pieces of the battle without dealing with the game chat. Some neat features here are that you can see the TP at which a player used a weaponskill or see how many mobs were hit by an AOE spell.
