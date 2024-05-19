This project seeks to provide detailed battle metrics for Final Fantasy XI. This is built for Ashita and intended to be used on the HorizonXI server.

## Table of Contents<br>
1. [Introduction](#introduction)
2. [Parse](#parse)
3. [Focus](#focus)
4. [Battle Log](#battle-log)
5. Report
6. Settings

## Introduction
Metrics is broken up in several windows each with its own purpose.

## Parse
This screen resembles your typical parser. It shows things like DPS, total damage, accuracy, and various damage breakdown column. There are three different modes to view the parser depending on how much detail you want to see at the time (and how much screen space you are willing to commit to that data).

### Full Mode
![image](https://github.com/RaraProjects/metrics/assets/72292212/0a4cc710-89b7-436c-aa21-f1fb269c649f)<br>
_Sample data for the Parse tab (with extra damage breakdown columns expanded)._<br>

This gives you access to the full suite of parse data and takes up the most screen space. Here are some of the more prominent features:
1. Members are ranked and displayed in decending order. You will always be shown even if you aren't in the visible ranks.
2. The parser can be configured to show up to 18 members.
3. Track your total and running accuracy. Running accuracy is your accuracy as of the last {X} amount of hits. It's beneficial to know this because you will be able to see sudden dips in accuracy (blind, food loss, etc.) much faster with the smaller lookback window. This amount of hits to look back, {X}, is configurable. The running accuracy column is called **A-{X}**.
4. Various columns can be toggled in and out to show a breakdown of where your damage is coming from.
   * This includes pet damage, healing, and deaths.
5. There is a column to show you your DPS.
   * Your DPS window is comprised of {Y} amount of buckets.
   * Every {X} amount of seconds a snapshot is taken of the damage you've done in that time and stored in a bucket.
   * The damage from each bucket is summed and averaged over the total DPS window (X * Y seconds).
   * Example:
     * Snapshot taken every X = 3 seconds.
     * A DPS window with Y = 3 buckets.
     * Total DPS window = 9 seconds.
     * The damage you do (or don't do) will affect your DPS every 3 seconds. If you do nothing your DPS will drop to zero in 9 seconds.
6. The duration timer tracks how long actions have been actively taking place. If 5 seconds pass with no one affiliated with you taking an action then the duration timer will pause and restart automatically upon the next action. Data collection is not affected by this timer.
7. A mob filter allows you to pick a mob and only see the damage that everyone did to that specific mob. The filter acts on mob name and not individual mobs. So, if you set it to "Pugil" you will see the damage that all players in the parse did to any mob named "Pugil" even if that was several individual mobs.
    
### Mini Mode
![image](https://github.com/RaraProjects/metrics/assets/72292212/aad2da70-68cb-4b31-80db-e1bcca50b4c2)<br>
_Sample data for the Parse Mini Mode (with pet data expanded)._<br>

Mini mode is just like the full mode, but it's designed to be small. You can't really add any columns here with the exception of a couple pet columns. This is the mode to use if you want to just cruise in parse mode without a large investment in screen space.

![image](https://github.com/RaraProjects/metrics/assets/72292212/b3df7378-5e75-4d6b-83ee-800599531f3a)<br>
_Sample data for the Parse Nano Mode._<br>

Nano mode is as concise as it gets. If you really only care about what you're doing then this is the mode for you. Other players will not show up here.

## Focus
Set your attention to a specific player in the parser--including yourself--and then drill down into the various aspects of your actions such as Melee, Weaponskills, Skillchains, Magic, Abilities, Pets, Defense, etc.

### Melee
![image](https://github.com/RaraProjects/metrics/assets/72292212/6466de0c-ffd9-47b1-a5e7-9fbc9f9e5dba)<br>
_Sample data for the Melee tab._
* _Multi-Attack largely from WAR/NIN Kraken Club/Ridill_
* _Enspell largely from RDM_
* _Endrain and Enaspir from DNC_
* _Count and Kick Attacks from MNK_
* _Shadows were attacks absorbed by Blink (Damage isn't the best name for the column.)_

This tab should show you most of the melee information you would be interested in. Note how you can get a main-hand and off-hand breakdown. Information only populates as it is performed so this screen usually won't be as busy as it is in the sample data pictured above. Not pictured in the image above is melee damage that heals the mob. That is tracked too.

### Ranged
![image](https://github.com/RaraProjects/metrics/assets/72292212/16a1d64f-105a-422f-bb93-09aa11513228)<br>
_Sample data for the Ranged tab._

Pretty much the same deal as melee though there are less ranged stats to pull that I'm aware of. Ninja's Daken trait is included in this tab.

### Weaponskills and Skillchains
![image](https://github.com/RaraProjects/metrics/assets/72292212/ff99b6d6-6cf2-4e74-98d8-e19cc0ee2568)<br>
_Sample data for the Weaponskills tab._

This tab breaks down your weaponskill and skillchain damage both in total and by individual weaponskill and skillchain.

### Magic
![image](https://github.com/RaraProjects/metrics/assets/72292212/aa7c164d-db8f-4269-b2ed-372787e0d52f)<br>
_Sample data for the Magic tab._

The Magic tab works about as you would expect after reading through the other tabs. It gives an overall breakdown of not only damage, but also MP spent for various categories of spells and then provides the same stats for each individual spell. There are a few additional points to note:

1. **Efficacy:** Capturing the damage and MP spent on a spell allows for the calculation of damage per MP. I call this Efficacy. This stat allows you gauge how much damage you're getting for your MP. Higher efficiancy isn't _always_ better though. For example, lower tier spells may give you higher efficacy, but come at the cost of needing to cast multiple times in order to achieve the same damage (which takes up time that you could be casting other more damaging spells).
2. **Overcure:** This stat attempts to gauge how often you are using healing spells that are of higher tier than necessary. If another player is missing 100 HP and you cast a healing spell that can heal up to 400 HP then you overcured by 300 HP. Maybe it would have been better to cast a lower tier spell. The way this is calculated isn't straightforward as it can't be measured directly. The gist is that Metrics will keep track of the max amount of HP you have healed for using any given spell. If you heal over that amount with the same spell then the overcure will be (Max Heal Registered - HP Healed). Divine Seal cures can really boost your max so I have some limits in place to try and make sure that Divine Seal doesn't ruin the calculation.
4. **Magic Bursts:** If you magic burst you will be shown how much MB damage you have done, what percent of your total damage is MB damage, and what percent of your magic damage is MB damage. Additionally, a count of magic bursts is recorded for each nuking spell.
5. **Resist Rates:** Each enfeeble spell has a "Land Rate" column. This is essentially the resist rate. If your land rate is 82% then your resist rate will be 18%.
6. **Enspell:** Enspell has a column called "Hits." That is how many times you struck the mob with your enspell i.e. how many times your enspell procced.
7. **MP Drain:** This isn't counted toward total damage. Instead, this is a measure of how much MP you've drained from mobs using spells like Aspir.
8. **Spikes:** This is how much damage you've caused by a mob hitting you and proccing a spike effect.

### Abilities
![xiloader_pdpRM0MPry](https://github.com/RaraProjects/metrics/assets/72292212/12d55fae-f15f-4edf-8613-ebccb6063789)<br>
Sample data for the Abilities tab.

1. How many of each ability were used.
2. Total ability damage and a breakdown of how much damage was caused by each ability used.

### Pets
![xiloader_hFrv0Y8GAz](https://github.com/RaraProjects/metrics/assets/72292212/2e7a5008-af96-4100-b6cb-1b160b637b51)<br>
Sample data for the Pets tab.

1. Captures actions taken BST pets, avatars, and wyverns.
2. Provides a breakdown of each ability used by the pet similar to skillchains.
3. Handles wyvern breaths including healing breaths (which are counted toward player healing).

## Battle Log
![xiloader_d4z50wIayI](https://github.com/RaraProjects/metrics/assets/72292212/11e6d5ef-ea25-4914-bb8e-079e8541beb7)<br>
Sample data for the Battle Log.

Maintain line of sight on the more important pieces of the battle without dealing with the game chat. Some neat features here are that you can see the TP at which a player used a weaponskill or see how many mobs were hit by an AOE spell.
